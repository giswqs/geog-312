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

# Variables and Data Types

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/python/02_variables.ipynb)

## Overview

This lecture introduces the fundamental concepts of variables and data types in Python, focusing on their applications within geospatial programming. Understanding these basics is essential for working with geospatial data, as variables allow you to store and manipulate information, while data types define the kind of operations you can perform on this information. This lecture will guide you through variable assignment, naming conventions, and the various data types available in Python, providing practical examples relevant to GIS.

## Learning Objectives

By the end of this lecture, you should be able to:

- Define and use variables in Python, adhering to best practices for naming and assignment.
- Identify and utilize various Python data types, including integers, floats, strings, booleans, lists, and dictionaries.
- Understand how data types are used in the context of geospatial data, such as coordinates and attribute information.
- Perform basic operations and manipulations on different data types, reinforcing your understanding of their practical applications in geospatial programming.
- Apply the concepts of variables and data types to real-world geospatial problems, such as calculating centroids and managing attribute data.

+++

## Variables in Python

In Python, a variable is a symbolic name that is a reference or pointer to an object. Once an object is assigned to a variable, you can refer to that object by the variable name.

Let's start by creating a simple variable that represents the number of spatial points in a dataset.

```{code-cell} ipython3
num_points = 120
```

This variable `num_points` now holds the integer value 120, which we can use in our calculations or logic.

To view the value of the variable, we can use the `print()` function.

```{code-cell} ipython3
print(num_points)
```

Alternatively, we can simply type the variable name in a code cell and run the cell to display the value of the variable.

```{code-cell} ipython3
num_points
```

## Naming Variables

When naming variables, you should follow these rules:

- Variable names must start with a letter or an underscore, such as `_`.
- The remainder of the variable name can consist of letters, numbers, and underscores.
- Variable names are case-sensitive, so `num_points` and `Num_Points` are different variables.
- Variable names should be descriptive and meaningful, such as `num_points` instead of `n`.
- Avoid using Python keywords and built-in functions as variable names, such as `print`, `sum`, `list`, `dict`, `str`, `int`, `float`, `bool`, `set`, `tuple`, `range`, `type`, `object`, `None`, `True`, `False`, `and`, `or`, `not`, `if`, `else`, `elif`, `for`, `while`, `break`, `continue`, `pass`, `def`, `return`, `lambda`, `class`, `import`, `from`, `as`, `with`, `try`, `except`, `finally`, `raise`, `assert`, `del`, `in`, `is`, `global`, `nonlocal`, `yield`, `async`, `await`.

+++

## Data Types

Python supports various data types, which are essential to understand before working with geospatial data. The most common data types include:

**a) Integers (int):** These are whole numbers, e.g., 1, 120, -5

```{code-cell} ipython3
num_features = 500  # Represents the number of features in a geospatial dataset
```

**b) Floating-point numbers (float):** These are numbers with a decimal point, e.g., 3.14, -0.001, 100.0. You can write multiple lines of code in a single code cell. The output will be displayed for the last line of code.

```{code-cell} ipython3
latitude = 35.6895  # Represents the latitude of a point on Earth's surface
longitude = 139.6917  # Represents the longitude of a point on Earth's surface
```

**c) Strings (str):** Strings are sequences of characters, e.g., "Hello", "Geospatial Data", "Lat/Long"

```{code-cell} ipython3
coordinate_system = "WGS 84"  # Represents a commonly used coordinate system
```

Strings can be enclosed in single quotes (`'`) or double quotes (`"`). You can also use triple quotes (`'''` or `"""`) for multiline strings.

+++

**d) Booleans (bool):** Booleans represent one of two values: True or False

```{code-cell} ipython3
is_georeferenced = True  # Represents whether a dataset is georeferenced or not
```

**e) Lists:** Lists are ordered collections of items, which can be of any data type.

```{code-cell} ipython3
coordinates = [
    35.6895,
    139.6917,
]  # A list representing latitude and longitude of a point
```

**f) Dictionaries (dict):** Dictionaries are collections of key-value pairs.

```{code-cell} ipython3
feature_attributes = {
    "name": "Mount Fuji",
    "height_meters": 3776,
    "type": "Stratovolcano",
    "location": [35.3606, 138.7274],
}
```

## Escape Characters

Escape characters are used to insert characters that are illegal in a string. For example, you can use the escape character `\n` to insert a new line in a string.

```{code-cell} ipython3
print("Hello World!\nThis is a Python script.")
```

Another common escape character is `\t`, which inserts a tab in a string.

```{code-cell} ipython3
print("This is the first line.\n\tThis is the second line. It is indented.")
```

If you want to include a single quote in a string, your can wrap the string in double quotes. Alternatively, you can use the escape character `\'` to include a single quote in a string.

```{code-cell} ipython3
print("What's your name?")
```

```{code-cell} ipython3
print("What's your name?")
```

## Comments

Comments are used to explain the code and make it more readable. In Python, comments start with the `#` symbol. Everything after the `#` symbol on a line is ignored by the Python interpreter.

```{code-cell} ipython3
# This is a comment
num_points = 120  # This is an inline comment
```

## Working with Variables and Data Types

Now, let's do some basic operations with these variables.

Adding a constant to the number of features:

```{code-cell} ipython3
num_features += 20
print("Updated number of features:", num_features)
```

Converting latitude from degrees to radians (required for some geospatial calculations):

```{code-cell} ipython3
import math

latitude = 35.6895
latitude_radians = math.radians(latitude)
print("Latitude in radians:", latitude_radians)
```

Adding new coordinates to the list:

```{code-cell} ipython3
coordinates = [35.6895, 139.6917]
coordinates.append(34.0522)  # Adding latitude of Los Angeles
coordinates.append(-118.2437)  # Adding longitude of Los Angeles
print("Updated coordinates:", coordinates)
```

Accessing dictionary elements:

```{code-cell} ipython3
mount_fuji_name = feature_attributes["name"]
mount_fuji_height = feature_attributes["height_meters"]
print(f"{mount_fuji_name} is {mount_fuji_height} meters high.")
```

## Application in Geospatial Context

Let's say you are given a list of coordinates and need to calculate the centroid (average point).

Example coordinates of four points (latitude, longitude):

```{code-cell} ipython3
points = [
    [35.6895, 139.6917],  # Tokyo
    [34.0522, -118.2437],  # Los Angeles
    [51.5074, -0.1278],  # London
    [48.8566, 2.3522],  # Paris
]
```

Calculate the centroid:

```{code-cell} ipython3
centroid_lat = sum([point[0] for point in points]) / len(points)
centroid_lon = sum([point[1] for point in points]) / len(points)
centroid = [centroid_lat, centroid_lon]
print("Centroid of the points is at:", centroid)
```

## Further Reading

For more information on variables and data types in Python, check out the **Basics** section of the A Byte of Python book: <https://python.swaroopch.com/basics.html>.

+++

## Exercises

1. Create a list of tuples, each representing the coordinates (latitude, longitude) of different cities you have visited.
2. Calculate the centroid of these coordinates.
3. Create a dictionary to store the centroid's latitude and longitude.

```{code-cell} ipython3

```

## Summary

Understanding Python variables and data types is crucial in geospatial programming.
As you proceed with more complex analyses, these concepts will serve as the foundation for your work.
Continue practicing by experimenting with different data types and operations in a geospatial context.

Happy coding!
