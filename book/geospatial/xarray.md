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

# Xarray

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/geospatial/xarray.ipynb)

## Overview

[Xarray](https://docs.xarray.dev) is a powerful Python library designed for working with multi-dimensional labeled datasets, often used in fields such as climate science, oceanography, and remote sensing. It provides a high-level interface for manipulating and analyzing datasets that can be thought of as extensions of NumPy arrays. Xarray is particularly useful for geospatial data because it supports labeled axes (dimensions), coordinates, and metadata, making it easier to work with datasets that vary across time, space, and other dimensions.

## Learning Objectives

By the end of this lecture, you should be able to:

- Understand the basic concepts and data structures in Xarray, including `DataArray` and `Dataset`.
- Load and inspect multi-dimensional geospatial datasets using Xarray.
- Perform basic operations on Xarray objects, such as selection, indexing, and arithmetic operations.
- Use Xarray to efficiently work with large geospatial datasets, including time series and raster data.
- Apply Xarray to common geospatial analysis tasks, such as calculating statistics, regridding, and visualization.

+++

## What is Xarray?

Xarray extends the capabilities of NumPy by providing a data structure for labeled, multi-dimensional arrays. The two main data structures in Xarray are:

- **DataArray**: A labeled, multi-dimensional array, which includes dimensions, coordinates, and attributes.
- **Dataset**: A collection of `DataArray` objects that share the same dimensions.

Xarray is particularly useful for working with datasets where dimensions have meaningful labels (e.g., time, latitude, longitude) and where metadata is important.

+++

## Installing Xarray

Before we start, ensure that Xarray is installed. You can install it via pip:

```bash
pip install xarray
```

Or with conda:

```bash
conda install -c conda-forge xarray
```

+++

## Loading Data with Xarray

Xarray provides built-in sample datasets that are great for getting started. In this example, we'll load and explore the air temperature dataset provided by Xarray.

```{code-cell} ipython3
import xarray as xr

# Load a sample dataset
data = xr.tutorial.load_dataset("air_temperature")

# Inspect the dataset
data
```

## Working with DataArrays

The `DataArray` is the core data structure in Xarray. It includes the data values, the dimensions (e.g., time, latitude, longitude), and the coordinates for each dimension.

```{code-cell} ipython3
# Access a specific DataArray
temperature = data["air"]
```

```{code-cell} ipython3
# Print the DataArray
temperature
```

```{code-cell} ipython3
temperature.values
```

```{code-cell} ipython3
temperature.dims
```

```{code-cell} ipython3
temperature.coords
```

## Indexing and Selecting Data

Xarray allows you to easily select data based on dimension labels, which is very intuitive when working with geospatial data.

```{code-cell} ipython3
# Select data for a specific time and location
selected_data = temperature.sel(time="2013-01-01", lat=40.0, lon=260.0)
selected_data
```

```{code-cell} ipython3
# Slice data across a range of times
time_slice = temperature.sel(time=slice("2013-01-01", "2013-01-31"))
time_slice
```

## Performing Operations on DataArrays

You can perform arithmetic operations directly on `DataArray` objects, similar to how you would with NumPy arrays. Xarray also handles broadcasting automatically.

```{code-cell} ipython3
# Calculate the mean temperature over time
mean_temperature = temperature.mean(dim="time")
mean_temperature
```

```{code-cell} ipython3
# Subtract the mean temperature from the original data
anomalies = temperature - mean_temperature
anomalies
```

## Visualization with Xarray

Xarray integrates well with Matplotlib and other visualization libraries, making it easy to create plots directly from `DataArray` and `Dataset` objects.

```{code-cell} ipython3
import matplotlib.pyplot as plt

# Plot the mean temperature
mean_temperature.plot()
plt.show()

# Plot a time series for a specific location
temperature.sel(lat=40.0, lon=260.0).plot()
plt.show()
```

## Working with Datasets

A `Dataset` is a collection of `DataArray` objects. It is useful when you need to work with multiple related variables.

```{code-cell} ipython3
# List all variables in the dataset
print(data.data_vars)

# Access a DataArray from the Dataset
temperature = data["air"]

# Perform operations on the Dataset
mean_temp_ds = data.mean(dim="time")
print(mean_temp_ds)
```

## Conclusion

Xarray is an essential tool for working with multi-dimensional geospatial data. Its ability to handle labeled dimensions and coordinates, combined with its powerful data manipulation and visualization capabilities, makes it invaluable for geospatial analysis. By using Xarray, you can efficiently manage and analyze complex datasets, such as time series and raster data, enabling more insightful geospatial analyses.
