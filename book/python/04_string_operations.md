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

# String Operations

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/python/04_string_operations.ipynb)

## Overview

This lecture will cover various string operations in Python, with a focus on their application in geospatial contexts. Strings are fundamental in handling textual data, such as names of geographic locations, coordinates, and data extracted from text files. Mastering string operations allows you to effectively manipulate and analyze geographic information, which is essential for tasks like data cleaning, formatting, and parsing.

## Learning Objectives

By the end of this lecture, you should be able to:

- Create and manipulate strings in Python, including concatenation and repetition.
- Apply string methods such as `lower()`, `upper()`, `strip()`, `replace()`, and `split()` to process geospatial data.
- Format strings using the `format()` method and f-strings to include variable data within strings.
- Parse and extract specific information from strings, such as coordinates or location names.
- Utilize string operations in practical geospatial tasks, enhancing your ability to work with and manage geographic data.

+++

## Creating and Manipulating Strings

Strings in Python are sequences of characters. You can create a string by enclosing characters in single or double quotes.

```{code-cell} ipython3
location_name = "Mount Everest"  # A string representing the name of a location
```

You can concatenate (join) strings using the `+` operator:

```{code-cell} ipython3
location_name_full = location_name + ", Nepal"
print(location_name_full)
```

You can also repeat strings using the `*` operator:

```{code-cell} ipython3
separator = "-" * 10
print(separator)
```

## String Methods for Geospatial Data

Python provides various built-in methods to manipulate strings. Some commonly used methods include:

- `lower()`, `upper()`: Convert strings to lowercase or uppercase.
- `strip()`: Remove leading and trailing whitespace.
- `replace()`: Replace a substring with another substring.
- `split()`: Split a string into a list of substrings based on a delimiter.

```{code-cell} ipython3
location_name_upper = location_name.upper()
print(location_name_upper)  # Convert to uppercase
```

```{code-cell} ipython3
location_name_clean = location_name.strip()
print(location_name_clean)  # Remove leading/trailing whitespace
```

```{code-cell} ipython3
location_name_replaced = location_name.replace("Everest", "K2")
print(location_name_replaced)  # Replace 'Everest' with 'K2'
```

```{code-cell} ipython3
location_parts = location_name_full.split(", ")
print(location_parts)  # Split the string into a list
```

## Formatting Strings

String formatting is essential when preparing data for output or when you need to include variable values in strings. You can use the `format()` method or f-strings (in Python 3.6 and above) for string formatting.

```{code-cell} ipython3
latitude = 27.9881
longitude = 86.9250
formatted_coordinates = "Coordinates: ({}, {})".format(latitude, longitude)
print(formatted_coordinates)
```

```{code-cell} ipython3
formatted_coordinates_fstring = f"Coordinates: ({latitude}, {longitude})"
print(formatted_coordinates_fstring)
```

## Parsing and Extracting Information from Strings

Often, you will need to extract specific information from strings, especially when dealing with geographic data. For example, you might need to extract coordinates from a formatted string.

```{code-cell} ipython3
coordinate_string = "27.9881N, 86.9250E"
lat_str, lon_str = coordinate_string.split(", ")
latitude = float(lat_str[:-1])  # Convert string to float and remove the 'N'
longitude = float(lon_str[:-1])  # Convert string to float and remove the 'E'
print(f"Parsed coordinates: ({latitude}, {longitude})")
```

## Exercises

1. Create a string representing the name of a city. Convert the string to lowercase and then to uppercase.
2. Take a string with the format 'latitude, longitude' (e.g., '40.7128N, 74.0060W') and extract the numeric values of latitude and longitude.
3. Create a formatted string that includes the name of a location and its coordinates. Use both the `format()` method and f-strings to achieve this.
4. Replace a substring in the name of a place (e.g., change 'San Francisco' to 'San Diego') and print the result.

```{code-cell} ipython3
# Type your code here
```

## Conclusion

String operations are crucial in geospatial programming, especially when dealing with textual geographic data. Mastering these operations will enable you to handle and manipulate geographic information effectively in your projects.
