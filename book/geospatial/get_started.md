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

# Get Started

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/geospatial/get_started.ipynb)

## Introduction

Now that we've covered the basics of Python programming, we will begin exploring geospatial data analysis and visualization using Python. This chapter introduces you to key geospatial libraries that form the foundation for working with spatial data in Python.

Geospatial data analysis is essential for various applications, including environmental monitoring, urban planning, and mapping. Python's ecosystem offers a robust set of libraries for handling both vector and raster data, performing spatial analysis, and creating interactive maps. Some of the core libraries we will work with include:

- **[GeoPandas](https://geopandas.org):** For handling vector data such as shapefiles, GeoJSON, and performing spatial operations.
- **[Rasterio](https://rasterio.readthedocs.io):** To read, analyze, and write raster data (e.g., satellite imagery).
- **[Xarray](https://xarray.pydata.org):** For multidimensional array-based data, often used with climate and meteorological datasets.
- **[Leafmap](https://leafmap.org):** Simplifies creating interactive maps with minimal code.
- **[MapLibre](https://eodagmbh.github.io/py-maplibregl/):** A tool for building interactive, customizable map visualizations using vector tiles.
- **[WhiteboxTools](https://github.com/jblindsay/whitebox-tools):** A suite of GIS tools for spatial analysis.
- **[Geemap](https://geemap.org):** Combines the power of Google Earth Engine with Python for large-scale geospatial analysis.
- **[Segment-geospatial](https://samgeo.gishub.org):** An advanced tool for image segmentation in geospatial analysis.
- **[HyperCoast](https://hypercoast.org):** Used for coastal data modeling and analysis.
- **[DuckDB](https://duckdb.org):** A fast, embeddable analytical database with powerful spatial query capabilities.
- **[GDAL](https://gdal.org):** One of the most widely used libraries for raster and vector data processing.

These libraries will be introduced progressively, and we'll explore their capabilities through hands-on exercises.

+++

## Setting Up Your Python Environment

To follow along with the examples and exercises in this book, you need to set up a Python environment with the required geospatial libraries. There are two main ways to set up your Python environment: using **uv** or **conda**.

### uv

[uv](https://github.com/astral-sh/uv) is an extremely fast Python package and project manager, written in Rust. It is designed to be a drop-in replacement for pip.

#### Install uv

You can install uv as follows:

```bash
# macOS and Linux:
curl -LsSf https://astral.sh/uv/install.sh | sh

# Windows:
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"

# pip
pip install uv
```

#### Install geospatial

To install the [geospatial](https://geospatial.gishub.org) package, which includes many of the libraries we'll use in this book, run the following commands:

```bash
uv venv

# macOS and Linux:
source .venv/bin/activate

# Windows:
.venv\Scripts\activate

uv pip install geospatial
uv pip install --find-links https://girder.github.io/large_image_wheels gdal pyproj
```

### pixi

[Pixi](https://pixi.sh) is a package management tool for installing libraries and applications in a reproducible way. It can install packages from the conda-forge channel, PyPI, and other sources. If you have trouble installing geospatial libraries like gdal using uv, you can try using pixi.

#### Install pixi

You can install pixi as follows:

```bash
# macOS and Linux:
curl -fsSL https://pixi.sh/install.sh | bash

# Windows:
iwr -useb https://pixi.sh/install.ps1 | iex
```

Close and reopen your terminal or command prompt to make sure the pixi command is available.

#### Install gdal

To install the gdal and jupyterlab packages,run the following commands:

```bash
pixi init
pixi add gdal jupyterlab
```

After installing the packages, you can open Jupyter Lab to start working with geospatial data:

```bash
pixi run jupyter lab
```

### conda

#### Install Miniconda

Miniconda is a lightweight version of Anaconda and provides all the core functionality needed to manage environments. You can download and install it from the official Miniconda page: [Miniconda Installation Guide](https://docs.anaconda.com/miniconda).

#### Create a New Conda Environment

Once Miniconda is installed, you can create a new environment specifically for geospatial programming. This isolates your geospatial tools from other Python projects, helping avoid version conflicts.

Run the following commands in your terminal or command prompt:

```bash
conda create -n geo python=3.11
conda activate geo
```

#### Install Geospatial Libraries

To manage the installation of multiple geospatial libraries more efficiently, we'll use mamba, a faster alternative to conda. Install it first, then proceed with the [geospatial](https://geospatial.gishub.org) package, which includes many of the libraries we'll use in this book:

```bash
conda install -c conda-forge mamba
mamba install -c conda-forge geospatail
```

+++

## Verifying Your Installation

Once you've set up your environment, it's important to verify that everything is working correctly. Let's run a simple test using leafmap to ensure the installation is successful.

1. Import the `leafmap` library:

```{code-cell} ipython3
import leafmap.foliumap as leafmap
```

2. Create an interactive map using leafmap.Map() and display it:

```{code-cell} ipython3
m = leafmap.Map()
m
```

If everything is set up correctly, you should see an interactive map displayed in your notebook or Jupyter Lab environment. This confirms that your Python environment is ready for geospatial data analysis and visualization.

## Summary

By setting up the Python environment and testing it with a simple map, you have laid the groundwork for more advanced geospatial analysis. In the upcoming chapters, we will dive into specific libraries, their functions, and how they can be applied to real-world geospatial data projects. From basic vector and raster manipulations to creating dynamic visualizations, you'll progressively gain skills to tackle complex geospatial tasks.

Make sure to revisit this setup guide if you encounter any issues with your environment, and don't hesitate to reach out for troubleshooting help!
