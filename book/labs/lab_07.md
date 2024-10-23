---
jupytext:
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.16.4
kernelspec:
  display_name: geo
  language: python
  name: python3
---

# Lab 7

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/labs/lab_07.ipynb)

## Overview

In this lab, you will delve deeper into Leafmap, a powerful Python package for interactive geospatial mapping and analysis. You will explore how to work with various types of raster and vector data, customize basemaps and map layers, and visualize data using Cloud Optimized GeoTIFFs (COGs), PMTiles, GeoParquet, and other formats. You will also learn how to enhance your maps with advanced features like legends, colorbars, marker clusters, and split maps for comparison.

## Objective

* Create and customize interactive maps using Leafmap.
* Add and configure basemaps, XYZ tile layers, and WMS layers.
* Visualize various raster formats such as GeoTIFF, Cloud Optimized GeoTIFF (COG), and multi-band imagery.
* Explore vector data visualization, including marker clusters and choropleth maps.
* Implement advanced mapping features like legends, colorbars, and split map comparisons.

+++

## Exercise 1: Creating an Interactive Map

1. Create an interactive map with search functionality that allows users to search for places and zoom to them. Disable the draw control on the map.

```{code-cell} ipython3

```

![image](https://github.com/user-attachments/assets/b930fb63-3bd1-4d7e-9bf8-87e6d398e5c3)

+++

## Exercise 2: Adding XYZ and WMS Tile Layers

1. Add a custom XYZ tile layer ([USGS Topographic basemap](https://apps.nationalmap.gov/services)) using the following URL:
   - URL: `https://basemap.nationalmap.gov/arcgis/rest/services/USGSTopo/MapServer/tile/{z}/{y}/{x}`
2. Add two WMS layers to visualize NAIP imagery and NDVI using a USGS WMS service.
   - URL: `https://imagery.nationalmap.gov/arcgis/services/USGSNAIPImagery/ImageServer/WMSServer?`
   - Layer names: `USGSNAIPImagery:FalseColorComposite`, `USGSNAIPImagery:NDVI_Color`

```{code-cell} ipython3

```

![image](https://github.com/user-attachments/assets/28dd8511-a0ac-4b44-ab02-9ed791817043)

```{code-cell} ipython3

```

![image](https://github.com/user-attachments/assets/719c1e07-f955-42d6-985c-b5842c9eac4c)

+++

## Exercise 3: Adding Map Legends

1. Add the [ESA World Cover](https://esa-worldcover.org/en) WMS tile layer to the map.
    - URL: `https://services.terrascope.be/wms/v2?`
    - Layer name: `WORLDCOVER_2021_MAP`
2. Add a legend to the map using the leafmap built-in `ESA_WorldCover` legend.

```{code-cell} ipython3

```

![image](https://github.com/user-attachments/assets/be5a9b07-4f6c-4245-9737-31db2df14f7f)

+++

## Exercise 4: Creating Marker Clusters

1. Create a marker cluster visualization from a GeoJSON file of building centroids:
    - URL: https://github.com/opengeos/datasets/releases/download/places/wa_building_centroids.geojson
    - Hint: Read the GeoJSON file using GeoPandas and add "latitude" and "longitude" columns to the GeoDataFrame.
2. Create circle markers for each building centroid using the `Map.add_circle_markers_from_xy()` method with the following styling:
    * Radius: 5
    * Outline color: "red"
    * Fill color: "yellow"
    * Fill opacity: 0.8

```{code-cell} ipython3

```

![image](https://github.com/user-attachments/assets/d60cbfc7-b8c9-4cab-8852-bc34e82fd665)

```{code-cell} ipython3

```

![image](https://github.com/user-attachments/assets/637e00ae-89af-495e-84b4-e668e16cce88)

+++

## Exercise 5: Visualizing Vector Data

1. Visualize the building polygons GeoJSON file and style it with:
    * Outline color: "red"
    * No fill color
    * URL: https://github.com/opengeos/datasets/releases/download/places/wa_overture_buildings.geojson

2. Visualize the road polylines GeoJSON file and style it with:
    * Line color: "red"
    * Line width: 2
    * URL: https://github.com/opengeos/datasets/releases/download/places/las_vegas_roads.geojson

3. Create a choropleth map of county areas in the US:
    * URL: https://github.com/opengeos/datasets/releases/download/us/us_counties.geojson
    * Column: `CENSUSAREA`

```{code-cell} ipython3

```

![image](https://github.com/user-attachments/assets/069eb704-c409-44ee-af9e-7582d1ab23a5)

```{code-cell} ipython3

```

![image](https://github.com/user-attachments/assets/f28d19a6-4f60-484c-b2f7-c1ecce7ecb26)

```{code-cell} ipython3

```

![image](https://github.com/user-attachments/assets/3aa9f54f-64d7-4788-89f1-f3ab88c1aa2e)

+++

## Exercise 6: Visualizing GeoParquet Data

1. Visualize GeoParquet data of US states:

    - URL: https://github.com/opengeos/datasets/releases/download/us/us_states.parquet
    - Style: Outline color of "red" with no fill.

```{code-cell} ipython3

```

![image](https://github.com/user-attachments/assets/b6d9ec09-035b-4df7-8ab7-a7b4588f1e71)

+++

## Exercise 7: Visualizing PMTiles

1. Visualize the Overture Maps building dataset using PMTiles:
    * URL: https://overturemaps-tiles-us-west-2-beta.s3.amazonaws.com/2024-09-18/buildings.pmtiles
    * Style: Blue fill with 0.4 opacity, red outline.

```{code-cell} ipython3

```

![image](https://github.com/user-attachments/assets/4ee08461-c962-4c37-8979-7105f588842a)

+++

## Exercise 8: Visualizing Cloud Optimized GeoTIFFs (COGs)

1. Visualize Digital Elevation Model (DEM) data using the following COG file:
    - URL: https://github.com/opengeos/datasets/releases/download/raster/dem.tif
    - Apply a terrain colormap to show elevation values.

```{code-cell} ipython3

```

![image](https://github.com/user-attachments/assets/21e1f7dd-466e-4880-94a5-0365bf1495dc)

+++

## Exercise 9: Visualizing Local Raster Data

1. Visualize the following raster datasets using the Map.add_raster() method:

    * Aerial Imagery: https://github.com/opengeos/datasets/releases/download/places/wa_building_image.tif
    * Building Footprints: https://github.com/opengeos/datasets/releases/download/places/wa_building_masks.tif (use the "tab20" colormap and opacity of 0.7)

```{code-cell} ipython3

```

![image](https://github.com/user-attachments/assets/faf7c345-6a3f-4ca0-8eca-7417e6568867)

+++

## Exercise 10: Creating a Split Map

1. Create a split map to compare imagery of Libya before and after the 2023 flood event:

    * Pre-event imagery: https://github.com/opengeos/datasets/releases/download/raster/Libya-2023-07-01.tif
    * Post-event imagery: https://github.com/opengeos/datasets/releases/download/raster/Libya-2023-09-13.tif

```{code-cell} ipython3

```

![image](https://github.com/user-attachments/assets/8cab4f1c-2dba-4652-a644-3ce6be4bbbd2)
