---
jupytext:
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.16.2
kernelspec:
  display_name: Python 3 (ipykernel)
  language: python
  name: python3
---

# Files and Exception Handling

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/python/07_files.ipynb)

## Overview

This lecture introduces techniques for working with files and handling exceptions in Python, focusing on their importance in geospatial programming. Managing files effectively is crucial when reading, writing, or processing geospatial data. Exception handling is equally important as it allows your programs to gracefully manage errors, ensuring that your code remains robust and reliable even in the face of unexpected issues.

## Learning Objectives

By the end of this lecture, you should be able to:

- Read from and write to files in Python, with a particular focus on handling geospatial data.
- Implement exception handling using `try`, `except`, and `finally` blocks to manage errors that may occur during file operations.
- Combine file handling and exception handling to create robust and reliable geospatial applications.
- Develop the skills to identify and manage common issues in file processing, such as missing files, corrupt data, or formatting errors.
- Ensure that your geospatial programs can handle real-world data scenarios effectively by using best practices for file and exception handling.

+++

## Creating a Sample File

Before working with files, it's essential to ensure that the files you intend to process actually exist. In this section, you'll learn how to create a sample `coordinates.txt` file programmatically. This file will be used in subsequent examples.

```{code-cell} ipython3
# Create a sample coordinates.txt file
sample_data = """35.6895,139.6917
34.0522,-118.2437
51.5074,-0.1278
-33.8688,151.2093
48.8566,2.3522"""

output_file = "coordinates.txt"

try:
    with open(output_file, "w") as file:
        file.write(sample_data)
    print(f"Sample file '{output_file}' has been created successfully.")
except Exception as e:
    print(f"An error occurred while creating the file: {e}")
```

In this code, we create a simple text file named `coordinates.txt` containing latitude and longitude pairs for several cities around the world. The file is written in the current working directory.

After running this script, the `coordinates.txt` file will be available for use in the following examples. If any issues occur during the file creation process, the script will handle them and print an error message.

+++

## Working with Files

In geospatial programming, you often need to read from or write to files. Python provides built-in functions to handle these tasks. Let's start by reading from a text file containing coordinates and writing the results to a new file.

```{code-cell} ipython3
# Example of reading coordinates from a file and writing to another file
input_file = "coordinates.txt"
output_file = "output_coordinates.txt"

try:
    with open(input_file, "r") as infile:
        coordinates = infile.readlines()

    with open(output_file, "w") as outfile:
        for line in coordinates:
            lat, lon = line.strip().split(",")
            outfile.write(f"Latitude: {lat}, Longitude: {lon}\n")

    print(f"Coordinates have been written to {output_file}")
except FileNotFoundError:
    print(f"Error: The file {input_file} was not found.")
```

## Exception Handling

Exception handling allows you to handle errors that occur during the execution of your program. This is especially important in geospatial programming, where you may encounter issues such as missing files, corrupt data, or invalid input.

Let's explore how to handle different types of exceptions using `try`, `except`, and `finally`.

```{code-cell} ipython3
# Example of exception handling when parsing coordinates
def parse_coordinates(line):
    try:
        lat, lon = line.strip().split(",")
        lat = float(lat)
        lon = float(lon)
        return lat, lon
    except ValueError as e:
        print(f"Error: {e}. Could not parse line: {line.strip()}")
        return None
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        return None


# Example usage
line = "invalid data"
coordinates = parse_coordinates(line)
if coordinates:
    print(f"Parsed coordinates: {coordinates}")
```

## Combining File Handling and Exception Handling

You can combine file handling and exception handling to create robust geospatial applications. This allows you to ensure that files are properly handled even if errors occur during the process.

```{code-cell} ipython3
# Example of robust file handling with exceptions
def process_geospatial_file(input_file):
    try:
        with open(input_file, "r") as infile:
            for line in infile:
                coordinates = parse_coordinates(line)
                if coordinates:
                    print(f"Processed coordinates: {coordinates}")
    except FileNotFoundError:
        print(f"Error: The file {input_file} was not found.")
    except Exception as e:
        print(f"An unexpected error occurred while processing the file: {e}")
    finally:
        print(f"Finished processing {input_file}")


# Example usage
process_geospatial_file("coordinates.txt")
```

## Reading GeoJSON Data from a URL

In geospatial programming, it's common to access datasets hosted online. For instance, we may need to read GeoJSON data directly from a URL. Python's requests library makes it easy to retrieve such data. In this example, we'll read a GeoJSON file containing U.S. cities and handle any exceptions that may arise.

First, ensure you have the requests library installed. Uncomment and run the following command if you haven't already installed it.

```{code-cell} ipython3
# !pip install requests
```

Import the required libraries and read the GeoJSON data from the URL.

```{code-cell} ipython3
import requests
```

In this case, we will read the GeoJSON data for world cities hosted at https://github.com/opengeos/datasets/releases/tag/world, and process it to extract the names and coordinates of the cities.

```{code-cell} ipython3
url = (
    "https://github.com/opengeos/datasets/releases/download/world/world_cities.geojson"
)
```

Let's define a function to read the GeoJSON data from the URL and extract the city names and coordinates. We'll also handle any exceptions that may occur during the process.

```{code-cell} ipython3
def fetch_geojson(url):
    try:
        response = requests.get(url)
        response.raise_for_status()  # Raises an exception for HTTP errors
        geojson_data = response.json()  # Parse the JSON response
        return geojson_data
    except requests.exceptions.HTTPError as http_err:
        print(f"HTTP error occurred: {http_err}")
    except requests.exceptions.ConnectionError as conn_err:
        print(f"Error connecting to the server: {conn_err}")
    except Exception as err:
        print(f"An error occurred: {err}")
    return None


# Fetch and print a summary of the data
geojson_data = fetch_geojson(url)
```

Uncomment and run the following code to display the data read from the URL.

```{code-cell} ipython3
# geojson_data
```

The output above is lengthy, so we'll only display the first few cities. You can modify the code to display more cities if needed.

```{code-cell} ipython3
if geojson_data:
    features = geojson_data.get("features", [])
    print(f"Number of cities: {len(features)}")

    # Extract city ids and their coordinates
    for feature in features[:5]:  # Display first 5 cities
        city_name = feature["properties"].get("name")
        country_name = feature["properties"].get("country")
        coordinates = feature["geometry"]["coordinates"]
        print(f"Name: {city_name}, Country: {country_name}, Coordinates: {coordinates}")
```

## Exercises

1. Create a function that reads a file containing a list of city names and their coordinates. The function should handle exceptions if the file is missing or if a line in the file is not properly formatted.
2. Write a function that writes a list of coordinates to a file. Include exception handling to ensure that the file is properly closed even if an error occurs during writing.
3. Create a robust geospatial data processing function that reads data from a file, processes it, and writes the results to another file. Ensure that all potential errors are handled appropriately.

```{code-cell} ipython3

```

## Summary

Working with files and handling exceptions are critical skills in geospatial programming. By mastering these techniques, you can create more reliable and efficient geospatial applications that handle real-world data gracefully.
