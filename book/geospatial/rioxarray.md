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

# Rioxarray

## Overview

[`rioxarray`](https://corteva.github.io/rioxarray/) is an extension of the powerful Python library Xarray that focuses on geospatial raster data. It provides easy access to georeferencing information and geospatial transforms using Xarray’s labeled, multi-dimensional data structures, which makes it an ideal tool for working with geospatial data like satellite imagery or climate data.

The key feature of `rioxarray` is its seamless integration of rasterio’s geospatial data handling capabilities (such as CRS and affine transforms) with Xarray’s efficient multi-dimensional array handling. This allows you to manipulate, analyze, and visualize raster data with ease.

## Learning Objectives

By the end of this lecture, you should be able to:
- Understand how `rioxarray` extends Xarray for geospatial data handling.
- Load and inspect georeferenced raster datasets using `rioxarray`.
- Perform basic geospatial operations, such as clipping, reprojection, and masking, using `rioxarray`.
- Use `rioxarray` to manage CRS and spatial dimensions in raster datasets.
- Export and visualize geospatial raster datasets.

## Installing rioxarray

To use `rioxarray`, you'll need to install it along with `rasterio` and its dependencies. You can install it via pip by uncommenting the following line:

```{code-cell} ipython3
# %pip install rioxarray rasterio
```

## Importing rioxarray

You can start by importing `rioxarray` and other necessary libraries:

```{code-cell} ipython3
import rioxarray
import xarray as xr
import matplotlib.pyplot as plt

xr.set_options(keep_attrs=True, display_expand_data=False)
```

## Loading Georeferenced Raster Data

One of the core functionalities of `rioxarray` is the ability to load georeferenced raster data, including its CRS and geospatial transformations. You can load a raster file (e.g., a GeoTIFF file) directly using `rioxarray`:

```{code-cell} ipython3
# Load a raster dataset using rioxarray
url = "https://github.com/opengeos/datasets/releases/download/raster/LC09_039035_20240708_90m.tif"
data = rioxarray.open_rasterio(url)
data
```

Here, `rioxarray.open_rasterio` loads the raster data into an Xarray `DataArray` and automatically attaches the geospatial metadata, including CRS, affine transformations, and spatial coordinates.

### Inspecting the Dataset

You can easily inspect the loaded dataset, including its dimensions, coordinates, and attributes:

```{code-cell} ipython3
# View the structure of the DataArray
print(data.dims)  # Dimensions (e.g., band, y, x)
```

```{code-cell} ipython3
print(data.coords)  # Coordinates (e.g., y, x in geographic or projected CRS)
```

```{code-cell} ipython3
print(data.attrs)  # Metadata (including CRS)
```

### Checking CRS and Transform Information

`rioxarray` integrates CRS and affine transform metadata into the Xarray object:

```{code-cell} ipython3
# Check the CRS of the dataset
print(data.rio.crs)
```

```{code-cell} ipython3
# Check the affine transformation (mapping pixel coordinates to geographic coordinates)
print(data.rio.transform())
```

## Basic Geospatial Operations

### Reprojecting a Dataset

You can reproject raster data to a different CRS using `rioxarray`. For example, to reproject the dataset to EPSG:4326 (WGS84), use the `rio.reproject` method:

```{code-cell} ipython3
# Reproject the dataset to WGS84 (EPSG:4326)
data_reprojected = data.rio.reproject("EPSG:4326")
print(data_reprojected.rio.crs)
```

### Clipping a Raster

You can clip a raster to a specific geographic region by defining a bounding box or using a shapefile. Here’s an example of clipping a raster with a bounding box:

```{code-cell} ipython3
# Define a bounding box (in the same CRS as the dataset)
bbox = [-115.391, 35.982, -114.988, 36.425]

# Clip the raster to the bounding box
clipped_data = data_reprojected.rio.clip_box(*bbox)
```

```{code-cell} ipython3
clipped_data.shape
```

Alternatively, you can clip the raster using a shapefile containing polygon geometries:

```{code-cell} ipython3
import geopandas as gpd

# Load a geojson with regions of interest
geojson_path = "https://github.com/opengeos/datasets/releases/download/places/las_vegas_bounds_utm.geojson"
bounds = gpd.read_file(geojson_path)

# Clip the raster to the shape
clipped_data2 = data.rio.clip(bounds.geometry, bounds.crs)
```

```{code-cell} ipython3
clipped_data2.shape
```

## Working with Spatial Dimensions

`rioxarray` supports operations on spatial dimensions (latitude/longitude or x/y coordinates) like resampling, reducing, or slicing.

### Resampling

To resample the raster dataset to a different resolution (e.g., 1 km), use the `rio.resample` method:

```{code-cell} ipython3
# Resample to 1km resolution (using an average resampling method)
resampled_data = data.rio.reproject(data.rio.crs, resolution=(1000, 1000))
```

```{code-cell} ipython3
resampled_data.shape
```

### Extracting Spatial Subsets

You can extract spatial subsets of the dataset by selecting specific coordinate ranges:

```{code-cell} ipython3
# Select a subset of the data within a lat/lon range
min_x, max_x = -115.391, -114.988
min_y, max_y = 35.982, 36.425
subset = data_reprojected.sel(x=slice(min_x, max_x), y=slice(max_y, min_y))  # Slice y in reverse order
subset.shape
```

## Visualization of Georeferenced Data

`rioxarray` integrates smoothly with Matplotlib and other visualization libraries, allowing for easy plotting of raster data:

```{code-cell} ipython3
# Plot the raster data
plt.figure(figsize=(8, 8))
data_reprojected.sel(band=[4, 3, 2]).plot.imshow(vmin=0, vmax=0.3)
plt.title("Landsat Image covering Las Vegas")
plt.xlabel("Longitude")
plt.ylabel("Latitude")
plt.show()
```

You can also visualize clipped or masked data in the same way:

```{code-cell} ipython3
# Plot the raster data
plt.figure(figsize=(8, 8))
clipped_data.sel(band=[4, 3, 2]).plot.imshow(vmin=0, vmax=0.3)
plt.title("Landsat Image covering Las Vegas")
plt.xlabel("Longitude")
plt.ylabel("Latitude")
plt.show()
```

For more advanced plots, such as overlaying a shapefile on the raster data, you can combine `rioxarray` with `geopandas` and `matplotlib`:

```{code-cell} ipython3
# Plot raster with GeoJSON overlay
fig, ax = plt.subplots(figsize=(8, 8))
data.sel(band=4).plot.imshow(ax=ax, vmin=0, vmax=0.4, cmap="gray")
bounds.boundary.plot(ax=ax, color='red')
plt.title("Raster with Vector Overlay")
plt.show()
```

## Saving Data

Just like loading data, you can export `rioxarray` datasets to disk. For example, you can save the modified or processed raster data as a GeoTIFF file:

```{code-cell} ipython3
# Save the DataArray as a GeoTIFF file
data.rio.to_raster("output_raster.tif")
```

## Exercises

### Exercise 1: Load and Inspect a Raster Dataset

1. Use `rioxarray` to load a GeoTIFF raster file (`raster_file.tif`).
2. Inspect the dataset by printing its dimensions, coordinates, and attributes.
3. Check and print the CRS and affine transformation of the dataset.

```{code-cell} ipython3

```

### Exercise 2: Reproject the Raster to a New CRS

1. Reproject the loaded raster dataset from its original CRS to EPSG:4326 (WGS84).
2. Print the new CRS and check the dimensions and coordinates of the reprojected data.
3. Plot the original and reprojected datasets for comparison.

```{code-cell} ipython3

```

### Exercise 3: Clip the Raster Using a Bounding Box

1. Define a bounding box with specific coordinates in the raster’s CRS (e.g., `xmin`, `ymin`, `xmax`, `ymax`).
2. Clip the raster dataset using this bounding box.
3. Plot the clipped data to visualize the result.

```{code-cell} ipython3

```

### Exercise 4: Mask the Raster Using a Shapefile

1. Load a shapefile (e.g., a region of interest) using `geopandas`.
2. Use the shapefile to mask the raster dataset, keeping only the data within the shapefile boundaries.
3. Plot the masked raster data.

```{code-cell} ipython3

```

### Exercise 5: Resample the Raster to a Different Resolution

1. Resample the raster dataset to a 1km resolution, using an average resampling method.
2. Check the new dimensions and coordinates after resampling.
3. Save the resampled raster dataset as a new GeoTIFF file.

```{code-cell} ipython3

```

## Summary

In this lecture, we have explored the basic functionality of `rioxarray`, a powerful extension of Xarray designed for geospatial raster data. Key points include:

- Loading and inspecting geospatial raster data with CRS and transform metadata.
- Performing essential geospatial operations, such as reprojection, clipping, and masking.
- Visualizing and exporting raster data.
- Working with spatial dimensions (x, y) using slicing, resampling, and other operations.

By integrating Xarray’s multi-dimensional data handling capabilities with rasterio’s geospatial features, `rioxarray` makes it easier to manage and analyze geospatial raster datasets. It is a versatile tool for anyone working with geospatial data in scientific computing, environmental analysis, or remote sensing.
