---
jupytext:
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.16.2
kernelspec:
  display_name: geo
  language: python
  name: python3
---

# Variables and Data Types

## Introduction

Welcome to this introductory lesson on Python variables and data types in a geospatial context. This notebook will guide you through the basics of Python, which are essential for geospatial analysis.

+++

## Variables in Python

In Python, a variable is a symbolic name that is a reference or pointer to an object. Once an object is assigned to a variable, you can refer to that object by the variable name.

Let's start by creating a simple variable that represents the number of spatial points in a dataset.

```{code-cell}
num_points = 120
```

This variable `num_points` now holds the integer value 120, which we can use in our calculations or logic.

To view the value of the variable, we can use the `print()` function.

```{code-cell}
print(num_points)
```

## Data Types

Python supports various data types, which are essential to understand before working with geospatial data. The most common data types include:

**a) Integers (int):** These are whole numbers, e.g., 1, 120, -5

```{code-cell}
num_features = 500  # Represents the number of features in a geospatial dataset
```

**b) Floating-point numbers (float):** These are numbers with a decimal point, e.g., 3.14, -0.001, 100.0

```{code-cell}
latitude = 35.6895  # Represents the latitude of a point on Earth's surface
```

**c) Strings (str):** Strings are sequences of characters, e.g., "Hello", "Geospatial Data", "Lat/Long"

```{code-cell}
coordinate_system = "WGS 84"  # Represents a commonly used coordinate system
```

**d) Booleans (bool):** Booleans represent one of two values: True or False

```{code-cell}
is_georeferenced = True  # Represents whether a dataset is georeferenced or not
```

**e) Lists:** Lists are ordered collections of items, which can be of any data type.

```{code-cell}
coordinates = [
    35.6895,
    139.6917,
]  # A list representing latitude and longitude of a point
```

**f) Dictionaries (dict):** Dictionaries are collections of key-value pairs.

```{code-cell}
feature_attributes = {
    "name": "Mount Fuji",
    "height_meters": 3776,
    "type": "Stratovolcano",
    "location": [35.3606, 138.7274],
}
```

## Working with Variables and Data Types

Now, let's do some basic operations with these variables.

Adding a constant to the number of features:

```{code-cell}
num_features += 20
print("Updated number of features:", num_features)
```

Converting latitude from degrees to radians (required for some geospatial calculations):

```{code-cell}
import math

latitude_radians = math.radians(latitude)
print("Latitude in radians:", latitude_radians)
```

Adding new coordinates to the list:

```{code-cell}
coordinates.append(34.0522)  # Adding latitude of Los Angeles
coordinates.append(-118.2437)  # Adding longitude of Los Angeles
print("Updated coordinates:", coordinates)
```

Accessing dictionary elements:

```{code-cell}
mount_fuji_name = feature_attributes["name"]
mount_fuji_height = feature_attributes["height_meters"]
print(f"{mount_fuji_name} is {mount_fuji_height} meters high.")
```

## Application in Geospatial Context

Let's say you are given a list of coordinates and need to calculate the centroid (average point).

Example coordinates of four points (latitude, longitude):

```{code-cell}
points = [
    [35.6895, 139.6917],  # Tokyo
    [34.0522, -118.2437],  # Los Angeles
    [51.5074, -0.1278],  # London
    [48.8566, 2.3522],  # Paris
]
```

Calculate the centroid:

```{code-cell}
centroid_lat = sum([point[0] for point in points]) / len(points)
centroid_lon = sum([point[1] for point in points]) / len(points)
centroid = [centroid_lat, centroid_lon]
print("Centroid of the points is at:", centroid)
```

## Exercise

1. Create a list of tuples, each representing the coordinates (latitude, longitude) of different cities you have visited.
2. Calculate the centroid of these coordinates.
3. Create a dictionary to store the centroid's latitude and longitude.

```{code-cell}
# Type your code here
```

## Conclusion

Understanding Python variables and data types is crucial in geospatial programming.
As you proceed with more complex analyses, these concepts will serve as the foundation for your work.
Continue practicing by experimenting with different data types and operations in a geospatial context.

Happy coding!
