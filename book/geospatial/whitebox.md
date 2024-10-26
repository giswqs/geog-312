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

# Whitebox

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/geospatial/whitebox.ipynb)

+++

## Overview

In this lecture, we will explore the use of [**WhiteboxTools**](https://github.com/jblindsay/whitebox-tools), a powerful open-source library for performing geospatial analysis. Specifically, we will focus on two key applications: **watershed analysis** and **LiDAR data analysis**. You will learn how to manipulate geospatial data using Python, conduct hydrological analysis, and derive digital elevation models (DEMs) and canopy height models (CHMs) from LiDAR data.

This lecture is structured into two main sections:
1. **Watershed Analysis**: Using DEMs and hydrological tools to delineate watersheds, calculate flow accumulation, and extract stream networks.
2. **LiDAR Data Analysis**: Processing LiDAR point cloud data to derive DEMs, DSMs, and CHMs while removing outliers and improving data quality.

By the end of this session, you will have gained hands-on experience with **WhiteboxTools** and **leafmap**, allowing you to perform a wide range of geospatial and hydrological analyses.

## Learning Objectives

By the end of this lecture, you will be able to:
- Install and configure **WhiteboxTools** and **leafmap** for geospatial analysis.
- Create interactive maps to visualize basemaps and geospatial datasets.
- Perform watershed analysis by delineating watersheds, flow directions, and stream networks.
- Manipulate and analyze Digital Elevation Models (DEMs) to conduct hydrological modeling.
- Process and analyze LiDAR data to generate **Digital Surface Models (DSMs)**, **Digital Elevation Models (DEMs)**, and **Canopy Height Models (CHMs)**.
- Integrate **WhiteboxTools** with Python workflows to automate geospatial analysis.


## Introduction

Below is a brief introduction to Whitebox, a powerful open-source library for geospatial analysis. For more information, please refer to the whiteboxgeo website: https://www.whiteboxgeo.com.

### What is Whitebox?

Whitebox is geospatial data analysis software originally developed at the University of Guelph‘s Geomorphometry and Hydrogeomatics Research Group ([GHRG](https://jblindsay.github.io/ghrg/index.html)) directed by Dr. John Lindsay. Whitebox contains over 550 tools for processing many types of geospatial data. It has many great features such as its extensive use of parallel computing, it doesn’t need other libraries to be installed (e.g., GDAL), it can be used from scripting environments, and it easily plugs into other geographical information system (GIS) software. The Whitebox Toolset Extension provides even more power.

### What can Whitebox do?

Whitebox can be used to perform common GIS and remote sensing analysis tasks. Whitebox also contains advanced tooling for spatial hydrological analysis and LiDAR data processing. Whitebox is not a cartographic or spatial data visualization package; instead it’s meant to serve as an analytical back-end for other data visualization software, like QGIS and ArcGIS.

### How is Whitebox different?

Whitebox doesn’t compete with QGIS, ArcGIS/Pro, and ArcPy but rather it extends them. You can plug WhiteboxTools into QGIS and ArcGIS and it’ll provide hundreds of additional tools for analyzing all kinds of geospatial data. You can also call Whitebox functions from Python scripts using [Whitebox Workflows](https://www.whiteboxgeo.com/whitebox-workflows-for-python) (WbW). Combine WbW with ArcPy to more effectively automate your data analysis workflows and streamline your geoprocessing solutions.

There are many tools in Whitebox that you won’t find elsewhere. You can think of Whitebox as a portable, cross-platform GIS analysis powerhouse, allowing you to extend your preferred GIS or to embed Whitebox capabilities into your automated scripted workflows. Oh, and it’s fast, really fast!


## Useful Resources for Whitebox

- GitHub Repository: https://github.com/jblindsay/whitebox-tools
- WhiteboxGeo: https://www.whiteboxgeo.com
- User Manual: https://whiteboxgeo.com/manual/wbt_book/preface.html
- Whitebox Workflows for Python: https://www.whiteboxgeo.com/whitebox-workflows-for-python
- Whitebox Workflows for Python Pro: https://www.whiteboxgeo.com/whitebox-workflows-professional
- Python Frontend: https://github.com/opengeos/whitebox-python
- Jupyter Frontend: https://github.com/opengeos/whiteboxgui
- R Frontend: https://github.com/opengeos/whiteboxR
- ArcGIS Toolbox: https://github.com/opengeos/WhiteboxTools-ArcGIS
- QGIS Plugin: https://plugins.qgis.org/plugins/whitebox_workflows_for_qgis

## Installation

To get started, we need to install the required packages, such as `leafmap`, and `whitebox`. Uncomment the following lines to install the packages.

```{code-cell} ipython3
# %pip install "leafmap[raster]" "leafmap[lidar]" mapclassify
```

```{code-cell} ipython3
# %pip install numpy==1.26.4
```

## Import libraries

```{code-cell} ipython3
import os
import leafmap
import numpy as np
```

Some of the raster datasets generated by whitebox will be int32 type with a nodata value of -32768. To make it easier to visualize these datasets, we set the nodata value as an environment variable, which will be used by leafmap to set the nodata value when visualizing the raster datasets.

```{code-cell} ipython3
os.environ["NODATA"] = "-32768"
```

## Part 1: Watershed Analysis

### Create Interactive Maps

To perform watershed analysis, we first create an interactive map using **leafmap**. This step allows us to visualize different basemaps.

```{code-cell} ipython3
m = leafmap.Map()
m.add_basemap("OpenTopoMap")
m.add_basemap("USGS 3DEP Elevation")
m.add_basemap("USGS Hydrography")
m
```

### Download Watershed Data

Next, we download watershed data for the **Calapooia River basin** in Oregon. We'll use the latitude and longitude of a point in the basin to extract watershed boundary data.

```{code-cell} ipython3
lat = 44.361169
lon = -122.821802

m = leafmap.Map(center=[lat, lon], zoom=10)
m.add_marker([lat, lon])
m
```

Download the watershed data and visualize it:

```{code-cell} ipython3
geometry = {"x": lon, "y": lat}
```

```{code-cell} ipython3
gdf = leafmap.get_wbd(geometry, digit=10, return_geometry=True)
gdf.explore()
```

Save the watershed boundary to a **GeoJSON** file:

```{code-cell} ipython3
gdf.to_file("basin.geojson")
```

### Download and Display DEM

We download a **Digital Elevation Model (DEM)** from the USGS 3DEP Elevation service to analyze the terrain of the watershed. The DEM will be used to delineate watersheds, calculate flow accumulation, and extract stream networks. The `leafmap.get_3dep_dem()` function returns the DEM as an `xarray.DataArray` object. Optionally, you can save the DEM to a GeoTIFF file by setting the `output` parameter.

```{code-cell} ipython3
array = leafmap.get_3dep_dem(
    gdf,
    resolution=30,
    output="dem.tif",
    dst_crs="EPSG:3857",
    to_cog=True,
    overwrite=True,
)
array
```

Visualize the DEM on the map:

```{code-cell} ipython3
m.add_raster("dem.tif", palette="terrain", nodata=np.nan, layer_name="DEM")
m
```

### Get DEM metadata

We can get the metadata of the DEM, such as the spatial resolution, bounding box, and coordinate reference system (CRS).

```{code-cell} ipython3
metadata = leafmap.image_metadata("dem.tif")
metadata
```

Get a summary statistics of the DEM.

+++

### Add colorbar

Add a colorbar to the map to show the elevation values. Use the `image_min_max()` function to get the minimum and maximum values of the DEM.

```{code-cell} ipython3
leafmap.image_min_max("dem.tif")
```

```{code-cell} ipython3
m.add_colormap(cmap="terrain", vmin="60", vmax=1500, label="Elevation (m)")
```

### Initialize WhiteboxTools

Initialize the WhiteboxTools class.

```{code-cell} ipython3
wbt = leafmap.WhiteboxTools()
```

Check the WhiteboxTools version.

```{code-cell} ipython3
wbt.version()
```

Display the WhiteboxTools interface, which lists all available tools. You can use this interface to search for specific tools. You can also run any tool using the interface. However, we will use the Python API to run the tools.

```{code-cell} ipython3
leafmap.whiteboxgui()
```

### Set working directory

Set the working directory to save the intermediate and output files. Set `wbt.version=False` to suppress the Whitebox processing log.

```{code-cell} ipython3
wbt.set_working_dir(os.getcwd())
wbt.verbose = False
```

### Smooth DEM

All WhiteboxTools functions will return 0 if they are successful, and 1 if they are not.

Smoothing the DEM enhances the quality of subsequent hydrological analysis.

```{code-cell} ipython3
wbt.feature_preserving_smoothing("dem.tif", "smoothed.tif", filter=9)
```

Visualize the smoothed DEM and watershed boundary on the map.

+++

Visualize the smoothed DEM:

```{code-cell} ipython3
m = leafmap.Map()
m.add_basemap("Satellite")
m.add_raster("smoothed.tif", colormap="terrain", layer_name="Smoothed DEM")
m.add_geojson("basin.geojson", layer_name="Watershed", info_mode=None)
m.add_basemap("USGS Hydrography", show=False)
m
```

### Create hillshade

Create a hillshade from the smoothed DEM.

```{code-cell} ipython3
wbt.hillshade("smoothed.tif", "hillshade.tif", azimuth=315, altitude=35)
```

Overlay the hillshade on the smoothed DEM with transparency.

```{code-cell} ipython3
m.add_raster("hillshade.tif", layer_name="Hillshade")
m.layers[-1].opacity = 0.6
```

### Find no-flow cells

Find cells with undefined flow, i.e. no valid flow direction, based on the D8 flow direction algorithm.

```{code-cell} ipython3
wbt.find_no_flow_cells("smoothed.tif", "noflow.tif")
```

Visualize the no-flow cells on the map.

```{code-cell} ipython3
m.add_raster("noflow.tif", layer_name="No Flow Cells")
```

### Fill depressions

First, we fill any depressions in the DEM to ensure proper flow simulation.

```{code-cell} ipython3
wbt.fill_depressions("smoothed.tif", "filled.tif")
```

Alternatively, you can use depression breaching to fill the depressions.

```{code-cell} ipython3
wbt.breach_depressions("smoothed.tif", "breached.tif")
```

```{code-cell} ipython3
wbt.find_no_flow_cells("breached.tif", "noflow2.tif")
```

```{code-cell} ipython3
m.layers[-1].visible = False
m.add_raster("noflow2.tif", layer_name="No Flow Cells after Breaching")
m
```

### Delineate flow direction

Next, we delineate the flow direction based on the D8 algorithm.

```{code-cell} ipython3
wbt.d8_pointer("breached.tif", "flow_direction.tif")
```

### Calculate flow accumulation

Now, calculate **flow accumulation** to understand how water collects across the landscape.

```{code-cell} ipython3
wbt.d8_flow_accumulation("breached.tif", "flow_accum.tif")
```

```{code-cell} ipython3
m.add_raster("flow_accum.tif", layer_name="Flow Accumulation")
```

### Extract streams

Extract the stream network using the flow accumulation data.

```{code-cell} ipython3
wbt.extract_streams("flow_accum.tif", "streams.tif", threshold=5000)
```

```{code-cell} ipython3
m.layers[-1].visible = False
m.add_raster("streams.tif", layer_name="Streams")
```

### Calculate distance to outlet

```{code-cell} ipython3
wbt.distance_to_outlet(
    "flow_direction.tif", streams="streams.tif", output="distance_to_outlet.tif"
)
```

```{code-cell} ipython3
m.add_raster("distance_to_outlet.tif", layer_name="Distance to Outlet")
```

### Vectorize streams

```{code-cell} ipython3
wbt.raster_streams_to_vector(
    "streams.tif", d8_pntr="flow_direction.tif", output="streams.shp"
)
```

The raster_streams_to_vector tool has a bug. The output vector file is missing the coordinate system. Use `leafmap.vector_set_crs()` to set the coordinate system.

```{code-cell} ipython3
leafmap.vector_set_crs(source="streams.shp", output="streams.shp", crs="EPSG:3857")
```

```{code-cell} ipython3
m.add_shp(
    "streams.shp",
    layer_name="Streams Vector",
    style={"color": "#ff0000", "weight": 3},
    info_mode=None,
)
m
```

You can turn on the USGS Hydrography basemap to visualize the stream network and compare it with the extracted stream network.

+++

### Delineate the longest flow path

You can delineate the longest flow path in the watershed.

```{code-cell} ipython3
wbt.basins("flow_direction.tif", "basins.tif")
```

```{code-cell} ipython3
wbt.longest_flowpath(
    dem="breached.tif", basins="basins.tif", output="longest_flowpath.shp"
)
```

Select only the longest flow path.

```{code-cell} ipython3
leafmap.select_largest(
    "longest_flowpath.shp", column="LENGTH", output="longest_flowpath.shp"
)
```

```{code-cell} ipython3
m.add_shp(
    "longest_flowpath.shp",
    layer_name="Longest Flowpath",
    style={"color": "#ff0000", "weight": 3},
)
m
```

### Generate a pour point

To delineate a watershed, you need to specify a pour point. You can use the outlet of the longest flow path as the pour point or specify a different point. Use the drawing tool to place a marker on the map to specify the pour point. If no marker is placed, the default pour point below will be used.

```{code-cell} ipython3
if m.user_roi is not None:
    m.save_draw_features("pour_point.shp", crs="EPSG:3857")
else:
    lat = 44.284642
    lon = -122.611217
    leafmap.coords_to_vector([lon, lat], output="pour_point.shp", crs="EPSG:3857")
    m.add_marker([lat, lon])
```

### Snap pour point to stream

Snap the pour point to the nearest stream.

```{code-cell} ipython3
wbt.snap_pour_points(
    "pour_point.shp", "flow_accum.tif", "pour_point_snapped.shp", snap_dist=300
)
```

Visualize the snapped pour point on the map.

```{code-cell} ipython3
m.add_shp("pour_point_snapped.shp", layer_name="Pour Point", info_mode=False)
```

### Delineate watershed

Delineate the watershed using a **pour point** and the flow direction data.

```{code-cell} ipython3
wbt.watershed("flow_direction.tif", "pour_point_snapped.shp", "watershed.tif")
```

Visualize the watershed boundary on the map.

```{code-cell} ipython3
m.add_raster("watershed.tif", layer_name="Watershed")
m
```

### Convert watershed raster to vector

You can convert the watershed raster to a vector file.

```{code-cell} ipython3
wbt.raster_to_vector_polygons("watershed.tif", "watershed.shp")
```

Visualize the watershed boundary on the map.

```{code-cell} ipython3
m.layers[-1].visible = False
m.add_shp(
    "watershed.shp",
    layer_name="Watershed Vector",
    style={"color": "#ffff00", "weight": 3},
    info_mode=False,
)
```

## Part 2: LiDAR Data Analysis

In this section, we will process LiDAR data to derive **Digital Surface Models (DSMs)**, **Digital Elevation Models (DEMs)**, and **Canopy Height Models (CHMs)**. We will also remove outliers and improve the quality of the LiDAR data.

### Set up whitebox

First, we set up the WhiteboxTools and leafmap libraries.

```{code-cell} ipython3
import leafmap
```

```{code-cell} ipython3
wbt = leafmap.WhiteboxTools()
wbt.set_working_dir(os.getcwd())
wbt.verbose = False
```

### Download a sample dataset

We download a sample LiDAR dataset for **Madison**.

```{code-cell} ipython3
url = "https://github.com/opengeos/datasets/releases/download/lidar/madison.zip"
filename = "madison.las"
```

```{code-cell} ipython3
leafmap.download_file(url, "madison.zip", quiet=True)
```

### Read LAS/LAZ data

Load and inspect the LiDAR data:

```{code-cell} ipython3
laz = leafmap.read_lidar(filename)
```

```{code-cell} ipython3
laz
```

```{code-cell} ipython3
str(laz.header.version)
```

### Upgrade file version

Upgrade the LAS file version to 1.4.

```{code-cell} ipython3
las = leafmap.convert_lidar(laz, file_version="1.4")
```

```{code-cell} ipython3
str(las.header.version)
```

### Write LAS data

Save the LAS data to a new file.

```{code-cell} ipython3
leafmap.write_lidar(las, "madison.las")
```

### Histogram analysis

Plot the histogram of the LiDAR data. The histogram shows the distribution of the LiDAR points based on their elevation values. The tool generates a histogram of the LiDAR data and saves it to an HTM file. You can open the HTM file in a web browser to view the histogram.

```{code-cell} ipython3
wbt.lidar_histogram("madison.las", "histogram.html")
```

### Visualize LiDAR data

Run the `view_lidar()` function to visualize the LiDAR data in 3D. Note that the `view_lidar()` function may not work in some environments, such as Google Colab.

```{code-cell} ipython3
leafmap.view_lidar("madison.las")
```

### Remove outliers

Remove outliers from the LiDAR dataset:

```{code-cell} ipython3
wbt.lidar_elevation_slice("madison.las", "madison_rm.las", minz=0, maxz=450)
```

### Visualize LiDAR data after removing outliers

We can visualize the LiDAR data after removing the outliers.

```{code-cell} ipython3
leafmap.view_lidar("madison_rm.las", cmap="terrain")
```

### Create DSM

Using the LiDAR data to create a **Digital Surface Model (DSM)**.

```{code-cell} ipython3
wbt.lidar_digital_surface_model(
    "madison_rm.las", "dsm.tif", resolution=1.0, minz=0, maxz=450
)
```

The DSM generated by whitebox is missing the coordinate system. Use `leafmap.raster_set_crs()` to set the coordinate system.

```{code-cell} ipython3
:jp-MarkdownHeadingCollapsed: true

leafmap.add_crs("dsm.tif", epsg=2255)
```

### Visualize DSM

Visualize the DSM on the map.

```{code-cell} ipython3
m = leafmap.Map()
m.add_basemap("Satellite")
m.add_raster("dsm.tif", colormap="terrain", layer_name="DSM")
m
```

### Create DEM

We can create a bare-earth DEM from the DSM. The tool is typically applied to LiDAR DEMs which frequently contain numerous off-terrain objects (OTOs) such as buildings, trees and other vegetation, cars, fences and other anthropogenic objects.

```{code-cell} ipython3
wbt.remove_off_terrain_objects("dsm.tif", "dem.tif", filter=25, slope=15.0)
```

### Visualize DEM

Visualize the bear-earth DEM on the map.

```{code-cell} ipython3
m.add_raster("dem.tif", palette="terrain", layer_name="DEM")
m
```

### Create CHM


We can a **Canopy Height Model (CHM)** by subtracting the DEM from the DSM.

```{code-cell} ipython3
chm = wbt.subtract("dsm.tif", "dem.tif", "chm.tif")
```

Visualize the CHM on the map.

```{code-cell} ipython3
m.add_raster("chm.tif", palette="gist_earth", layer_name="CHM")
m.add_layer_manager()
m
```

## Summary

This lecture provided a comprehensive introduction to **WhiteboxTools**, an open-source geospatial analysis library with a focus on hydrological and LiDAR data analysis. Through this session, students learned to install and configure WhiteboxTools in Python, integrate it with **leafmap** for interactive mapping, and apply it to specific geospatial tasks.

Key takeaways from this lecture include:

- **Watershed Analysis**: The lecture covered watershed delineation using Digital Elevation Models (DEMs), including techniques like flow direction, flow accumulation, stream extraction, and watershed boundary delineation.
- **LiDAR Data Processing**: Students were introduced to LiDAR data manipulation, including the derivation of Digital Surface Models (DSMs), Digital Elevation Models (DEMs), and Canopy Height Models (CHMs), along with methods for outlier removal and terrain quality improvement.

By completing the hands-on exercises, students gained practical experience with WhiteboxTools for geospatial processing, preparing them to apply these techniques in varied real-world GIS workflows.
