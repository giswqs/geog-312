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

# Data Structures

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/python/03_data_structures.ipynb)

## Overview

In this lecture, we will explore the fundamental Python data structures: Tuples, Lists, Sets, and Dictionaries. These data structures are essential tools in geospatial programming, enabling you to efficiently store, manage, and manipulate various types of data. By mastering these structures, you will be able to handle complex geospatial datasets with ease, paving the way for more advanced analysis and processing tasks.

## Learning Objectives

By the end of this lecture, you should be able to:

- Understand the characteristics and use cases of Python tuples, lists, sets, and dictionaries.
- Apply these data structures to store and manipulate geospatial data, such as coordinates, paths, and attribute information.
- Differentiate between mutable and immutable data structures and choose the appropriate structure for different geospatial tasks.
- Perform common operations on these data structures, including indexing, slicing, adding/removing elements, and updating values.
- Utilize dictionaries to manage geospatial feature attributes and understand the importance of key-value pairs in geospatial data management.

+++

## Tuples

Tuples are immutable sequences, meaning that once a tuple is created, its elements cannot be changed. Tuples are useful for storing fixed collections of items.

For example, a tuple can be used to store the coordinates of a geographic point (latitude, longitude).

```{code-cell} ipython3
point = (
    35.6895,
    139.6917,
)  # Tuple representing a geographic point (latitude, longitude)
```

You can access elements in a tuple using indexing:

```{code-cell} ipython3
latitude = point[0]
longitude = point[1]
print(f"Latitude: {latitude}, Longitude: {longitude}")
```

## Lists

Lists are ordered, mutable sequences, meaning you can change, add, or remove elements after the list has been created. Lists are very flexible and can store multiple types of data, making them useful for various geospatial tasks.

For example, you can store a list of coordinates representing a path or boundary.

```{code-cell} ipython3
path = [
    (35.6895, 139.6917),
    (34.0522, -118.2437),
    (51.5074, -0.1278),
]  # List of tuples representing a path
```

You can add a new point to the path:

```{code-cell} ipython3
path.append((48.8566, 2.3522))  # Adding Paris to the path
print("Updated path:", path)
```

Lists allow you to perform various operations such as slicing, which lets you access a subset of the list:

```{code-cell} ipython3
sub_path = path[:2]  # Slicing the first two points from the path
print("Sub-path:", sub_path)
```

## Sets

Sets are unordered collections of unique elements. Sets are useful when you need to store a collection of items but want to eliminate duplicates.

For example, you might want to store a set of unique geographic regions visited during a survey.

```{code-cell} ipython3
regions = ["North America", "Europe", "Asia"]  # Set of regions
regions = set(regions)
```

You can add a new region to the set:

```{code-cell} ipython3
regions.add("Africa")
print("Updated regions:", regions)
```

Since sets do not allow duplicates, adding an existing region will not change the set:

```{code-cell} ipython3
regions.add("Europe")  # Attempting to add a duplicate element
print("Regions after attempting to add duplicate:", regions)
```

## Dictionaries

Dictionaries are collections of key-value pairs, where each key is unique. Dictionaries are extremely useful for storing data that is associated with specific identifiers, such as attribute data for geographic features.

For example, you can use a dictionary to store attributes of a geospatial feature, such as a city.

```{code-cell} ipython3
city_attributes = {
    "name": "Tokyo",
    "population": 13929286,
    "coordinates": (35.6895, 139.6917),
}  # Dictionary storing attributes of a city
```

You can access the values associated with specific keys:

```{code-cell} ipython3
city_name = city_attributes["name"]
city_population = city_attributes["population"]
print(f"City: {city_name}, Population: {city_population}")
```

You can also add or update key-value pairs in a dictionary:

```{code-cell} ipython3
city_attributes["area_km2"] = 2191  # Adding the area of the city in square kilometers
print("Updated city attributes:", city_attributes)
```

## Exercises

Create a dictionary to store attributes of a geographic feature (e.g., a river or mountain). Include keys for the name, length, and location of the feature. Then, add an additional attribute (e.g., the source of the river or the height of the mountain) and print the dictionary.

```{code-cell} ipython3

```

## Summary

Understanding and utilizing Python's data structures such as tuples, lists, sets, and dictionaries are fundamental skills in geospatial programming. These structures provide the flexibility and functionality required to manage and manipulate spatial data effectively.

Continue exploring these data structures by applying them to your geospatial projects and analyses.
