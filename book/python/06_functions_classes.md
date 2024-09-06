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

### Defining a Simple Function

Here's a simple function that adds two numbers:

```{code-cell} ipython3
def add(a, b):
    return a + b


# Example usage
result = add(5, 3)
print(f"Result: {result}")
```

This function takes two parameters `a` and `b`, and returns their sum. You can call it by passing two values as arguments.

### Parameters with Default Values

Sometimes, you may want a function to have optional parameters with default values. You can specify a default value by assigning it in the function definition.

```{code-cell} ipython3
def greet(name, greeting="Hello"):
    return f"{greeting}, {name}!"


# Example usage
print(greet("Alice"))  # Uses the default greeting
print(greet("Bob", "Hi"))  # Overrides the default greeting
```

In this example, the greeting parameter has a default value of `"Hello"`. If you don't provide a second argument, the function will use this default. If you provide one, it will override the default value.

### Calling Functions

To call a function, you simply use its name followed by parentheses containing the arguments you want to pass. For example:

```{code-cell} ipython3
# Function to multiply two numbers
def multiply(a, b):
    return a * b


# Calling the function
result = multiply(4, 5)
print(f"Multiplication Result: {result}")
```

You can call the multiply function with two numbers, and it will return their product.

### Geospatial Example: Haversine Function

Let's apply these concepts to a geospatial problem. The [Haversine formula](https://en.wikipedia.org/wiki/Haversine_formula) calculates the distance between two points on the Earth’s surface.

![](https://upload.wikimedia.org/wikipedia/commons/c/cb/Illustration_of_great-circle_distance.svg)

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

### Function with Default Values and Geospatial Application

Now let's modify the haversine function to accept an optional Earth radius parameter, which has a default value for kilometers but can be set for other units like miles.

```{code-cell} ipython3
def haversine(lat1, lon1, lat2, lon2, radius=6371.0):
    dlat = radians(lat2 - lat1)
    dlon = radians(lon2 - lon1)
    a = (
        sin(dlat / 2) ** 2
        + cos(radians(lat1)) * cos(radians(lat2)) * sin(dlon / 2) ** 2
    )
    c = 2 * atan2(sqrt(a), sqrt(1 - a))
    distance = radius * c
    return distance


# Example usage in kilometers
distance_km = haversine(35.6895, 139.6917, 34.0522, -118.2437)
print(f"Distance in kilometers: {distance_km:.2f} km")

# Example usage in miles (radius of Earth is approximately 3958.8 miles)
distance_miles = haversine(35.6895, 139.6917, 34.0522, -118.2437, radius=3958.8)
print(f"Distance in miles: {distance_miles:.2f} miles")
```

In this example, the radius parameter has a default value of 6371.0 for kilometers, but you can specify 3958.8 if you want the distance in miles.

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

### Function with Variable Arguments

You can also create functions that accept a variable number of arguments using `*args`.

```{code-cell} ipython3
def average(*numbers):
    return sum(numbers) / len(numbers)


# Example usage
print(average(10, 20, 30))  # 20.0
print(average(5, 15, 25, 35))  # 20.0
```

In Python, you can use `**kwargs` (short for "keyword arguments") in function definitions to pass a variable number of named arguments. This allows you to handle a flexible set of parameters in a function.

Let's create an example that demonstrates how to use `**kwargs` in a function:

```{code-cell} ipython3
def describe_point(latitude, longitude, **kwargs):
    description = f"Point at ({latitude}, {longitude})"

    # Add optional keyword arguments to the description
    for key, value in kwargs.items():
        description += f", {key}: {value}"

    return description


# Example usage
print(describe_point(35.6895, 139.6917, name="Tokyo", population=37400000))
print(describe_point(34.0522, -118.2437, name="Los Angeles", state="California"))
```

## Classes

Classes are blueprints for creating objects, which can have attributes (data) and methods (functions). They help represent more complex data structures.

### Defining a Simple Class

Here's a simple Point class to represent geographic points:

```{code-cell} ipython3
class Point:
    def __init__(self, latitude, longitude, name=None):
        self.latitude = latitude
        self.longitude = longitude
        self.name = name

    def __str__(self):
        return f"{self.name or 'Point'} ({self.latitude}, {self.longitude})"


# Example usage
point1 = Point(35.6895, 139.6917, "Tokyo")
print(point1)
```

### Adding Methods to a Class

You can add methods to the class to perform operations on the attributes.

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


# Example usage
point1 = Point(35.6895, 139.6917, "Tokyo")
point2 = Point(34.0522, -118.2437, "Los Angeles")
print(
    f"Distance from {point1.name} to {point2.name}: {point1.distance_to(point2):.2f} km"
)
```

### Constructor with Default Values

You can also use default values in the constructor of a class.

```{code-cell} ipython3
class Point:
    def __init__(self, latitude, longitude, name="Unnamed"):
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
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


# Example usage
route = Route([point1, point2])
print(f"Total distance: {route.total_distance():.2f} km")
```

## Exercises

1. Write a function called `convert_distance` that converts distances from kilometers to miles and vice versa. The function should accept two parameters: `distance` and `unit`, where `unit` has a default value of `"km"`. If the unit is `"km"`, it should convert the distance to miles, and if the unit is `"miles"`, it should convert the distance to kilometers.
2. Write a function called `sum_coordinates` that accepts a variable number of coordinate pairs (tuples) as input. The function should return the sum of all the latitude and longitude values provided.
3. Extend the `Point` class to include a method called `move` that adjusts the latitude and longitude by a given amount. For example, if you call `move(1, -1)`, it should increase the latitude by 1 and decrease the longitude by 1.
4. Create a `Rectangle` class that accepts two `Point` objects representing the bottom-left and top-right corners of the rectangle. The class should include a method called `area` that returns the area of the rectangle, assuming the coordinates are in the same coordinate system.

```{code-cell} ipython3

```

## Summary

In this lecture, we introduced the concepts of functions and classes. Functions allow you to encapsulate code into reusable blocks, while classes help you represent complex data structures like geospatial points. By combining these, you can build modular, scalable geospatial tools that perform various tasks efficiently.
