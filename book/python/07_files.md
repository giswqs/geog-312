---
jupytext:
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.16.2
kernelspec:
  display_name: Python 3
  language: python
  name: python3
---

# Files and Exception Handling

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/python/07_files.ipynb)

This notebook introduces how to work with files and handle exceptions in Python, with a focus on geospatial data. Working with files is a common task in geospatial programming, whether you are reading data from a file, writing results to a file, or processing large datasets. Exception handling is crucial for writing robust code that can handle errors gracefully.

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

## Exercises

1. Create a function that reads a file containing a list of city names and their coordinates. The function should handle exceptions if the file is missing or if a line in the file is not properly formatted.
2. Write a function that writes a list of coordinates to a file. Include exception handling to ensure that the file is properly closed even if an error occurs during writing.
3. Create a robust geospatial data processing function that reads data from a file, processes it, and writes the results to another file. Ensure that all potential errors are handled appropriately.

```{code-cell} ipython3
# Type your code here
```

## Conclusion

Working with files and handling exceptions are critical skills in geospatial programming. By mastering these techniques, you can create more reliable and efficient geospatial applications that handle real-world data gracefully.
