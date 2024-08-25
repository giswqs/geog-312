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

# Functions and Classes

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/python/06_functions_classes.ipynb)

## Overview

This lecture introduces the concepts of functions and classes in Python, focusing on their application in geospatial programming. Functions allow you to encapsulate code into reusable blocks, making your scripts more modular and easier to maintain. Classes provide a way to create complex data structures by bundling data and functionality together. By understanding and applying these concepts, you will be able to build more sophisticated and efficient geospatial analysis tools.

## Learning Objectives

By the end of this lecture, you should be able to:

- Define and use functions to perform specific tasks and promote code reuse in geospatial applications.
- Understand and implement classes to represent complex geospatial data structures, such as geographic features.
- Combine functions and classes to create modular and scalable geospatial tools.
- Apply object-oriented programming principles to organize and manage geospatial data and operations effectively.
- Develop the skills to extend existing classes and create new ones tailored to specific geospatial tasks.

+++

## Functions

Functions are blocks of code that perform a specific task and can be reused multiple times. They allow you to structure your code more efficiently and reduce redundancy.

Let's start by defining a simple function to calculate the distance between two points using the Haversine formula.

```{code-cell} ipython3
from math import radians, sin, cos, sqrt, atan2


def haversine(lat1, lon1, lat2, lon2):
    R = 6371.0  # Earth radius in kilometers
    dlat = radians(lat2 - lat1)
    dlon = radians(lon2 - lon1)
    a = (
        sin(dlat / 2) ** 2
        + cos(radians(lat1)) * cos(radians(lat2)) * sin(dlon / 2) ** 2
    )
    c = 2 * atan2(sqrt(a), sqrt(1 - a))
    distance = R * c
    return distance


# Example usage
distance = haversine(35.6895, 139.6917, 34.0522, -118.2437)
print(f"Distance: {distance:.2f} km")
```

## Classes

Classes are blueprints for creating objects. An object is an instance of a class, and it can have attributes (data) and methods (functions). Classes are particularly useful in geospatial programming for representing complex data structures, such as geographic features.

Let's define a simple `Point` class to represent a geographic point.

```{code-cell} ipython3
class Point:
    def __init__(self, latitude, longitude, name=None):
        self.latitude = latitude
        self.longitude = longitude
        self.name = name

    def distance_to(self, other_point):
        return haversine(
            self.latitude, self.longitude, other_point.latitude, other_point.longitude
        )

    def __str__(self):
        return f"{self.name or 'Point'} ({self.latitude}, {self.longitude})"


# Example usage
point1 = Point(35.6895, 139.6917, "Tokyo")
point2 = Point(34.0522, -118.2437, "Los Angeles")
print(point1)
print(
    f"Distance from {point1.name} to {point2.name}: {point1.distance_to(point2):.2f} km"
)
```

## Combining Functions and Classes

You can use functions within classes to create more powerful and flexible geospatial tools. For example, we can extend the `Point` class to include methods for calculating the midpoint between two points.

```{code-cell} ipython3
class Point:
    def __init__(self, latitude, longitude, name=None):
        self.latitude = latitude
        self.longitude = longitude
        self.name = name

    def distance_to(self, other_point):
        return haversine(
            self.latitude, self.longitude, other_point.latitude, other_point.longitude
        )

    def midpoint(self, other_point):
        mid_lat = (self.latitude + other_point.latitude) / 2
        mid_lon = (self.longitude + other_point.longitude) / 2
        return Point(mid_lat, mid_lon, name="Midpoint")

    def __str__(self):
        return f"{self.name or 'Point'} ({self.latitude}, {self.longitude})"


# Example usage
mid_point = point1.midpoint(point2)
print(mid_point)
```

## Exercises

1. Create a function that takes a list of `Point` objects and returns the total distance if you were to travel from the first point to the last, visiting each point in sequence.
2. Extend the `Point` class to include a method that returns the bearing (direction) from the current point to another point.
3. Create a `Polygon` class that can hold a list of `Point` objects representing the vertices of the polygon. Add a method to calculate the perimeter of the polygon.

```{code-cell} ipython3
# Type your code here
```

## Conclusion

Functions and classes are powerful tools in Python that help you organize and reuse your code, especially in the context of geospatial programming. By mastering these concepts, you'll be able to write more efficient and maintainable code for your geospatial projects.
