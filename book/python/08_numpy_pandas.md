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

# Intro to NumPy and Pandas

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/python/08_numpy_pandas.ipynb)

+++

## Overview

This lecture introduces [NumPy](https://numpy.org) and [Pandas](https://pandas.pydata.org), two fundamental libraries for data manipulation and analysis in Python, with applications in geospatial programming. `NumPy` is essential for numerical operations and handling arrays, while `Pandas` provides powerful tools for data analysis, particularly when working with tabular data. Understanding these libraries will enable you to perform complex data operations efficiently and effectively in geospatial contexts.

## Learning Objectives

By the end of this lecture, you should be able to:

- Understand the basics of `NumPy` arrays and how to perform operations on them.
- Utilize `Pandas` DataFrames to organize, analyze, and manipulate tabular data.
- Apply `NumPy` and `Pandas` in geospatial programming to process and analyze geospatial datasets.
- Combine `NumPy` and `Pandas` to streamline data processing workflows.
- Develop the ability to perform complex data operations, such as filtering, aggregating, and transforming geospatial data.

## Introduction to NumPy

`NumPy` (Numerical Python) is a library used for scientific computing. It provides support for large, multi-dimensional arrays and matrices, along with a collection of mathematical functions to operate on these arrays.

### Creating NumPy Arrays

Let's start by creating some basic `NumPy` arrays.

```{code-cell} ipython3
import numpy as np
```

```{code-cell} ipython3
# Creating a 1D array
arr_1d = np.array([1, 2, 3, 4, 5])
print(f"1D Array: {arr_1d}")
```

```{code-cell} ipython3
# Creating a 2D array
arr_2d = np.array([[1, 2, 3], [4, 5, 6]])
print(f"2D Array:\n{arr_2d}")
```

```{code-cell} ipython3
# Creating an array of zeros
zeros = np.zeros((3, 3))
print(f"Array of zeros:\n{zeros}")
```

```{code-cell} ipython3
# Creating an array of ones
ones = np.ones((2, 4))
print(f"Array of ones:\n{ones}")
```

```{code-cell} ipython3
# Creating an array with a range of values
range_arr = np.arange(0, 10, 2)
print(f"Range Array: {range_arr}")
```

### Basic Array Operations

`NumPy` allows you to perform element-wise operations on arrays.

```{code-cell} ipython3
# Array addition
arr_sum = arr_1d + 10
print(f"Array after addition: {arr_sum}")
```

```{code-cell} ipython3
# Array multiplication
arr_product = arr_1d * 2
print(f"Array after multiplication: {arr_product}")
```

```{code-cell} ipython3
# Element-wise multiplication of two arrays
arr_2d_product = arr_2d * np.array([1, 2, 3])
print(f"Element-wise multiplication of 2D array:\n{arr_2d_product}")
```

### Working with Geospatial Coordinates

You can use `NumPy` to perform calculations on arrays of geospatial coordinates, such as converting from degrees to radians.

```{code-cell} ipython3
# Array of latitudes and longitudes
coords = np.array([[35.6895, 139.6917], [34.0522, -118.2437], [51.5074, -0.1278]])

# Convert degrees to radians
coords_radians = np.radians(coords)
print(f"Coordinates in radians:\n{coords_radians}")
```

## Introduction to Pandas

`Pandas` is a powerful data manipulation library that provides data structures like Series and DataFrames to work with structured data. It is especially useful for handling tabular data.

### Creating Pandas Series and DataFrames

Let's create a `Pandas` Series and DataFrame.

```{code-cell} ipython3
import pandas as pd
```

```{code-cell} ipython3
# Creating a Series
city_series = pd.Series(["Tokyo", "Los Angeles", "London"], name="City")
print(f"Pandas Series:\n{city_series}\n")
```

```{code-cell} ipython3
# Creating a DataFrame
data = {
    "City": ["Tokyo", "Los Angeles", "London"],
    "Latitude": [35.6895, 34.0522, 51.5074],
    "Longitude": [139.6917, -118.2437, -0.1278],
}
df = pd.DataFrame(data)
print(f"Pandas DataFrame:\n{df}")
```

```{code-cell} ipython3
df
```

### Basic DataFrame Operations

You can perform various operations on `Pandas` DataFrames, such as filtering, selecting specific columns, and applying functions.

```{code-cell} ipython3
# Selecting a specific column
latitudes = df["Latitude"]
print(f"Latitudes:\n{latitudes}\n")
```

```{code-cell} ipython3
# Filtering rows based on a condition
df_filtered = df[df["Longitude"] < 0]
df_filtered
```

```{code-cell} ipython3
# Adding a new column with a calculation
df["Lat_Radians"] = np.radians(df["Latitude"])
df
```

### Analyzing Geospatial Data

In this example, we analyze a dataset of cities, calculating the distance between each pair using the Haversine formula.

```{code-cell} ipython3
# Define the Haversine formula using NumPy
def haversine_np(lat1, lon1, lat2, lon2):
    R = 6371.0  # Earth radius in kilometers
    dlat = np.radians(lat2 - lat1)
    dlon = np.radians(lon2 - lon1)
    a = (
        np.sin(dlat / 2) ** 2
        + np.cos(np.radians(lat1)) * np.cos(np.radians(lat2)) * np.sin(dlon / 2) ** 2
    )
    c = 2 * np.arctan2(np.sqrt(a), np.sqrt(1 - a))
    distance = R * c
    return distance


# Create a new DataFrame with city pairs
city_pairs = pd.DataFrame(
    {
        "City1": ["Tokyo", "Tokyo", "Los Angeles"],
        "City2": ["Los Angeles", "London", "London"],
        "Lat1": [35.6895, 35.6895, 34.0522],
        "Lon1": [139.6917, 139.6917, -118.2437],
        "Lat2": [34.0522, 51.5074, 51.5074],
        "Lon2": [-118.2437, -0.1278, -0.1278],
    }
)

# Calculate distances between city pairs
city_pairs["Distance_km"] = haversine_np(
    city_pairs["Lat1"], city_pairs["Lon1"], city_pairs["Lat2"], city_pairs["Lon2"]
)
city_pairs
```

## Combining NumPy and Pandas

You can combine `NumPy` and `Pandas` to perform complex data manipulations. For instance, you might want to apply `NumPy` functions to a `Pandas` DataFrame or use `Pandas` to organize and visualize the results of `NumPy` operations.

Let's say you have a dataset of cities, and you want to calculate the average distance from each city to all other cities.

```{code-cell} ipython3
# Define a function to calculate distances from a city to all other cities
def calculate_average_distance(df):
    lat1 = df["Latitude"].values
    lon1 = df["Longitude"].values
    lat2, lon2 = np.meshgrid(lat1, lon1)
    distances = haversine_np(lat1, lon1, lat2, lon2)
    avg_distances = np.mean(distances, axis=1)
    return avg_distances


# Apply the function to calculate average distances
df["Avg_Distance_km"] = calculate_average_distance(df)
df
```

Pandas can read and write data in various formats, such as CSV, Excel, and SQL databases. This makes it easy to load and save data from different sources. For example, you can read a CSV file into a Pandas DataFrame and then perform operations on the data.

Let's read a CSV file from an HTTP URL into a Pandas DataFrame and display the first few rows of the data.

```{code-cell} ipython3
url = "https://github.com/opengeos/datasets/releases/download/world/world_cities.csv"
df = pd.read_csv(url)
df.head()
```

The DataFrame contains information about world cities, including their names, countries, populations, and geographical coordinates. We can calculate the total population of all cities in the dataset using NumPy and Pandas as follows.

```{code-cell} ipython3
np.sum(df["population"])
```

## Exercises

1. **Array Operations**: Create a `NumPy` array representing the elevations of various locations. Normalize the elevations (e.g., subtract the mean and divide by the standard deviation) and calculate the mean and standard deviation of the normalized array.
2. **Data Analysis with Pandas**: Create a `Pandas` DataFrame from a CSV file containing geospatial data (e.g., cities and their coordinates). Filter the DataFrame to include only cities in the Northern Hemisphere and calculate the average latitude of these cities.
3. **Combining NumPy and Pandas**: Using a dataset of geographic coordinates, create a `Pandas` DataFrame. Use `NumPy` to calculate the pairwise distances between all points and store the results in a new DataFrame.

```{code-cell} ipython3

```

## Summary

`NumPy` and `Pandas` are essential tools in geospatial programming, allowing you to efficiently manipulate and analyze numerical and tabular data. By mastering these libraries, you will be able to perform complex data operations, manage large datasets, and streamline your geospatial workflows.
