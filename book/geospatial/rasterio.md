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

# Rasterio

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/geospatial/rasterio.ipynb)

## Introduction

[Rasterio](https://rasterio.readthedocs.io/) is a Python library that allows you to read, write, and analyze geospatial raster data. It is built on top of GDAL (Geospatial Data Abstraction Library) and provides a simple, Pythonic interface to work with raster datasets, such as satellite images and digital elevation models (DEMs).

+++

## Installing and Importing Rasterio

Before using Rasterio, you need to install it. You can install Rasterio using pip:

`!pip install rasterio`

Once installed, you can import it like this:

```{code-cell} ipython3
import rasterio
from rasterio.plot import show
import matplotlib.pyplot as plt
```

## Reading Raster Data

Rasterio allows you to read raster data in various formats, including GeoTIFF. Let's start by reading a raster file and displaying some basic information about the dataset.

```{code-cell} ipython3
# Reading a raster file
raster_path = "https://github.com/opengeos/datasets/releases/download/raster/srtm90.tif"
try:
    with rasterio.open(raster_path) as src:
        print(f"Raster CRS: {src.crs}")
        print(f"Raster dimensions: {src.width} x {src.height}")
        print(f"Raster bounds: {src.bounds}")
        print(f"Raster count: {src.count}")  # Number of bands
except Exception as e:
    print(f"An error occurred: {e}")
```

## Plotting Raster Data

Rasterio integrates well with Matplotlib, allowing you to easily plot raster data. Let's plot the raster data we just read.

```{code-cell} ipython3
# Plotting the raster data
try:
    with rasterio.open(raster_path) as src:
        fig, ax = plt.subplots(figsize=(10, 10))
        show(src, ax=ax, title="Raster Data")
        plt.show()
except Exception as e:
    print(f"An error occurred: {e}")
```

## Accessing Raster Bands

Raster data often consists of multiple bands, each representing different information (e.g., different spectral bands in satellite imagery). You can access and manipulate these bands individually using Rasterio.

```{code-cell} ipython3
# Accessing and plotting a single band
try:
    with rasterio.open(raster_path) as src:
        band1 = src.read(1)  # Reading the first band
        plt.figure(figsize=(10, 10))
        plt.title("Band 1")
        plt.imshow(band1, cmap="gray")
        plt.colorbar(label="Pixel values")
        plt.show()
except Exception as e:
    print(f"An error occurred: {e}")
```

## Writing Raster Data

After processing or modifying raster data, you may want to save the results to a new file. Rasterio allows you to write raster data to various formats.

```{code-cell} ipython3
# Writing the modified raster data to a new file
output_raster_path = "output_raster_file.tif"
try:
    with rasterio.open(raster_path) as src:
        meta = src.meta
        with rasterio.open(output_raster_path, "w", **meta) as dst:
            dst.write(band1, 1)  # Writing the first band
    print(f"Raster data has been written to {output_raster_path}")
except Exception as e:
    print(f"An error occurred while writing to {output_raster_path}: {e}")
```

## Exercises

1. Load a raster file of your choice, display the metadata, and plot all the bands separately.
2. Modify one of the bands (e.g., apply a mathematical operation) and save the modified raster to a new file.
3. Write a function that calculates the histogram of pixel values for a given raster band and plots it.
4. Explore how to reproject a raster file to a different coordinate reference system (CRS) using Rasterio.

```{code-cell} ipython3
# Type your code here.
```

## Conclusion

Rasterio is a powerful library for working with geospatial raster data in Python. It provides a simple yet flexible interface for reading, writing, and analyzing raster data. By completing these exercises, you'll gain practical experience in handling raster data for geospatial applications.
