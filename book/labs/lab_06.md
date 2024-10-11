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

## Exercise 1: Exploring the Sea Surface Temperature Dataset

1. **Load the sea surface temperature dataset** from the NetCDF file ([`sea_surface_temperature.nc`](https://github.com/opengeos/datasets/releases/download/netcdf/sea_surface_temperature.nc)).
2. **Inspect the `Dataset` object** and list all the available variables and dimensions in the dataset.
3. **Select the `sst` variable** (sea surface temperature).
4. **Print the attributes, dimensions, and coordinates** of the `sst` variable to understand the metadata.

This exercise allows you to practice selecting specific subsets of data and visualizing SST patterns over a specified period.

```{code-cell} ipython3

```

## Exercise 2: Data Selection and Indexing

1. **Select a subset of the `sst` data** for a specific time (`2010-07-01`) and latitude (`0.0`), which represents the Equator.
2. **Create a time slice** for the SST data between January and March 2010 for all latitudes and longitudes.
3. **Plot the time slice** as a line plot, showing the latitude-averaged SST over time.

This exercise allows you to practice selecting specific subsets of data and visualizing SST patterns over a specified period.

```{code-cell} ipython3

```

## Exercise 3: Performing Arithmetic Operations

1. **Compute the mean SST** over the entire time range (2010-2015) to obtain the average sea surface temperature for each spatial location.
2. **Calculate the temperature anomalies** by subtracting the computed mean from the original SST values. This helps understand how SST deviates from the mean during the time period.
3. **Plot both the mean SST and the anomalies** on separate plots to visualize spatial temperature patterns and deviations. You can select a specific time to display the anomalies.

This exercise introduces arithmetic operations on the dataset, focusing on the concept of temperature anomalies.

```{code-cell} ipython3

```

## Exercise 4: GroupBy and Resampling

1. **Use `groupby` to calculate the seasonal mean SST**. Group the data by season (`DJF`, `MAM`, `JJA`, and `SON`) and compute the average SST for each season.
2. **Resample the dataset to compute the monthly mean SST**. This aggregates the data on a monthly basis.
3. **Plot the seasonal mean SST and the monthly mean SST** to visualize how sea surface temperature varies by season and by month.

This exercise demonstrates how to group and resample time-series data, commonly used in climate data analysis.

```{code-cell} ipython3

```

## Exercise 5: Writing Data to NetCDF

1. **Select the SST anomalies** calculated in Exercise 3 for further analysis and export.
2. **Convert the `sst` variable to `float32`** to optimize file size before writing the data to a NetCDF file.
3. **Write the anomalies data** to a new NetCDF file named `sst_anomalies.nc` for storage and future use.
4. **Load the saved NetCDF file** back into memory and print its contents to verify the saved data.

This exercise teaches how to export processed geospatial data to NetCDF, a widely-used file format in climate data analysis.

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
2. Use the GeoJSON to mask the reprojected raster dataset, keeping only the data within the GeoJSON boundaries.
3. Plot the masked raster data.

```{code-cell} ipython3

```

## Exercise 10: Resample the Raster to a Different Resolution

1. Resample the raster dataset to a 3m resolution, using an average resampling method.
2. Check the new dimensions and coordinates after resampling.
3. Save the resampled raster dataset as a new GeoTIFF file.

```{code-cell} ipython3

```
