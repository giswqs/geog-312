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
```

```{code-cell} ipython3
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

Now, let's create a function that takes a list of coordinate pairs and returns a list of distances between consecutive points.

```{code-cell} ipython3
def batch_haversine(coord_list):
    distances = []
    for i in range(len(coord_list) - 1):
        lat1, lon1 = coord_list[i]
        lat2, lon2 = coord_list[i + 1]
        distance = haversine(lat1, lon1, lat2, lon2)
        distances.append(distance)
    return distances

# Example usage
coordinates = [(35.6895, 139.6917), (34.0522, -118.2437), (40.7128, -74.0060)]
distances = batch_haversine(coordinates)
print(f"Distances: {distances}")
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
```

```{code-cell} ipython3
point1 = Point(35.6895, 139.6917, "Tokyo")
point2 = Point(34.0522, -118.2437, "Los Angeles")
print(point1)
print(
    f"Distance from {point1.name} to {point2.name}: {point1.distance_to(point2):.2f} km"
)
```

We can extend the `Point` class to include more methods, such as calculating the midpoint between two points and determining the bearing (direction) from one point to another.

```{code-cell} ipython3
from math import atan2, degrees
```

```{code-cell} ipython3
class Point:
    def __init__(self, latitude, longitude, name=None):
        self.latitude = latitude
        self.longitude = longitude
        self.name = name

    def distance_to(self, other_point):
        return haversine(self.latitude, self.longitude, other_point.latitude, other_point.longitude)

    def midpoint(self, other_point):
        mid_lat = (self.latitude + other_point.latitude) / 2
        mid_lon = (self.longitude + other_point.longitude) / 2
        return Point(mid_lat, mid_lon, name="Midpoint")

    def bearing_to(self, other_point):
        lat1, lon1 = radians(self.latitude), radians(self.longitude)
        lat2, lon2 = radians(other_point.latitude), radians(other_point.longitude)
        dlon = lon2 - lon1
        x = sin(dlon) * cos(lat2)
        y = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dlon)
        initial_bearing = atan2(x, y)
        bearing = (degrees(initial_bearing) + 360) % 360
        return bearing

    def __str__(self):
        return f"{self.name or 'Point'} ({self.latitude}, {self.longitude})"
```

```{code-cell} ipython3
point1 = Point(35.6895, 139.6917, "Tokyo")
point2 = Point(34.0522, -118.2437, "Los Angeles")
mid_point = point1.midpoint(point2)
print(mid_point)
bearing = point1.bearing_to(point2)
print(f"Bearing from {point1.name} to {point2.name}: {bearing:.2f}°")
```

## Combining Functions and Classes

You can use functions within classes to create more powerful and flexible geospatial tools. For instance, by incorporating distance calculations and midpoints, we can make the `Point` class much more versatile.

Let's create a method in the `Point` class that calculates the total distance when traveling through a series of points.

```{code-cell} ipython3
class Route:
    def __init__(self, points):
        self.points = points

    def total_distance(self):
        total_dist = 0
        for i in range(len(self.points) - 1):
            total_dist += self.points[i].distance_to(self.points[i + 1])
        return total_dist

    def __str__(self):
        return f"Route with {len(self.points)} points"
```

```{code-cell} ipython3
route = Route([point1, point2, mid_point])
print(route)
print(f"Total distance: {route.total_distance():.2f} km")
```

## Exercises

1. Create a function that takes a list of `Point` objects and returns the total distance if you were to travel from the first point to the last, visiting each point in sequence.
2. Extend the `Point` class to include a method that returns the bearing (direction) from the current point to another point.
3. Create a `Polygon` class that can hold a list of `Point` objects representing the vertices of the polygon. Add a method to calculate the perimeter of the polygon.
4. Write a function that takes a `Route` object and returns a list of bearings between each consecutive pair of points along the route.
5. Extend the `Polygon` class to include a method that checks if a given `Point` is inside the polygon using the ray-casting algorithm.

```{code-cell} ipython3

```

## Summary

Functions and classes are powerful tools in Python that help you organize and reuse your code, especially in the context of geospatial programming. By mastering these concepts, you'll be able to write more efficient and maintainable code for your geospatial projects.
