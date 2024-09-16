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

# Looping and Control Statements

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/python/05_looping.ipynb)

## Overview

This lecture introduces looping and control statements in Python, focusing on their applications in geospatial programming. Loops and control statements are essential tools for automating repetitive tasks, making decisions based on data conditions, and efficiently processing large geospatial datasets. By mastering these concepts, you will be able to handle complex geospatial analysis tasks with greater efficiency and precision.

## Learning Objectives

By the end of this lecture, you should be able to:

- Understand and implement `for` loops to iterate over sequences such as lists and tuples.
- Use `while` loops to perform tasks until a specific condition is met.
- Apply control statements (`if`, `elif`, `else`) to execute different blocks of code based on data conditions.
- Combine loops and control statements to filter, process, and analyze geospatial data.
- Develop the ability to automate repetitive geospatial tasks, making your data processing workflows more efficient.

## For Loops

For loops allow you to iterate over a sequence (such as a list, tuple, or string) and execute a block of code for each item in the sequence. This is particularly useful in geospatial programming when you need to process multiple features or coordinates.

```{code-cell} ipython3
coordinates = [
    (35.6895, 139.6917),
    (34.0522, -118.2437),
    (51.5074, -0.1278),
]  # List of tuples representing coordinates

for lat, lon in coordinates:
    print(f"Latitude: {lat}, Longitude: {lon}")
```

Assuming you have a function to calculate distances, you can use a loop to compute distances from a reference point.

```{code-cell} ipython3
def calculate_distance(lat1, lon1, lat2, lon2):
    # Placeholder for distance calculation logic
    return ((lat2 - lat1) ** 2 + (lon2 - lon1) ** 2) ** 0.5


reference_point = (0, 0)  # Reference point (latitude, longitude)

for lat, lon in coordinates:
    distance = calculate_distance(reference_point[0], reference_point[1], lat, lon)
    print(f"Distance from {reference_point} to ({lat}, {lon}): {distance:.2f}")
```

## While Loops

While loops continue to execute a block of code as long as a specified condition is true. They are useful when the number of iterations is not known beforehand, such as when processing data until a certain condition is met.

```{code-cell} ipython3
counter = 0
while counter < len(coordinates):
    lat, lon = coordinates[counter]
    print(f"Processing coordinate: ({lat}, {lon})")
    counter += 1
```

## Control Statements: if, elif, else

Control statements allow you to execute different blocks of code based on certain conditions. In geospatial programming, this is useful for handling different types of data or conditions.

```{code-cell} ipython3
for lat, lon in coordinates:
    if lat > 0:
        print(f"{lat} is in the Northern Hemisphere")
    elif lat < 0:
        print(f"{lat} is in the Southern Hemisphere")
    else:
        print(f"{lat} is near the equator")
```

You can further categorize based on longitude:

```{code-cell} ipython3
for lat, lon in coordinates:
    if lat > 0:
        hemisphere = "Northern"
    else:
        hemisphere = "Southern"

    if lon > 0:
        direction = "Eastern"
    else:
        direction = "Western"

    print(
        f"The coordinate ({lat}, {lon}) is in the {hemisphere} Hemisphere and {direction} Hemisphere."
    )
```

## Combining Loops and Control Statements

You can combine loops and control statements to perform more complex operations, such as filtering data or applying conditions during iteration.

```{code-cell} ipython3
filtered_coordinates = []
for lat, lon in coordinates:
    if lon > 0:
        filtered_coordinates.append((lat, lon))
print(f"Filtered coordinates (only with positive longitude): {filtered_coordinates}")
```

```{code-cell} ipython3
southern_count = 0
for lat, lon in coordinates:
    if lat < 0:
        southern_count += 1
print(f"Number of coordinates in the Southern Hemisphere: {southern_count}")
```

## Exercises

1. Create a list of cities with their coordinates. Write a for loop to print out only the cities that are in the Northern Hemisphere.
2. Write a while loop that continues to print the coordinates in a list until a coordinate with a latitude less than 0 is found.
3. Create a for loop that iterates through a list of coordinates and prints whether each coordinate is in the Eastern or Western Hemisphere based on the longitude.
4. Combine a for loop and if statements to count how many coordinates in a list are located in the Southern Hemisphere.
5. Write a program that generates random coordinates (latitude and longitude) and prints them until a coordinate with both latitude and longitude greater than 50 is generated.

```{code-cell} ipython3

```

## Summary

Loops and control statements are fundamental tools in geospatial programming. They allow you to process and analyze geographic data efficiently by automating repetitive tasks and applying logic based on data conditions. Practice these concepts by applying them to your geospatial datasets and analyses.
