---
jupytext:
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.16.4
kernelspec:
  display_name: Python 3 (ipykernel)
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

![](https://docs.xarray.dev/en/stable/_images/dataset-diagram.png)

Xarray is particularly useful for working with datasets where dimensions have meaningful labels (e.g., time, latitude, longitude) and where metadata is important.

+++

## Installing Xarray

Before we start, ensure that Xarray is installed. You can install it via pip:

```{code-cell} ipython3
# %pip install xarray pooch
```

## Importing Libraries

```{code-cell} ipython3
import matplotlib.pyplot as plt
import numpy as np
import xarray as xr

xr.set_options(keep_attrs=True, display_expand_data=False)
np.set_printoptions(threshold=10, edgeitems=2)
```

## Xarray Data Structures

Xarray provides two core data structures:

1. **DataArray**: A single multi-dimensional array with labeled dimensions, coordinates, and metadata.
2. **Dataset**: A collection of `DataArray` objects, each corresponding to a variable, sharing the same dimensions and coordinates.

### Loading a Dataset

Xarray offers built-in access to several tutorial datasets, which we can load with `xr.tutorial.load_dataset`. Here, we load an air temperature dataset:

```{code-cell} ipython3
ds = xr.tutorial.load_dataset("air_temperature")
ds
```

This dataset is stored in the [netCDF](https://www.unidata.ucar.edu/software/netcdf) format, a common format for scientific data. Xarray automatically parses metadata like dimensions and coordinates.


## Working with DataArrays

The `DataArray` is the core data structure in Xarray. It includes data values, dimensions (e.g., time, latitude, longitude), and the coordinates for each dimension.

```{code-cell} ipython3
# Access a specific DataArray
temperature = ds["air"]
temperature
```

You can also access DataArray using dot notation:

```{code-cell} ipython3
ds.air
```

### DataArray Components

- **Values**: The actual data stored in a NumPy array or similar structure.
- **Dimensions**: Named axes of the data (e.g., time, latitude, longitude).
- **Coordinates**: Labels for the values in each dimension (e.g., specific times or geographic locations).
- **Attributes**: Metadata associated with the data (e.g., units, descriptions).

You can extract and print the values, dimensions, and coordinates of a `DataArray`:

```{code-cell} ipython3
temperature.values
```

```{code-cell} ipython3
temperature.dims
```

```{code-cell} ipython3
temperature.coords
```

```{code-cell} ipython3
temperature.attrs
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
# Plot the mean temperature
mean_temperature.plot()
plt.show()
```

```{code-cell} ipython3
# Plot a time series for a specific location
temperature.sel(lat=40.0, lon=260.0).plot()
plt.show()
```

## Working with Datasets

A `Dataset` is a collection of `DataArray` objects. It is useful when you need to work with multiple related variables.

```{code-cell} ipython3
# List all variables in the dataset
print(ds.data_vars)
```

```{code-cell} ipython3
# Access a DataArray from the Dataset
temperature = ds["air"]
```

```{code-cell} ipython3
# Perform operations on the Dataset
mean_temp_ds = ds.mean(dim="time")
mean_temp_ds
```

## Why Use Xarray?

Xarray is valuable for handling multi-dimensional data, especially in scientific applications. It provides metadata, dimension names, and coordinate labels, making it much easier to understand and manipulate data compared to raw NumPy arrays.

### Without Xarray (Using NumPy)

Here's how a task might look without Xarray, using NumPy arrays:

```{code-cell} ipython3
lat = ds.air.lat.data
lon = ds.air.lon.data
temp = ds.air.data
```

```{code-cell} ipython3
plt.figure()
plt.pcolormesh(lon, lat, temp[0, :, :])
```

While this approach works, it's not clear what `0` refers to (in this case, it's the first time step).

### With Xarray

With Xarray, you can use more intuitive and readable indexing:

```{code-cell} ipython3
ds.air.isel(time=0).plot(x="lon")
```

This example selects the first time step and plots it using labeled axes (`lat` and `lon`), which is much clearer.



## Advanced Indexing: Label vs. Position-Based Indexing

Xarray supports both label-based and position-based indexing, making it flexible for data selection.

### Label-based Indexing

You can use `.sel()` to select data based on the labels of coordinates, such as specific times or locations:

```{code-cell} ipython3
# Select all data from May 2013
ds.sel(time="2013-05")
```

```{code-cell} ipython3
# Slice over time, selecting data between May and July 2013
ds.sel(time=slice("2013-05", "2013-07"))
```

### Position-based Indexing

Alternatively, you can use `.isel()` to select data based on the positions of coordinates:

```{code-cell} ipython3
# Select the first time step, second latitude, and third longitude
ds.air.isel(time=0, lat=2, lon=3)
```

## High-Level Computations with Xarray

Xarray offers several high-level operations that make common computations straightforward, such as `groupby`, `resample`, `rolling`, and `weighted`.

### Example: GroupBy Operation

You can calculate statistics such as the seasonal mean of the dataset:

```{code-cell} ipython3
seasonal_mean = ds.groupby("time.season").mean()
seasonal_mean.air.plot(col="season")
```

## Computation with Weights

Xarray allows for weighted computations, useful in geospatial contexts where grid cells vary in size. For example, you can weight the mean of the dataset by cell area.

Example: Weighting by cell area

```{code-cell} ipython3
cell_area = xr.ones_like(ds.air.lon)  # Placeholder for actual area calculation
weighted_mean = ds.weighted(cell_area).mean(dim=["lon", "lat"])
weighted_mean.air.plot()
```

## Reading and Writing Files

Xarray supports many common scientific data formats, including netCDF and Zarr. You can read and write datasets to disk with a few simple commands.

### Writing to netCDF

To save a dataset as a netCDF file:

```{code-cell} ipython3
ds.to_netcdf("air_temperature.nc")
```

### Reading from netCDF

To load a dataset from a netCDF file:

```{code-cell} ipython3
loaded_data = xr.open_dataset("air_temperature.nc")
loaded_data
```

## Summary

Xarray is a powerful library for working with multi-dimensional geospatial data. It simplifies data handling by offering labeled dimensions and coordinates, enabling intuitive operations and making analysis more transparent. Xarray's ability to work seamlessly with NumPy, Dask, and Pandas makes it an essential tool for geospatial and scientific analysis. With Xarray, you can efficiently manage and analyze large, complex datasets, making it a valuable asset for researchers and developers alike.
