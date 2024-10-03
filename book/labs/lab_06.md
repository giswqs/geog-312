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

# Lab 6

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/labs/lab_06.ipynb)

## Overview

In this lab, you will practice handling multi-dimensional geospatial datasets using `Xarray` and `Rioxarray`. This includes working with NetCDF climate data and georeferenced raster datasets (GeoTIFF files). You will learn how to perform data selection, arithmetic operations, resampling, and reprojection, as well as saving your results back to disk.

By the end of this lab, you will have a better understanding of how to:

* Work with Xarray datasets (NetCDF format) and inspect geospatial raster data.
* Apply common data operations like slicing, resampling, and arithmetic analysis.
* Reproject, clip, mask, and resample raster datasets.
* Export processed data to various formats such as NetCDF and GeoTIFF.

## Exercise 1: Exploring a New Dataset

1. Load the Xarray tutorial dataset `rasm`.
2. Inspect the `Dataset` object and list all the variables and dimensions.
3. Select the `Tair` variable (air temperature).
4. Print the attributes, dimensions, and coordinates of `Tair`.

```{code-cell} ipython3

```

## Exercise 2: Data Selection and Indexing

1. Select a subset of the `Tair` data for the date `1980-07-01` and latitude `70.0`.
2. Create a time slice for the entire latitude range between January and March of 1980.
3. Plot the selected time slice as a line plot.

```{code-cell} ipython3

```

## Exercise 3: Performing Arithmetic Operations

1. Compute the mean of the `Tair` data over the `time` dimension.
2. Subtract the computed mean from the original `Tair` dataset to get the temperature anomalies.
3. Plot the mean temperature and the anomalies on separate plots.

```{code-cell} ipython3

```

## Exercise 4: GroupBy and Resampling

1. Use `groupby` to calculate the seasonal mean temperature (`Tair`).
2. Use `resample` to calculate the monthly mean temperature for 1980.
3. Plot the seasonal mean for each season and the monthly mean.

```{code-cell} ipython3

```

## Exercise 5: Writing Data to netCDF

1. Select the temperature anomalies calculated in Exercise 3.
2. Convert the `Tair` variable to `float32` to optimize file size.
3. Write the anomalies data to a new netCDF file named `tair_anomalies.nc`.
4. Load the data back from the file and print its contents.

```{code-cell} ipython3

```

## Exercise 6: Load and Inspect a Raster Dataset

1. Use `rioxarray` to load the GeoTIFF raster file at https://github.com/opengeos/datasets/releases/download/raster/Libya-2023-09-13.tif.
2. Inspect the dataset by printing its dimensions, coordinates, and attributes.
3. Check and print the CRS and affine transformation of the dataset.

```{code-cell} ipython3

```

## Exercise 7: Reproject the Raster to a New CRS

1. Reproject the loaded raster dataset from its original CRS to EPSG:4326 (WGS84).
2. Print the new CRS and check the dimensions and coordinates of the reprojected data.
3. Plot the original and reprojected datasets for comparison.

```{code-cell} ipython3

```

## Exercise 8: Clip the Raster Using a Bounding Box

1. Define a bounding box (e.g., `xmin`, `ymin`, `xmax`, `ymax`) that covers the land area of Libya.
2. Clip the raster dataset using this bounding box.
3. Plot the clipped data to visualize the result.

```{code-cell} ipython3

```

## Exercise 9: Mask the Raster Using a Vector Dataset

1. Load the GeoJSON file at https://github.com/opengeos/datasets/releases/download/raster/Derna_Libya.geojson using `geopandas`.
2. Use the GeoJSON to mask the raster dataset, keeping only the data within the GeoJSON boundaries.
3. Plot the masked raster data.

```{code-cell} ipython3

```

## Exercise 10: Resample the Raster to a Different Resolution

1. Resample the raster dataset to a 3m resolution, using an average resampling method.
2. Check the new dimensions and coordinates after resampling.
3. Save the resampled raster dataset as a new GeoTIFF file.

```{code-cell} ipython3

```
