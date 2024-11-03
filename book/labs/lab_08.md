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

# Lab 8

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/labs/lab_08.ipynb)


## Overview

This lab introduces you to MapLibre, an open-source library for creating highly customizable, interactive 2D and 3D maps in Python. You will gain practical experience using MapLibre in conjunction with the Leafmap library to develop dynamic geospatial visualizations. This lab covers fundamental tasks, such as setting up MapLibre, creating a map, and customizing views, as well as more advanced functionalities, such as overlaying data layers, adding 3D buildings, and adding map elements.

---

## Objectives

By completing this lab, you will be able to:

1. Set up MapLibre in Python and initialize a basic map.
2. Customize map properties, including basemap styles, zoom levels, pitch, and bearing.
3. Add interactive controls, such as geolocation, fullscreen, and drawing tools, to enhance user experience.
4. Integrate various data layers, such as GeoJSON, XYZ tiles, and WMS layers, to enrich map content.
5. Work with 3D visualizations, including extruded buildings, for enhanced spatial representation.
6. Add map elements, such as image, text, and GIF, to the map.

```{code-cell} ipython3
# %pip install "leafmap[maplibre]"
```

## Exercise 1: Setting up MapLibre and Basic Map Creation

   - Initialize a map centered on a country of your choice with an appropriate zoom level and display it with the `dark-matter` basemap.
   - Change the basemap style to `liberty` and display it again.


```{code-cell} ipython3

```

## Exercise 2: Customizing the Map View

   - Create a 3D map of a city of your choice with an appropriate zoom level, pitch and bearing using the `liberty` basemap.
   - Experiment with MapTiler 3D basemap styles, such as `3d-satellite`, `3d-hybrid`, and `3d-topo`, to visualize a location of your choice in different ways. Please set your MapTiler API key as Colab secret and do NOT expose the API key in the notebook.

```{code-cell} ipython3

```


## Exercise 3: Adding Map Controls

   - Create a map centered on a city of your choice and add the following controls to the map:
     - **Geolocate** control positioned at the top left.
     - **Fullscreen** control at the top right.
     - **Draw** control for adding points, lines, and polygons, positioned at the top left.

```{code-cell} ipython3

```

## Exercise 4: Overlaying Data Layers

   - **GeoJSON Layer**: Create a map and add the following GeoJSON data layers to the map with appropriate styles:
     - NYC buildings: https://github.com/opengeos/datasets/releases/download/places/nyc_buildings.geojson
     - NYC roads: https://github.com/opengeos/datasets/releases/download/places/nyc_roads.geojson
   - **Thematic Raster Layer**: Create a map with a satellite basemap and add the following raster data layer to the map with an appropriate legend:
     - National Land Cover Database (NLCD) 2021: https://github.com/opengeos/datasets/releases/download/raster/nlcd_2021_land_cover_90m.tif
   - **DEM Layer:** Create a map with a satellite basemap and add the following DEM layer to the map with an appropriate color bar:
     - DEM: https://github.com/opengeos/datasets/releases/download/raster/dem.tif
   - **WMS Layer**: Create a map and add the ESA WorldCover WMS layer to the map with an appropriate legend:
     - url: https://services.terrascope.be/wms/v2
     - layers: WORLDCOVER_2021_MAP

```{code-cell} ipython3

```

## Exercise 5: Working with 3D Buildings

   - Set up a 3D map centered on a city of your choice with an appropriate zoom level, pitch, and bearing.
   - Add 3D buildings to the map with extrusions based on their height attributes. Use a custom color gradient for the extrusion color.

```{code-cell} ipython3

```

## Exercise 6: Adding Map Elements
   - **Image and Text**: Add a logo image of your choice with appropriate text to the map.
   - **GIF**: Add an animated GIF of your choice to the map.

```{code-cell} ipython3

```
