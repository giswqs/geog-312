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

### Reshaping Arrays

Reshaping arrays can be particularly useful when you need to restructure data for specific computations or visualizations.

```{code-cell} ipython3
# Reshape a 1D array into a 2D array
arr_reshaped = np.arange(12).reshape((3, 4))
print(f"Reshaped 1D Array into 2D Array:\n{arr_reshaped}")
```

```{code-cell} ipython3
arr_reshaped.shape
```

### Mathematical Functions on Arrays

You can apply various mathematical functions to arrays, such as square roots, logarithms, and trigonometric functions.

```{code-cell} ipython3
# Square root of each element in the array
sqrt_array = np.sqrt(arr_reshaped)
print(f"Square Root of Array Elements:\n{sqrt_array}")
```

```{code-cell} ipython3
# Logarithm of each element (add 1 to avoid log(0))
log_array = np.log1p(arr_reshaped)
print(f"Logarithm (base e) of Array Elements:\n{log_array}")
```

### Statistical Operations

NumPy provides a wide range of statistical functions for data analysis, such as mean, median, variance, and standard deviation.

```{code-cell} ipython3
# Mean, median, and standard deviation of an array
arr = np.array([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
mean_val = np.mean(arr)
median_val = np.median(arr)
std_val = np.std(arr)

print(f"Mean: {mean_val}, Median: {median_val}, Standard Deviation: {std_val:.4f}")
```

### Random Data Generation for Simulation

Random data generation is useful for simulations, such as generating random geospatial coordinates or sampling from distributions.

```{code-cell} ipython3
# Generate an array of random latitudes and longitudes
random_coords = np.random.uniform(low=-90, high=90, size=(5, 2))
print(f"Random Latitudes and Longitudes:\n{random_coords}")
```

### Indexing, Slicing, and Iterating

One of the most powerful features of `NumPy` is its ability to quickly access and modify array elements using indexing and slicing. These operations allow you to select specific parts of the array, which is useful in many geospatial applications where you may want to work with subsets of your data (e.g., focusing on specific regions or coordinates).

#### Indexing in NumPy

You can access individual elements of an array using their indices. Remember that `NumPy` arrays are zero-indexed, meaning that the first element is at index `0`.

Below are some examples of indexing 1D Arrays in `NumPy`.

```{code-cell} ipython3
# Create a 1D array
arr = np.array([10, 20, 30, 40, 50])

# Accessing the first element
first_element = arr[0]
print(f"First element: {first_element}")

# Accessing the last element
last_element = arr[-1]
print(f"Last element: {last_element}")
```

In 2D arrays, you can specify both row and column indices to access a particular element.

```{code-cell} ipython3
# Create a 2D array
arr_2d = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
arr_2d
```

```{code-cell} ipython3
# Accessing the element in the first row and second column
element = arr_2d[0, 1]
print(f"Element at row 1, column 2: {element}")

# Accessing the element in the last row and last column
element_last = arr_2d[-1, -1]
print(f"Element at last row, last column: {element_last}")
```

#### Slicing in NumPy

Slicing allows you to access a subset of an array. You can use the : symbol to specify a range of indices.

**Example: Slicing 1D Arrays in NumPy**

```{code-cell} ipython3
# Create a 1D array
arr = np.array([10, 20, 30, 40, 50])

# Slice elements from index 1 to 3 (exclusive)
slice_1d = arr[1:4]
print(f"Slice from index 1 to 3: {slice_1d}")

# Slice all elements from index 2 onwards
slice_2d = arr[2:]
print(f"Slice from index 2 onwards: {slice_2d}")
```

**Example: Slicing 2D Arrays in NumPy**

When slicing a 2D array, you can slice both rows and columns.

```{code-cell} ipython3
# Create a 2D array
arr_2d = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
arr_2d
```

```{code-cell} ipython3
# Slice the first two rows and all columns
slice_2d = arr_2d[:2, :]
print(f"Sliced 2D array (first two rows):\n{slice_2d}")

# Slice the last two rows and the first two columns
slice_2d_partial = arr_2d[1:, :2]
print(f"Sliced 2D array (last two rows, first two columns):\n{slice_2d_partial}")
```

#### Boolean Indexing

You can also use Boolean conditions to filter elements of an array.

**Example: Boolean Indexing**

```{code-cell} ipython3
# Create a 1D array
arr = np.array([10, 20, 30, 40, 50])

# Boolean condition to select elements greater than 25
condition = arr > 25
print(f"Boolean condition: {condition}")

# Use the condition to filter the array
filtered_arr = arr[condition]
print(f"Filtered array (elements > 25): {filtered_arr}")
```

#### Iterating Over Arrays

You can iterate over NumPy arrays to access or modify elements. For 1D arrays, you can simply loop through the elements. For multi-dimensional arrays, you may want to iterate through rows or columns.

**Example: Iterating Over a 1D Array**

```{code-cell} ipython3
# Create a 1D array
arr = np.array([10, 20, 30, 40, 50])

# Iterating through the array
for element in arr:
    print(f"Element: {element}")
```

**Example: Iterating Over a 2D Array**

```{code-cell} ipython3
# Create a 2D array
arr_2d = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

# Iterating through rows of the 2D array
print("Iterating over rows:")
for row in arr_2d:
    print(row)

# Iterating through each element of the 2D array
print("\nIterating over each element:")
for row in arr_2d:
    for element in row:
        print(element, end=" ")
```

### Modifying Array Elements

You can also use indexing and slicing to modify elements of the array.

**Example: Modifying Elements**

```{code-cell} ipython3
# Create a 1D array
arr = np.array([10, 20, 30, 40, 50])

# Modify the element at index 1
arr[1] = 25
print(f"Modified array: {arr}")

# Modify multiple elements using slicing
arr[2:4] = [35, 45]
print(f"Modified array with slicing: {arr}")
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

Let's create a `Pandas` Series and DataFrame. Each column in a DataFrame is a Series.

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

### Grouping and Aggregation

Pandas allows you to group data and perform aggregate functions, which is useful in summarizing large datasets.

```{code-cell} ipython3
# Creating a DataFrame
data = {
    "City": ["Tokyo", "Los Angeles", "London", "Paris", "Chicago"],
    "Country": ["Japan", "USA", "UK", "France", "USA"],
    "Population": [37400068, 3970000, 9126366, 2140526, 2665000],
}
df = pd.DataFrame(data)
df
```

```{code-cell} ipython3
# Group by 'Country' and calculate the total population for each country
df_grouped = df.groupby("Country")["Population"].sum()
print(f"Total Population by Country:\n{df_grouped}")
```

### Merging DataFrames

Merging datasets is essential when combining different geospatial datasets, such as joining city data with demographic information.

```{code-cell} ipython3
# Creating two DataFrames to merge
df1 = pd.DataFrame(
    {"City": ["Tokyo", "Los Angeles", "London"], "Country": ["Japan", "USA", "UK"]}
)
df2 = pd.DataFrame(
    {
        "City": ["Tokyo", "Los Angeles", "London"],
        "Population": [37400068, 3970000, 9126366],
    }
)
```

```{code-cell} ipython3
df1
```

```{code-cell} ipython3
df2
```

```{code-cell} ipython3
# Merge the two DataFrames on the 'City' column
df_merged = pd.merge(df1, df2, on="City")
df_merged
```

### Handling Missing Data

In real-world datasets, missing data is common. Pandas provides tools to handle missing data, such as filling or removing missing values.

```{code-cell} ipython3
# Creating a DataFrame with missing values
data_with_nan = {
    "City": ["Tokyo", "Los Angeles", "London", "Paris"],
    "Population": [37400068, 3970000, None, 2140526],
}
df_nan = pd.DataFrame(data_with_nan)
df_nan
```

```{code-cell} ipython3
# Fill missing values with the mean population
df_filled = df_nan.fillna(df_nan["Population"].mean())
df_filled
```

### Reading Geospatial Data from a CSV File

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

### Creating plots with Pandas

Pandas provides built-in plotting capabilities that allow you to create various types of plots directly from DataFrames.

```{code-cell} ipython3
# Load the dataset from an online source
url = "https://raw.githubusercontent.com/pandas-dev/pandas/main/doc/data/air_quality_no2.csv"
air_quality = pd.read_csv(url, index_col=0, parse_dates=True)

# Display the first few rows of the dataset
air_quality.head()
```

To do a quick visual check of the data.

```{code-cell} ipython3
air_quality.plot()
```

To plot only the columns of the data table with the data from Paris.

```{code-cell} ipython3
air_quality["station_paris"].plot()
```

To visually compare the values measured in London versus Paris.

```{code-cell} ipython3
air_quality.plot.scatter(x="station_london", y="station_paris", alpha=0.5)
```

To visualize each of the columns in a separate subplot.

```{code-cell} ipython3
air_quality.plot.area(figsize=(12, 4), subplots=True)
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
city_pairs
```

```{code-cell} ipython3
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


# Creating a DataFrame
data = {
    "City": ["Tokyo", "Los Angeles", "London"],
    "Latitude": [35.6895, 34.0522, 51.5074],
    "Longitude": [139.6917, -118.2437, -0.1278],
}
df = pd.DataFrame(data)

# Apply the function to calculate average distances
df["Avg_Distance_km"] = calculate_average_distance(df)
df
```

## Exercises

1. **Array Operations**: Create a `NumPy` array representing the elevations of various locations. Normalize the elevations (e.g., subtract the mean and divide by the standard deviation) and calculate the mean and standard deviation of the normalized array.
2. **Data Analysis with Pandas**: Create a `Pandas` DataFrame from a CSV file containing geospatial data (e.g., cities and their coordinates). Filter the DataFrame to include only cities in the Northern Hemisphere and calculate the average latitude of these cities.
3. **Combining NumPy and Pandas**: Using a dataset of geographic coordinates, create a `Pandas` DataFrame. Use `NumPy` to calculate the pairwise distances between all points and store the results in a new DataFrame.

```{code-cell} ipython3

```

## Summary

`NumPy` and `Pandas` are essential tools in geospatial programming, allowing you to efficiently manipulate and analyze numerical and tabular data. By mastering these libraries, you will be able to perform complex data operations, manage large datasets, and streamline your geospatial workflows.
