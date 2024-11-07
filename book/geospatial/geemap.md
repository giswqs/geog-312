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

# Geemap

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/geospatial/geemap.ipynb)

## Overview

This lecture introduces cloud-based geospatial analysis using the [Google Earth Engine](https://earthengine.google.com) (GEE) API in combination with the [geemap](https://geemap.org) Python package. We will cover core concepts of Earth Engine, visualization techniques, and practical workflows to perform analyses within a Jupyter environment.

## Learning Objectives

By the end of this lecture, you will be able to:
* Explain the fundamentals of the Google Earth Engine platform, including its data types and cloud-based capabilities
* Set up and configure the geemap library for conducting geospatial analyses in the cloud
* Perform essential geospatial operations, including filtering, visualizing, and exporting data from Earth Engine
* Access and manipulate both raster and vector data using Earth Engine
* Create timelapse animations from satellite imagery
* Create interactive charts from Earth Engine data

### Prerequisites

Before beginning with geemap and Google Earth Engine, ensure the following steps are completed:

- **Register for a Google Earth Engine account**: Go to [https://code.earthengine.google.com/register](https://code.earthengine.google.com/register) to sign up for a GEE account. After registering, you will need to set up a Google Cloud Project and enable the Earth Engine API by following the instructions [here](https://docs.google.com/document/d/1ZGSmrNm6_baqd8CHt33kIBWOlvkh-HLr46bODgJN1h0/edit?usp=sharing). GEE is free for [noncommercial and research use](https://earthengine.google.com/noncommercial).

- **Verify API Authentication**: To confirm that your Earth Engine account is set up correctly, try running [this test notebook](https://colab.research.google.com/github/gee-community/geemap/blob/master/docs/notebooks/geemap_colab.ipynb) in Google Colab.

## Introduction to Google Earth Engine

### Google Earth Engine Overview

[Google Earth Engine](https://earthengine.google.com) is a cloud-computing platform that enables scientific analysis and visualization of large-scale geospatial datasets. It provides a rich data catalog and processing capabilities, allowing users to analyze satellite imagery and geospatial data at planetary scale.

Earth Engine is free for [noncommercial and research use](https://earthengine.google.com/noncommercial). Nonprofit organizations, research institutions, educators, Indigenous governments, and government researchers can continue using Earth Engine for free, as they have for more than a decade. However, [commercial users](https://earthengine.google.com/commercial) may require a paid license.

### Installing Geemap

The geemap package simplifies the use of Google Earth Engine in Python, offering an intuitive API for visualization and analysis in Jupyter notebooks. In Google Colab, geemap is pre-installed, but you may need to install additional dependencies for certain features. To install the latest version with optional dependencies, use the following command:

```{code-cell} ipython3
# %pip install -U "geemap[workshop]"
```

### Import Libraries

To start, import the necessary libraries for working with Google Earth Engine (GEE) and geemap.

```{code-cell} ipython3
import ee
import geemap
```

### Authenticate and Initialize Earth Engine

To authenticate and initialize your Earth Engine environment, you’ll need to create a Google Cloud Project and enable the [Earth Engine API](https://console.cloud.google.com/apis/api/earthengine.googleapis.com) for the project if you have not done so already. You can find detailed setup instructions [here](https://developers.google.com/earth-engine/guides/access#a-role-in-a-cloud-project).

```{code-cell} ipython3
geemap.ee_initialize()
```

Running the code above will prompt you to authenticate your Earth Engine account. Follow the instructions to complete the authentication process on Colab. To avoid this step in the future, you can set up a Colab secret with the name `EARTHENGINE_TOKEN` and your Earth Engine token as the value, which can be obtained by running `geemap.get_ee_token()`.

```{code-cell} ipython3
# geemap.get_ee_token()
```

### Creating Interactive Maps

Let’s create an interactive map using the `ipyleaflet` plotting backend. The `geemap.Map` class inherits from the `ipyleaflet.Map` class, so the syntax is similar to creating an interactive map with `ipyleaflet.Map`.

```{code-cell} ipython3
m = geemap.Map()
```

To display the map in a Jupyter notebook, simply enter the map object:

```{code-cell} ipython3
m
```

To customize the map’s display, you can set various keyword arguments, such as `center` (latitude and longitude), `zoom`, `width`, and `height`. By default, the `width` is `100%`, filling the entire width of the Jupyter notebook cell. The `height` parameter can be a number (in pixels) or a string with a pixel format, e.g., `600px`.

#### Example Maps

**Map of the Contiguous United States**

  To center the map on the contiguous United States, use:

```{code-cell} ipython3
m = geemap.Map(center=[40, -100], zoom=4, height="600px")
m
```

**Map of the state of Tennessee**

```{code-cell} ipython3
m = geemap.Map(center=[35.746512, -86.209818], zoom=8)
m
```

**Map of the city of Knoxville, TN**

```{code-cell} ipython3
m = geemap.Map(center=[35.959111, -83.909463], zoom=13)
m
```

To hide specific map controls, set the corresponding control argument to `False`, such as `draw_ctrl=False` to hide the drawing control.

```{code-cell} ipython3
m = geemap.Map(data_ctrl=False, toolbar_ctrl=False, draw_ctrl=False)
m
```

### Adding Basemaps

There are several ways to add basemaps to a map in geemap. You can specify a basemap in the `basemap` keyword argument when creating the map, or you can add additional basemap layers using the `add_basemap` method. `Geemap` provides access to hundreds of built-in basemaps, making it easy to add layers to a map with a single line of code.

To create a map with a specific basemap, use the `basemap` argument as shown below. For example, `Esri.WorldImagery` provides an Esri world imagery basemap.

```{code-cell} ipython3
m = geemap.Map(basemap="Esri.WorldImagery")
m
```

#### Adding Multiple Basemaps

You can add multiple basemaps to a map by calling `add_basemap` multiple times. For example, the following code adds the `Esri.WorldTopoMap` and `OpenTopoMap` basemaps to the existing map:

```{code-cell} ipython3
m.add_basemap("Esri.WorldTopoMap")
```

```{code-cell} ipython3
m.add_basemap("OpenTopoMap")
```

#### Listing Available Basemaps

To view the first 10 available basemaps, use:

```{code-cell} ipython3
basemaps = list(geemap.basemaps.keys())
len(geemap.basemaps)
```

```{code-cell} ipython3
basemaps[:10]
```

### Google Basemaps

Due to licensing restrictions, Google basemaps are not included in geemap by default. However, users can add Google basemaps manually at their own discretion using the following URLs:

```text
    ROADMAP:  https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}
    SATELLITE: https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}
    TERRAIN: https://mt1.google.com/vt/lyrs=p&x={x}&y={y}&z={z}
    HYBRID: https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}
```

For example, to add Google Satellite as a tile layer:

```{code-cell} ipython3
m = geemap.Map()
url = "https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}"
m.add_tile_layer(url, name="Google Satellite", attribution="Google")
m
```

You can also add text to the map using the `add_text` method. The text will be displayed at the specified location on the map.

```{code-cell} ipython3
m.add_text(text="Hello from Earth Engine", position="bottomright")
```

## Introduction to Interactive Maps and Tools

### Basemap Selector

The basemap selector allows you to choose from various basemaps via a dropdown menu. Adding it to your map provides easy access to different map backgrounds.

```{code-cell} ipython3
m = geemap.Map()
m.add("basemap_selector")
m
```

### Layer Manager

The layer manager provides control over layer visibility and transparency. It enables toggling layers on and off and adjusting transparency with a slider, making it easy to customize map visuals.

```{code-cell} ipython3
m = geemap.Map(center=(40, -100), zoom=4)
dem = ee.Image("USGS/SRTMGL1_003")
states = ee.FeatureCollection("TIGER/2018/States")
vis_params = {
    "min": 0,
    "max": 4000,
    "palette": ["006633", "E5FFCC", "662A00", "D8D8D8", "F5F5F5"],
}
m.add_layer(dem, vis_params, "SRTM DEM")
m.add_layer(states, {}, "US States")
m.add("layer_manager")
m
```

### Inspector Tool

The inspector tool allows you to click on the map to query Earth Engine data at specific locations. This is helpful for examining the properties of datasets directly on the map.

```{code-cell} ipython3
m = geemap.Map(center=(40, -100), zoom=4)
dem = ee.Image("USGS/SRTMGL1_003")
landsat7 = ee.Image("LANDSAT/LE7_TOA_5YEAR/1999_2003")
states = ee.FeatureCollection("TIGER/2018/States")
vis_params = {
    "min": 0,
    "max": 4000,
    "palette": ["006633", "E5FFCC", "662A00", "D8D8D8", "F5F5F5"],
}
m.add_layer(dem, vis_params, "SRTM DEM")
m.add_layer(
    landsat7,
    {"bands": ["B4", "B3", "B2"], "min": 20, "max": 200, "gamma": 2.0},
    "Landsat 7",
)
m.add_layer(states, {}, "US States")
m.add("inspector")
m
```

### Layer Editor

With the layer editor, you can adjust visualization parameters of Earth Engine data for better clarity and focus. It supports single-band images, multi-band images, and feature collections.

#### Single-Band image

```{code-cell} ipython3
m = geemap.Map(center=(40, -100), zoom=4)
dem = ee.Image("USGS/SRTMGL1_003")
vis_params = {
    "min": 0,
    "max": 4000,
    "palette": ["006633", "E5FFCC", "662A00", "D8D8D8", "F5F5F5"],
}
m.add_layer(dem, vis_params, "SRTM DEM")
m.add("layer_editor", layer_dict=m.ee_layers["SRTM DEM"])
m
```

#### Multi-Band image

```{code-cell} ipython3
m = geemap.Map(center=(40, -100), zoom=4)
landsat7 = ee.Image("LANDSAT/LE7_TOA_5YEAR/1999_2003")
m.add_layer(
    landsat7,
    {"bands": ["B4", "B3", "B2"], "min": 20, "max": 200, "gamma": 2.0},
    "Landsat 7",
)
m.add("layer_editor", layer_dict=m.ee_layers["Landsat 7"])
m
```

#### Feature Collection

```{code-cell} ipython3
m = geemap.Map(center=(40, -100), zoom=4)
states = ee.FeatureCollection("TIGER/2018/States")
m.add_layer(states, {}, "US States")
m.add("layer_editor", layer_dict=m.ee_layers["US States"])
m
```

### Draw Control

The draw control feature allows you to draw shapes directly on the map, converting them automatically into Earth Engine objects. Access the drawn features as follows:

- To return the last drawn feature as an `ee.Geometry()`, use `m.user_roi`
- To return all drawn features as an `ee.FeatureCollection()`, use `m.user_rois`

```{code-cell} ipython3
m = geemap.Map(center=(40, -100), zoom=4)
dem = ee.Image("USGS/SRTMGL1_003")
vis_params = {
    "min": 0,
    "max": 4000,
    "palette": "terrain",
}
m.add_layer(dem, vis_params, "SRTM DEM")
m.add("layer_manager")
m
```

```{code-cell} ipython3
if m.user_roi is not None:
    image = dem.clip(m.user_roi)
    m.layers[1].visible = False
    m.add_layer(image, vis_params, "Clipped DEM")
```

## The Earth Engine Data Catalog

The [Earth Engine Data Catalog](https://developers.google.com/earth-engine/datasets) hosts an extensive collection of geospatial datasets. Currently, he catalog includes over [1,000 datasets](https://github.com/opengeos/Earth-Engine-Catalog/blob/master/gee_catalog.tsv) with a combined size exceeding 100 petabytes. Notable datasets include Landsat, Sentinel, MODIS, and NAIP. For a comprehensive list of datasets in CSV or JSON format, refer to the [Earth Engine Datasets List](https://github.com/giswqs/Earth-Engine-Catalog/blob/master/gee_catalog.tsv).

### Searching Datasets on the Earth Engine Website

To browse datasets directly on the Earth Engine website:

- View the full catalog: https://developers.google.com/earth-engine/datasets/catalog
- Search by tags: https://developers.google.com/earth-engine/datasets/tags

### Searching Datasets Within Geemap

The [Earth Engine Data Catalog](https://developers.google.com/earth-engine/datasets/catalog) can also be searched directly from `geemap`. Use keywords to filter datasets by name, tag, or description. For instance, searching for "elevation" will display only datasets containing "elevation" in their metadata, returning 52 datasets. You can scroll through the results to locate the [NASA SRTM Digital Elevation 30m](https://developers.google.com/earth-engine/datasets/catalog/USGS_SRTMGL1_003#description) dataset.

```{code-cell} ipython3
m = geemap.Map()
m
```

![](https://i.imgur.com/B3rf4QN.jpg)

Each dataset page contains detailed information such as availability, provider, Earth Engine snippet, tags, description, and example code. The Image, ImageCollection, or FeatureCollection ID is essential for accessing the dataset in Earth Engine’s JavaScript or Python APIs.

### Using the Datasets Module in Geemap

Geemap offers a built-in `datasets` module to access specific datasets programmatically. For example, to access the USGS GAP Alaska dataset:

```{code-cell} ipython3
from geemap.datasets import DATA
```

```{code-cell} ipython3
m = geemap.Map()
dataset = ee.Image(DATA.USGS_GAP_AK_2001)
m.add_layer(dataset, {}, "GAP Alaska")
m.centerObject(dataset, zoom=4)
m
```

To retrieve metadata for a specific dataset, use the `get_metadata` function:

```{code-cell} ipython3
from geemap.datasets import get_metadata

get_metadata(DATA.USGS_GAP_AK_2001)
```

## Earth Engine Data Types

Earth Engine objects are server-side entities, meaning they are stored and processed on Earth Engine’s servers rather than locally. This setup is comparable to streaming services (e.g., YouTube or Netflix) where the data remains on the provider’s servers, allowing us to access and process geospatial data in real time without downloading it to our local devices.

- **Image**: The core raster data type in Earth Engine, representing single images or scenes.
- **ImageCollection**: A collection or sequence of images, often used for time series analysis.
- **Geometry**: The fundamental vector data type, including shapes like points, lines, and polygons.
- **Feature**: A Geometry with associated attributes, used to add descriptive data to vector shapes.
- **FeatureCollection**: A collection of Features, similar to a shapefile with attribute data.

## Earth Engine Raster Data

### Image

In Earth Engine, raster data is represented as **Image** objects. Each Image is composed of bands, with each band having its own name, data type, scale, mask, and projection. Metadata for each image is stored as a set of properties.

#### Loading Earth Engine Images

To load images, use the Earth Engine asset ID within the `ee.Image` constructor. Asset IDs can be found in the Earth Engine Data Catalog. For example, to load the NASA SRTM Digital Elevation dataset:

```{code-cell} ipython3
image = ee.Image("USGS/SRTMGL1_003")
image
```

#### Visualizing Earth Engine Images

To visualize an image, you can specify visualization parameters such as minimum and maximum values and color palettes.

```{code-cell} ipython3
m = geemap.Map(center=[21.79, 70.87], zoom=3)
image = ee.Image("USGS/SRTMGL1_003")
vis_params = {
    "min": 0,
    "max": 6000,
    "palette": ["006633", "E5FFCC", "662A00", "D8D8D8", "F5F5F5"],  # 'terrain'
}
m.add_layer(image, vis_params, "SRTM")
m
```

### ImageCollection

An **ImageCollection** represents a sequence of images, often used for temporal data like satellite image time series. ImageCollections are created by passing an Earth Engine asset ID into the `ImageCollection` constructor. Asset IDs are available in the [Earth Engine Data Catalog](https://developers.google.com/earth-engine/datasets).

#### Loading Image Collections

To load an ImageCollection, such as the Sentinel-2 surface reflectance collection:

```{code-cell} ipython3
collection = ee.ImageCollection("COPERNICUS/S2_SR_HARMONIZED")
```

#### Filtering Image Collections

You can filter ImageCollections by location and time. For example, to filter images covering a specific location with low cloud cover:

```{code-cell} ipython3
geometry = ee.Geometry.Point([-83.909463, 35.959111])
images = collection.filterBounds(geometry)
images.size()
```

```{code-cell} ipython3
images.first()
```

```{code-cell} ipython3
images = (
    collection.filterBounds(geometry)
    .filterDate("2024-07-01", "2024-10-01")
    .filter(ee.Filter.lt("CLOUDY_PIXEL_PERCENTAGE", 5))
)
images.size()
```

To view the filtered collection on a map:

```{code-cell} ipython3
m = geemap.Map()
image = images.first()

vis = {
    "min": 0.0,
    "max": 3000,
    "bands": ["B4", "B3", "B2"],
}

m.add_layer(image, vis, "Sentinel-2")
m.centerObject(image, 8)
m
```

#### Visualizing Image Collections

To visualize an **ImageCollection** as a single composite image, you need to aggregate the collection. For example, using the `collection.median()` method creates an image representing the median value across the collection.

```{code-cell} ipython3
m = geemap.Map()
image = images.median()

vis = {
    "min": 0.0,
    "max": 3000,
    "bands": ["B8", "B4", "B3"],
}

m.add_layer(image, vis, "Sentinel-2")
m.centerObject(geometry, 8)
m
```

## Earth Engine Vector Data

A **FeatureCollection** is a collection of Features. It functions similarly to a GeoJSON FeatureCollection, where features include associated properties or attributes. For example, a shapefile’s data can be represented as a FeatureCollection.

### Loading Feature Collections

The [Earth Engine Data Catalog](https://developers.google.com/earth-engine/datasets) includes various vector datasets, such as U.S. Census data and country boundaries, as feature collections. Feature Collection IDs are accessible by searching the data catalog. For example, to load the [TIGER roads data](https://developers.google.com/earth-engine/datasets/catalog/TIGER_2016_Roads) by the U.S. Census Bureau:

```{code-cell} ipython3
m = geemap.Map()
fc = ee.FeatureCollection("TIGER/2016/Roads")
m.set_center(-83.909463, 35.959111, 12)
m.add_layer(fc, {}, "Census roads")
m
```

### Filtering Feature Collections

The `filter` method allows you to filter a FeatureCollection based on certain attribute values. For instance, we can filter for specific states using the `eq` filter to select "Tennessee":

```{code-cell} ipython3
m = geemap.Map()
states = ee.FeatureCollection("TIGER/2018/States")
fc = states.filter(ee.Filter.eq("NAME", "Tennessee"))
m.add_layer(fc, {}, "Tennessee")
m.center_object(fc, 7)
m
```

To retrieve properties of the first feature in the collection, use:

```{code-cell} ipython3
feat = fc.first()
feat.toDictionary()
```

You can also convert a FeatureCollection to a Pandas DataFrame for easier analysis with:

```{code-cell} ipython3
geemap.ee_to_df(fc)
```

```{code-cell} ipython3
m = geemap.Map()
states = ee.FeatureCollection("TIGER/2018/States")
fc = states.filter(ee.Filter.inList("NAME", ["California", "Oregon", "Washington"]))
m.add_layer(fc, {}, "West Coast")
m.center_object(fc, 5)
m
```

```{code-cell} ipython3
region = m.user_roi
if region is None:
    region = ee.Geometry.BBox(-88.40, 29.88, -77.90, 35.39)

fc = ee.FeatureCollection("TIGER/2018/States").filterBounds(region)
m.add_layer(fc, {}, "Southeastern U.S.")
m.center_object(fc, 6)
```

A FeatureCollection can be used to clip an image. The `clipToCollection` method clips an image to the geometry of a feature collection. For example, to clip a Landsat image to the boundary of France:

```{code-cell} ipython3
m = geemap.Map(center=(40, -100), zoom=4)
landsat7 = ee.Image("LANDSAT/LE7_TOA_5YEAR/1999_2003")
countries = ee.FeatureCollection("FAO/GAUL_SIMPLIFIED_500m/2015/level0")
fc = countries.filter(ee.Filter.eq("ADM0_NAME", "Germany"))
image = landsat7.clipToCollection(fc)
m.add_layer(
    image,
    {"bands": ["B4", "B3", "B2"], "min": 20, "max": 200, "gamma": 2.0},
    "Landsat 7",
)
m.center_object(fc, 6)
m
```

### Visualizing Feature Collections

Once loaded, feature collections can be visualized on an interactive map. For example, visualizing U.S. state boundaries from the census data:

```{code-cell} ipython3
m = geemap.Map(center=[40, -100], zoom=4)
states = ee.FeatureCollection("TIGER/2018/States")
m.add_layer(states, {}, "US States")
m
```

Feature collections can also be styled with additional parameters. To apply a custom style, specify options like color and line width:

```{code-cell} ipython3
m = geemap.Map(center=[40, -100], zoom=4)
states = ee.FeatureCollection("TIGER/2018/States")
style = {"color": "0000ffff", "width": 2, "lineType": "solid", "fillColor": "FF000080"}
m.add_layer(states.style(**style), {}, "US States")
m
```

Using `add_styled_vector`, you can apply a color palette to style different features by attribute:

```{code-cell} ipython3
m = geemap.Map(center=[40, -100], zoom=4)
states = ee.FeatureCollection("TIGER/2018/States")
vis_params = {
    "color": "000000",
    "colorOpacity": 1,
    "pointSize": 3,
    "pointShape": "circle",
    "width": 2,
    "lineType": "solid",
    "fillColorOpacity": 0.66,
}
palette = ["006633", "E5FFCC", "662A00", "D8D8D8", "F5F5F5"]
m.add_styled_vector(
    states, column="NAME", palette=palette, layer_name="Styled vector", **vis_params
)
m
```

## More Tools for Visualizing Earth Engine Data

### Using the Plotting Tool

The plotting tool in geemap enables visualization of Earth Engine data layers. In this example, Landsat 7 and Hyperion data are added with specific visualization parameters, allowing for comparison of these datasets. The plot GUI is then added to facilitate detailed exploration of the data.

```{code-cell} ipython3
m = geemap.Map(center=[40, -100], zoom=4)

landsat7 = ee.Image("LANDSAT/LE7_TOA_5YEAR/1999_2003").select(
    ["B1", "B2", "B3", "B4", "B5", "B7"]
)

landsat_vis = {"bands": ["B4", "B3", "B2"], "gamma": 1.4}
m.add_layer(landsat7, landsat_vis, "Landsat")

hyperion = ee.ImageCollection("EO1/HYPERION").filter(
    ee.Filter.date("2016-01-01", "2017-03-01")
)

hyperion_vis = {
    "min": 1000.0,
    "max": 14000.0,
    "gamma": 2.5,
}
m.add_layer(hyperion, hyperion_vis, "Hyperion")
m.add_plot_gui()
m
```

Set the plotting options for Landsat to add marker clusters and overlays, enhancing the interactivity of plotted data on the map.

```{code-cell} ipython3
m.set_plot_options(add_marker_cluster=True, overlay=True)
```

Adjust the plotting options for Hyperion data by setting a bar plot type with marker clusters, suitable for visualizing Hyperion’s data values in bar format.

```{code-cell} ipython3
m.set_plot_options(add_marker_cluster=True, plot_type="bar")
```

### Legends

#### Built-in Legends

Geemap provides built-in legends that can be easily added to maps for better interpretability of data classes. Here, an NLCD legend is added to both a WMS layer and an Earth Engine land cover layer, giving quick visual reference to the data's classification scheme.

```{code-cell} ipython3
from geemap.legends import builtin_legends
```

Print out all available built-in legends, which can be used with various data layers to enhance map readability.

```{code-cell} ipython3
for legend in builtin_legends:
    print(legend)
```

Add an NLCD WMS layer along with its corresponding legend, which appears as an overlay, providing users with an informative legend display.

```{code-cell} ipython3
m = geemap.Map(center=[40, -100], zoom=4)
m.add_basemap("Esri.WorldImagery")
m.add_basemap("NLCD 2021 CONUS Land Cover")
m.add_legend(builtin_legend="NLCD", max_width="100px", height="455px")
m
```

Add an Earth Engine layer for NLCD land cover and display its legend, specifying title, legend type, and dimensions for user convenience.

```{code-cell} ipython3
m = geemap.Map(center=[40, -100], zoom=4)
m.add_basemap("Esri.WorldImagery")

nlcd = ee.Image("USGS/NLCD_RELEASES/2021_REL/NLCD/2021")
landcover = nlcd.select("landcover")

m.add_layer(landcover, {}, "NLCD Land Cover 2021")
m.add_legend(
    title="NLCD Land Cover Classification", builtin_legend="NLCD", height="455px"
)
m
```

#### Custom Legends

Create a custom legend by defining unique labels and colors for each class, allowing for flexible map customization. This example uses a color palette for labeling several map categories.

```{code-cell} ipython3
m = geemap.Map(add_google_map=False)

keys = ["One", "Two", "Three", "Four", "etc"]

# colors can be defined using either hex code or RGB (0-255, 0-255, 0-255)
colors = ["#8DD3C7", "#FFFFB3", "#BEBADA", "#FB8072", "#80B1D3"]
# legend_colors = [(255, 0, 0), (127, 255, 0), (127, 18, 25), (36, 70, 180), (96, 68 123)]

m.add_legend(keys=keys, colors=colors, position="bottomright")
m
```

Define a custom legend using a dictionary that links specific colors to labels. This approach provides flexibility to represent specific categories in the data, such as various land cover types.

```{code-cell} ipython3
m = geemap.Map(center=[40, -100], zoom=4)
m.add_basemap("Esri.WorldImagery")

legend_dict = {
    "11 Open Water": "466b9f",
    "12 Perennial Ice/Snow": "d1def8",
    "21 Developed, Open Space": "dec5c5",
    "22 Developed, Low Intensity": "d99282",
    "23 Developed, Medium Intensity": "eb0000",
    "24 Developed High Intensity": "ab0000",
    "31 Barren Land (Rock/Sand/Clay)": "b3ac9f",
    "41 Deciduous Forest": "68ab5f",
    "42 Evergreen Forest": "1c5f2c",
    "43 Mixed Forest": "b5c58f",
    "51 Dwarf Scrub": "af963c",
    "52 Shrub/Scrub": "ccb879",
    "71 Grassland/Herbaceous": "dfdfc2",
    "72 Sedge/Herbaceous": "d1d182",
    "73 Lichens": "a3cc51",
    "74 Moss": "82ba9e",
    "81 Pasture/Hay": "dcd939",
    "82 Cultivated Crops": "ab6c28",
    "90 Woody Wetlands": "b8d9eb",
    "95 Emergent Herbaceous Wetlands": "6c9fb8",
}

nlcd = ee.Image("USGS/NLCD_RELEASES/2021_REL/NLCD/2021")
landcover = nlcd.select("landcover")

m.add_layer(landcover, {}, "NLCD Land Cover 2021")
m.add_legend(title="NLCD Land Cover Classification", legend_dict=legend_dict)
m
```

### Color Bars

Add a horizontal color bar representing elevation data. This example demonstrates how to add an SRTM elevation layer and overlay a color bar for quick visual reference of elevation values.

```{code-cell} ipython3
m = geemap.Map()

dem = ee.Image("USGS/SRTMGL1_003")
vis_params = {
    "min": 0,
    "max": 4000,
    "palette": ["006633", "E5FFCC", "662A00", "D8D8D8", "F5F5F5"],
}

m.add_layer(dem, vis_params, "SRTM DEM")
m.add_colorbar(vis_params, label="Elevation (m)", layer_name="SRTM DEM")
m
```

Add a vertical color bar for elevation data, adjusting its orientation and dimensions to fit the map layout.

```{code-cell} ipython3
m.add_colorbar(
    vis_params,
    label="Elevation (m)",
    layer_name="SRTM DEM",
    orientation="vertical",
    max_width="100px",
)
```

Make the color bar’s background transparent, which improves visual integration with the map when adding color bars for data layers.

```{code-cell} ipython3
m.add_colorbar(
    vis_params,
    label="Elevation (m)",
    layer_name="SRTM DEM",
    orientation="vertical",
    max_width="100px",
    transparent_bg=True,
)
```

### Split-panel Maps

Create a split-panel map with basemaps, allowing users to compare two different basemaps side by side.

```{code-cell} ipython3
m = geemap.Map()
m.split_map(left_layer="Esri.WorldTopoMap", right_layer="OpenTopoMap")
m
```

Use Earth Engine layers in a split-panel map to compare NLCD data from 2001 and 2021. This layout is effective for examining changes between datasets across time.

```{code-cell} ipython3
m = geemap.Map(center=(40, -100), zoom=4, height=600)

nlcd_2001 = ee.Image("USGS/NLCD_RELEASES/2019_REL/NLCD/2001").select("landcover")
nlcd_2021 = ee.Image("USGS/NLCD_RELEASES/2021_REL/NLCD/2021").select("landcover")

left_layer = geemap.ee_tile_layer(nlcd_2001, {}, "NLCD 2001")
right_layer = geemap.ee_tile_layer(nlcd_2021, {}, "NLCD 2021")

m.split_map(left_layer, right_layer)
m
```

### Linked Maps

Set up a 2x2 grid of linked maps showing Sentinel-2 imagery in different band combinations, ideal for comparing multiple visual perspectives. Note that this feature may not work in Colab.

```{code-cell} ipython3
image = (
    ee.ImageCollection("COPERNICUS/S2_SR_HARMONIZED")
    .filterDate("2024-07-01", "2024-10-01")
    .filter(ee.Filter.lt("CLOUDY_PIXEL_PERCENTAGE", 5))
    .map(lambda img: img.divide(10000))
    .median()
)

vis_params = [
    {"bands": ["B4", "B3", "B2"], "min": 0, "max": 0.3, "gamma": 1.3},
    {"bands": ["B8", "B11", "B4"], "min": 0, "max": 0.3, "gamma": 1.3},
    {"bands": ["B8", "B4", "B3"], "min": 0, "max": 0.3, "gamma": 1.3},
    {"bands": ["B12", "B12", "B4"], "min": 0, "max": 0.3, "gamma": 1.3},
]

labels = [
    "Natural Color (B4/B3/B2)",
    "Land/Water (B8/B11/B4)",
    "Color Infrared (B8/B4/B3)",
    "Vegetation (B12/B11/B4)",
]

geemap.linked_maps(
    rows=2,
    cols=2,
    height="300px",
    center=[35.959111, -83.909463],
    zoom=12,
    ee_objects=[image],
    vis_params=vis_params,
    labels=labels,
    label_position="topright",
)
```

### Timeseries Inspector

Retrieve the available years in the NLCD collection for setting up a timeseries. This step helps confirm available time points for inspecting changes over time.

```{code-cell} ipython3
m = geemap.Map(center=[40, -100], zoom=4)
collection = ee.ImageCollection("USGS/NLCD_RELEASES/2019_REL/NLCD").select("landcover")
vis_params = {"bands": ["landcover"]}
years = collection.aggregate_array("system:index").getInfo()
years
```

Use a timeseries inspector to compare changes in NLCD data across different years. This tool is ideal for temporal data visualization, showing how land cover changes in an interactive format.

```{code-cell} ipython3
m.ts_inspector(
    left_ts=collection,
    right_ts=collection,
    left_names=years,
    right_names=years,
    left_vis=vis_params,
    right_vis=vis_params,
    width="80px",
)
m
```

### Time Slider

Create a time slider to explore MODIS vegetation data, setting the slider to visualize NDVI values over a specific period. This feature allows users to track vegetation changes month-by-month.

```{code-cell} ipython3
m = geemap.Map()

collection = (
    ee.ImageCollection("MODIS/MCD43A4_006_NDVI")
    .filter(ee.Filter.date("2018-06-01", "2018-07-01"))
    .select("NDVI")
)
vis_params = {
    "min": 0.0,
    "max": 1.0,
    "palette": "ndvi",
}

m.add_time_slider(collection, vis_params, time_interval=2)
m
```

Add a time slider for visualizing NOAA weather data over a 24-hour period, using color-coding to show temperature variations. The slider enables temporal exploration of hourly data.

```{code-cell} ipython3
m = geemap.Map()

collection = (
    ee.ImageCollection("NOAA/GFS0P25")
    .filterDate("2018-12-22", "2018-12-23")
    .limit(24)
    .select("temperature_2m_above_ground")
)

vis_params = {
    "min": -40.0,
    "max": 35.0,
    "palette": ["blue", "purple", "cyan", "green", "yellow", "red"],
}

labels = [str(n).zfill(2) + ":00" for n in range(0, 24)]
m.add_time_slider(collection, vis_params, labels=labels, time_interval=1, opacity=0.8)
m
```

Add a time slider to visualize Sentinel-2 imagery with specific bands and cloud cover filtering. This feature enables temporal analysis of imagery data, allowing users to explore seasonal and other changes over time.

```{code-cell} ipython3
m = geemap.Map()

collection = (
    ee.ImageCollection("COPERNICUS/S2_SR_HARMONIZED")
    .filterBounds(ee.Geometry.Point([-83.909463, 35.959111]))
    .filterMetadata("CLOUDY_PIXEL_PERCENTAGE", "less_than", 10)
    .filter(ee.Filter.calendarRange(6, 8, "month"))
)

vis_params = {"min": 0, "max": 4000, "bands": ["B8", "B4", "B3"]}

m.add_time_slider(collection, vis_params)
m.set_center(-83.909463, 35.959111, 12)
m
```

## Processing of Vector Data

### From GeoJSON

Load GeoJSON data into an Earth Engine FeatureCollection. This example retrieves countries data from a remote URL, converting it to a FeatureCollection and visualizing it with a specified style.

```{code-cell} ipython3
in_geojson = "https://github.com/gee-community/geemap/blob/master/examples/data/countries.geojson"
m = geemap.Map()
fc = geemap.geojson_to_ee(in_geojson)
m.add_layer(fc.style(**{"color": "ff0000", "fillColor": "00000000"}), {}, "Countries")
m
```

### From Shapefile

Download and load a shapefile of country boundaries. The shapefile is converted to a FeatureCollection for visualization on the map.

```{code-cell} ipython3
url = "https://github.com/gee-community/geemap/blob/master/examples/data/countries.zip"
geemap.download_file(url, overwrite=True)
```

```{code-cell} ipython3
in_shp = "countries.shp"
fc = geemap.shp_to_ee(in_shp)
```

```{code-cell} ipython3
m = geemap.Map()
m.add_layer(fc, {}, "Countries")
m
```

### From GeoDataFrame

Read a shapefile into a GeoDataFrame using geopandas, then convert the GeoDataFrame to an Earth Engine FeatureCollection for mapping.

```{code-cell} ipython3
import geopandas as gpd

gdf = gpd.read_file(in_shp)
fc = geemap.gdf_to_ee(gdf)
```

```{code-cell} ipython3
m = geemap.Map()
m.add_layer(fc, {}, "Countries")
m
```

### To GeoJSON

Filter U.S. state data to select Tennessee and save it as a GeoJSON file, which can be shared or used in other GIS tools.

```{code-cell} ipython3
m = geemap.Map()
states = ee.FeatureCollection("TIGER/2018/States")
fc = states.filter(ee.Filter.eq("NAME", "Tennessee"))
m.add_layer(fc, {}, "Tennessee")
m.center_object(fc, 7)
m
```

```{code-cell} ipython3
geemap.ee_to_geojson(fc, filename="Tennessee.geojson")
```

### To Shapefile

Export the filtered Tennessee FeatureCollection to a shapefile format for offline use or compatibility with desktop GIS software.

```{code-cell} ipython3
geemap.ee_to_shp(fc, filename="Tennessee.shp")
```

### To GeoDataFrame

Convert an Earth Engine FeatureCollection to a GeoDataFrame for further analysis in Python or use in interactive maps.

```{code-cell} ipython3
gdf = geemap.ee_to_gdf(fc)
gdf
```

```{code-cell} ipython3
gdf.explore()
```

### To DataFrame

Transform an Earth Engine FeatureCollection into a pandas DataFrame, which can then be used for data analysis in Python.

```{code-cell} ipython3
df = geemap.ee_to_df(fc)
df
```

### To CSV

Export the FeatureCollection data to a CSV file, useful for spreadsheet applications and data reporting.

```{code-cell} ipython3
geemap.ee_to_csv(fc, filename="Indiana.csv")
```

## Processing of Raster Data

### Extract Pixel Values

#### Extracting Values to Points

Load and visualize SRTM DEM and Landsat 7 imagery. Points from a shapefile of U.S. cities are added, and the tool extracts DEM values to these points, saving the results in a shapefile.

```{code-cell} ipython3
m = geemap.Map(center=[40, -100], zoom=4)

dem = ee.Image("USGS/SRTMGL1_003")
landsat7 = ee.Image("LANDSAT/LE7_TOA_5YEAR/1999_2003")

vis_params = {
    "min": 0,
    "max": 4000,
    "palette": ["006633", "E5FFCC", "662A00", "D8D8D8", "F5F5F5"],
}

m.add_layer(
    landsat7,
    {"bands": ["B4", "B3", "B2"], "min": 20, "max": 200, "gamma": 2},
    "Landsat 7",
)
m.add_layer(dem, vis_params, "SRTM DEM", True, 1)
m
```

```{code-cell} ipython3
in_shp = "us_cities.shp"
url = "https://github.com/giswqs/data/raw/main/us/us_cities.zip"
geemap.download_file(url)
```

```{code-cell} ipython3
in_fc = geemap.shp_to_ee(in_shp)
m.add_layer(in_fc, {}, "Cities")
```

```{code-cell} ipython3
geemap.extract_values_to_points(in_fc, dem, out_fc="dem.shp")
```

```{code-cell} ipython3
geemap.shp_to_gdf("dem.shp")
```

```{code-cell} ipython3
geemap.extract_values_to_points(in_fc, landsat7, "landsat.csv")
```

```{code-cell} ipython3
geemap.csv_to_df("landsat.csv")
```

#### Extracting Pixel Values Along a Transect

Visualize SRTM DEM with a terrain basemap. Define a line transect, either interactively or manually, and extract elevation values along this line. Display the elevation profile in a line chart, then export it as a CSV file for further analysis.

```{code-cell} ipython3
m = geemap.Map(center=[40, -100], zoom=4)
m.add_basemap("TERRAIN")

image = ee.Image("USGS/SRTMGL1_003")
vis_params = {
    "min": 0,
    "max": 4000,
    "palette": ["006633", "E5FFCC", "662A00", "D8D8D8", "F5F5F5"],
}
m.add_layer(image, vis_params, "SRTM DEM", True, 0.5)
m
```

```{code-cell} ipython3
line = m.user_roi
if line is None:
    line = ee.Geometry.LineString(
        [[-120.2232, 36.3148], [-118.9269, 36.7121], [-117.2022, 36.7562]]
    )
    m.add_layer(line, {}, "ROI")
m.centerObject(line)
```

```{code-cell} ipython3
reducer = "mean"
transect = geemap.extract_transect(
    image, line, n_segments=100, reducer=reducer, to_pandas=True
)
transect
```

```{code-cell} ipython3
geemap.line_chart(
    data=transect,
    x="distance",
    y="mean",
    markers=True,
    x_label="Distance (m)",
    y_label="Elevation (m)",
    height=400,
)
```

```{code-cell} ipython3
transect.to_csv("transect.csv")
```

### Zonal Statistics

#### Zonal Statistics with an Image and a Feature Collection

This section demonstrates the use of zonal statistics to calculate the mean elevation values within U.S. state boundaries using NASA’s SRTM DEM data and a 5-year Landsat composite. The `geemap.zonal_stats` function exports results to CSV files for analysis.

```{code-cell} ipython3
m = geemap.Map(center=[40, -100], zoom=4)

# Add NASA SRTM
dem = ee.Image("USGS/SRTMGL1_003")
dem_vis = {
    "min": 0,
    "max": 4000,
    "palette": ["006633", "E5FFCC", "662A00", "D8D8D8", "F5F5F5"],
}
m.add_layer(dem, dem_vis, "SRTM DEM")

# Add 5-year Landsat TOA composite
landsat = ee.Image("LANDSAT/LE7_TOA_5YEAR/1999_2003")
landsat_vis = {"bands": ["B4", "B3", "B2"], "gamma": 1.4}
m.add_layer(landsat, landsat_vis, "Landsat", False)

# Add US Census States
states = ee.FeatureCollection("TIGER/2018/States")
style = {"fillColor": "00000000"}
m.add_layer(states.style(**style), {}, "US States")
m
```

```{code-cell} ipython3
out_dem_stats = "dem_stats.csv"
geemap.zonal_stats(
    dem, states, out_dem_stats, statistics_type="MEAN", scale=1000, return_fc=False
)
```

```{code-cell} ipython3
out_landsat_stats = "landsat_stats.csv"
geemap.zonal_stats(
    landsat,
    states,
    out_landsat_stats,
    statistics_type="MEAN",
    scale=1000,
    return_fc=False,
)
```

#### Zonal Statistics by Group

Here, zonal statistics are applied to NLCD land cover data, calculating the area of each land cover type within each U.S. state. The results are saved to CSV files as both raw totals and percentages. This provides insights into the spatial distribution of land cover categories across states.

```{code-cell} ipython3
m = geemap.Map(center=[40, -100], zoom=4)

# Add NLCD data
dataset = ee.Image("USGS/NLCD_RELEASES/2019_REL/NLCD/2019")
landcover = dataset.select("landcover")
m.add_layer(landcover, {}, "NLCD 2019")

# Add US census states
states = ee.FeatureCollection("TIGER/2018/States")
style = {"fillColor": "00000000"}
m.add_layer(states.style(**style), {}, "US States")

# Add NLCD legend
m.add_legend(title="NLCD Land Cover", builtin_legend="NLCD")
m
```

```{code-cell} ipython3
nlcd_stats = "nlcd_stats.csv"

geemap.zonal_stats_by_group(
    landcover,
    states,
    nlcd_stats,
    statistics_type="SUM",
    denominator=1e6,
    decimal_places=2,
)
```

```{code-cell} ipython3
nlcd_stats = "nlcd_stats_pct.csv"

geemap.zonal_stats_by_group(
    landcover,
    states,
    nlcd_stats,
    statistics_type="PERCENTAGE",
    denominator=1e6,
    decimal_places=2,
)
```

#### Zonal Statistics with Two Images

This example calculates the mean elevation values within different NLCD land cover types using DEM and NLCD data. The `geemap.image_stats_by_zone` function provides summary statistics (e.g., mean and standard deviation), which can be exported to CSV files for further analysis or visualization.

```{code-cell} ipython3
m = geemap.Map(center=[40, -100], zoom=4)
dem = ee.Image("USGS/3DEP/10m")
vis = {"min": 0, "max": 4000, "palette": "terrain"}
m.add_layer(dem, vis, "DEM")
m
```

```{code-cell} ipython3
landcover = ee.Image("USGS/NLCD_RELEASES/2019_REL/NLCD/2019").select("landcover")
m.add_layer(landcover, {}, "NLCD 2019")
m.add_legend(title="NLCD Land Cover Classification", builtin_legend="NLCD")
```

```{code-cell} ipython3
stats = geemap.image_stats_by_zone(dem, landcover, reducer="MEAN")
stats
```

```{code-cell} ipython3
stats.to_csv("mean.csv", index=False)
```

```{code-cell} ipython3
geemap.image_stats_by_zone(dem, landcover, out_csv="std.csv", reducer="STD")
```

### Map Algebra

This example demonstrates basic map algebra by computing the Normalized Difference Vegetation Index (NDVI) for a 5-year Landsat composite and the Enhanced Vegetation Index (EVI) for a Landsat 8 image. These indices are visualized with color scales to highlight areas of vegetation.

```{code-cell} ipython3
m = geemap.Map()

# Load a 5-year Landsat 7 composite 1999-2003.
landsat_1999 = ee.Image("LANDSAT/LE7_TOA_5YEAR/1999_2003")

# Compute NDVI.
ndvi_1999 = (
    landsat_1999.select("B4")
    .subtract(landsat_1999.select("B3"))
    .divide(landsat_1999.select("B4").add(landsat_1999.select("B3")))
)

vis = {"min": 0, "max": 1, "palette": "ndvi"}
m.add_layer(ndvi_1999, vis, "NDVI")
m.add_colorbar(vis, label="NDVI")
m
```

```{code-cell} ipython3
# Load a Landsat 8 image.
image = ee.Image("LANDSAT/LC08/C02/T1_TOA/LC08_044034_20140318")

# Compute the EVI using an expression.
evi = image.expression(
    "2.5 * ((NIR - RED) / (NIR + 6 * RED - 7.5 * BLUE + 1))",
    {
        "NIR": image.select("B5"),
        "RED": image.select("B4"),
        "BLUE": image.select("B2"),
    },
)

# Define a map centered on San Francisco Bay.
m = geemap.Map(center=[37.4675, -122.1363], zoom=9)

vis = {"min": 0, "max": 1, "palette": "ndvi"}
m.add_layer(evi, vis, "EVI")
m.add_colorbar(vis, label="EVI")
m
```

## Working with Local Geospatial Data

### Raster Data

Single-band and multi-band raster data can be loaded from local files. Here, a digital elevation model (DEM) is loaded and displayed with a terrain color scheme, and another raster is displayed with a false-color composite to highlight different features.

#### Single-Band Raster Data

```{code-cell} ipython3
url = "https://github.com/giswqs/data/raw/main/raster/srtm90.tif"
filename = "dem.tif"
geemap.download_file(url, filename)
```

#### Multi-Band Raster Data

```{code-cell} ipython3
m = geemap.Map()
m.add_raster(filename, cmap="terrain", layer_name="DEM")
vis_params = {"min": 0, "max": 4000, "palette": "terrain"}
m.add_colorbar(vis_params, label="Elevation (m)")
m
```

```{code-cell} ipython3
url = "https://github.com/giswqs/data/raw/main/raster/cog.tif"
filename = "cog.tif"
geemap.download_file(url, filename)
```

```{code-cell} ipython3
m = geemap.Map()
m.add_raster(filename, indexes=[4, 1, 2], layer_name="False color")
m
```

### Vector Data

Various vector data formats can be loaded and visualized with geemap, including GeoJSON, Shapefile, GeoDataFrame, and GeoPackage formats. GeoJSON data is styled dynamically with custom colors based on attributes, while Shapefiles and GeoDataFrames allow for simple, structured addition of geographic features to the map.

#### GeoJSON

```{code-cell} ipython3
in_geojson = (
    "https://github.com/opengeos/datasets/releases/download/vector/cables.geojson"
)
m = geemap.Map()
m.add_geojson(in_geojson, layer_name="Cable lines", info_mode="on_hover")
m
```

```{code-cell} ipython3
m = geemap.Map()
m.add_basemap("CartoDB.DarkMatter")
callback = lambda feat: {"color": feat["properties"]["color"], "weight": 2}
m.add_geojson(in_geojson, layer_name="Cable lines", style_callback=callback)
m
```

```{code-cell} ipython3
url = "https://github.com/opengeos/datasets/releases/download/world/countries.geojson"
m = geemap.Map()
m.add_geojson(
    url, layer_name="Countries", fill_colors=["red", "yellow", "green", "orange"]
)
m
```

```{code-cell} ipython3
import random

m = geemap.Map()


def random_color(feature):
    return {
        "color": "black",
        "weight": 3,
        "fillColor": random.choice(["red", "yellow", "green", "orange"]),
    }


m.add_geojson(url, layer_name="Countries", style_callback=random_color)
m
```

```{code-cell} ipython3
m = geemap.Map()

style = {
    "stroke": True,
    "color": "#0000ff",
    "weight": 2,
    "opacity": 1,
    "fill": True,
    "fillColor": "#0000ff",
    "fillOpacity": 0.1,
}

hover_style = {"fillOpacity": 0.7}

m.add_geojson(url, layer_name="Countries", style=style, hover_style=hover_style)
m
```

#### Shapefile

```{code-cell} ipython3
url = "https://github.com/opengeos/datasets/releases/download/world/countries.zip"
geemap.download_file(url, overwrite=True)
```

```{code-cell} ipython3
m = geemap.Map()
in_shp = "countries.shp"
m.add_shp(in_shp, layer_name="Countries")
m
```

#### GeoDataFrame

```{code-cell} ipython3
import geopandas as gpd

m = geemap.Map(center=[40, -100], zoom=4)
gdf = gpd.read_file("countries.shp")
m.add_gdf(gdf, layer_name="Countries")
m
```

#### GeoPackage

```{code-cell} ipython3
m = geemap.Map()
data = "https://github.com/opengeos/datasets/releases/download/world/countries.gpkg"
m.add_vector(data, layer_name="Countries")
m
```

#### CSV to Vector

Geemap enables easy conversion from CSV files to vector data formats like GeoJSON, Shapefile, and GeoPackage. The data from a CSV is visualized on a map, where cities are displayed with markers styled by region, and a legend is added for clear reference.

```{code-cell} ipython3
data = "https://github.com/gee-community/geemap/blob/master/examples/data/us_cities.csv"
geemap.csv_to_df(data)
```

```{code-cell} ipython3
geemap.csv_to_geojson(
    data, "cities.geojson", latitude="latitude", longitude="longitude"
)
```

```{code-cell} ipython3
geemap.csv_to_shp(data, "cities.shp", latitude="latitude", longitude="longitude")
```

```{code-cell} ipython3
geemap.csv_to_vector(data, "cities.gpkg", latitude="latitude", longitude="longitude")
```

```{code-cell} ipython3
gdf = geemap.csv_to_gdf(data, latitude="latitude", longitude="longitude")
gdf
```

```{code-cell} ipython3
cities = (
    "https://github.com/gee-community/geemap/blob/master/examples/data/us_cities.csv"
)
m = geemap.Map(center=[40, -100], zoom=4)
m.add_points_from_xy(cities, x="longitude", y="latitude")
m
```

```{code-cell} ipython3
regions = "https://github.com/gee-community/geemap/blob/master/examples/data/us_regions.geojson"
```

```{code-cell} ipython3
m = geemap.Map(center=[40, -100], zoom=4)
m.add_geojson(regions, layer_name="US Regions")
m.add_points_from_xy(
    cities,
    x="longitude",
    y="latitude",
    layer_name="US Cities",
    color_column="region",
    icon_names=["gear", "map", "leaf", "globe"],
    spin=True,
    add_legend=True,
)
m
```

```{code-cell} ipython3
m = geemap.Map(center=[40, -100], zoom=4)
m.add_circle_markers_from_xy(
    data,
    x="longitude",
    y="latitude",
    radius=8,
    color="blue",
    fill_color="black",
    fill_opacity=0.5,
)
m
```

## Accessing Cloud Optimized GeoTIFFs

### Cloud Optimized GeoTIFFs (COG)

This section shows how to add Cloud Optimized GeoTIFF (COG) layers to a map using URLs, which allows for efficient loading and visualization of large raster files stored on the cloud. In this example, a pre-event image of the 2020 California wildfire is added to a map, allowing for remote sensing analysis without local file storage.

```{code-cell} ipython3
m = geemap.Map()
url = "https://opendata.digitalglobe.com/events/california-fire-2020/pre-event/2018-02-16/pine-gulch-fire20/1030010076004E00.tif"
m.add_cog_layer(url, name="Fire (pre-event)")
m
```

```{code-cell} ipython3
geemap.cog_center(url)
```

The COG functions also allow inspection of data, such as viewing the bounds and available bands in the GeoTIFF file. The pre- and post-event images can be compared in a split map view to analyze changes due to the fire.

```{code-cell} ipython3
geemap.cog_bands(url)
```

```{code-cell} ipython3
url2 = "https://opendata.digitalglobe.com/events/california-fire-2020/post-event/2020-08-14/pine-gulch-fire20/10300100AAC8DD00.tif"
m.add_cog_layer(url2, name="Fire (post-event)")
```

```{code-cell} ipython3
m = geemap.Map(center=[39.4568, -108.5107], zoom=12)
m.split_map(left_layer=url2, right_layer=url)
m
```

### SpatioTemporal Asset Catalog (STAC)

STAC collections can be accessed and visualized similarly, enabling dynamic mapping of spatiotemporal data. By specifying STAC URLs, you can view dataset bounds, center the map on a dataset, and select specific bands to add as layers. This example shows adding panchromatic and false-color imagery for enhanced visual analysis.

```{code-cell} ipython3
url = "https://tinyurl.com/22vptbws"
```

```{code-cell} ipython3
geemap.stac_bounds(url)
```

```{code-cell} ipython3
geemap.stac_center(url)
```

```{code-cell} ipython3
geemap.stac_bands(url)
```

```{code-cell} ipython3
m = geemap.Map()
m.add_stac_layer(url, bands=["pan"], name="Panchromatic")
m.add_stac_layer(url, bands=["B3", "B2", "B1"], name="False color")
m
```

## Exporting Earth Engine Data

### Exporting Images

This section demonstrates exporting Earth Engine images. First, a Landsat image is added to the map for visualization, and a rectangular region of interest (ROI) is specified. Exporting options include saving the image locally with specified scale and region or exporting to Google Drive. It’s possible to define custom CRS and transformation settings when saving the image.


Add a Landsat image to the map.

```{code-cell} ipython3
m = geemap.Map()

image = ee.Image("LANDSAT/LC08/C02/T1_TOA/LC08_044034_20140318").select(
    ["B5", "B4", "B3"]
)

vis_params = {"min": 0, "max": 0.5, "gamma": [0.95, 1.1, 1]}

m.center_object(image)
m.add_layer(image, vis_params, "Landsat")
m
```

Add a rectangle to the map.

```{code-cell} ipython3
region = ee.Geometry.BBox(-122.5955, 37.5339, -122.0982, 37.8252)
fc = ee.FeatureCollection(region)
style = {"color": "ffff00ff", "fillColor": "00000000"}
m.add_layer(fc.style(**style), {}, "ROI")
```

To local drive

```{code-cell} ipython3
geemap.ee_export_image(image, filename="landsat.tif", scale=30, region=region)
```

Check image projection.

```{code-cell} ipython3
projection = image.select(0).projection().getInfo()
projection
```

```{code-cell} ipython3
crs = projection["crs"]
crs_transform = projection["transform"]
```

Specify region, crs, and crs_transform.

```{code-cell} ipython3
geemap.ee_export_image(
    image,
    filename="landsat_crs.tif",
    crs=crs,
    crs_transform=crs_transform,
    region=region,
)
```

To Google Drive

```{code-cell} ipython3
geemap.ee_export_image_to_drive(
    image, description="landsat", folder="export", region=region, scale=30
)
```

```{code-cell} ipython3
geemap.download_ee_image(image, "landsat.tif", scale=90)
```

### Exporting Image Collections

Image collections, like time series data, can be filtered and exported as multiple images. Here, a National Agriculture Imagery Program (NAIP) collection is filtered by date and location. The collection can then be saved locally or sent to Google Drive, making it easier to handle large datasets.

```{code-cell} ipython3
point = ee.Geometry.Point(-99.2222, 46.7816)
collection = (
    ee.ImageCollection("USDA/NAIP/DOQQ")
    .filterBounds(point)
    .filterDate("2008-01-01", "2018-01-01")
    .filter(ee.Filter.listContains("system:band_names", "N"))
)
```

```{code-cell} ipython3
collection.aggregate_array("system:index")
```

To local drive

```{code-cell} ipython3
geemap.ee_export_image_collection(collection, out_dir=".", scale=10)
```

To Google Drive

```{code-cell} ipython3
geemap.ee_export_image_collection_to_drive(collection, folder="export", scale=10)
```

### Exporting Feature Collections

Feature collections, such as state boundaries, are exportable in multiple formats (e.g., Shapefile, GeoJSON, and CSV). This example exports the Alaska state boundary as different vector formats both locally and to Google Drive. Additionally, exported data can be directly loaded into a GeoDataFrame for further manipulation in Python.

```{code-cell} ipython3
m = geemap.Map()
states = ee.FeatureCollection("TIGER/2018/States")
fc = states.filter(ee.Filter.eq("NAME", "Alaska"))
m.add_layer(fc, {}, "Alaska")
m.center_object(fc, 4)
m
```

To local drive

```{code-cell} ipython3
geemap.ee_to_shp(fc, filename="Alaska.shp")
```

```{code-cell} ipython3
geemap.ee_export_vector(fc, filename="Alaska.shp")
```

```{code-cell} ipython3
geemap.ee_to_geojson(fc, filename="Alaska.geojson")
```

```{code-cell} ipython3
geemap.ee_to_csv(fc, filename="Alaska.csv")
```

```{code-cell} ipython3
gdf = geemap.ee_to_gdf(fc)
gdf
```

```{code-cell} ipython3
df = geemap.ee_to_df(fc)
df
```

To Google Drive

```{code-cell} ipython3
geemap.ee_export_vector_to_drive(
    fc, description="Alaska", fileFormat="SHP", folder="export"
)
```

## Creating Timelapse Animations

### Landsat Timelapse

The Landsat timelapse tool creates animations of changes over time. Here, we use a defined region of interest (ROI) to generate timelapse GIFs for Las Vegas (1984-2023):

```{code-cell} ipython3
m = geemap.Map()
roi = ee.Geometry.BBox(-115.5541, 35.8044, -113.9035, 36.5581)
m.add_layer(roi)
m.center_object(roi)
m
```

```{code-cell} ipython3
timelapse = geemap.landsat_timelapse(
    roi,
    out_gif="las_vegas.gif",
    start_year=1984,
    end_year=2023,
    bands=["NIR", "Red", "Green"],
    frames_per_second=5,
    title="Las Vegas, NV",
    font_color="blue",
)
geemap.show_image(timelapse)
```

```{code-cell} ipython3
m = geemap.Map()
roi = ee.Geometry.BBox(113.8252, 22.1988, 114.0851, 22.3497)
m.add_layer(roi)
m.center_object(roi)
m
```

```{code-cell} ipython3
timelapse = geemap.landsat_timelapse(
    roi,
    out_gif="hong_kong.gif",
    start_year=1990,
    end_year=2022,
    start_date="01-01",
    end_date="12-31",
    bands=["SWIR1", "NIR", "Red"],
    frames_per_second=3,
    title="Hong Kong",
)
geemap.show_image(timelapse)
```

### Sentinel-2 Timelapse

This example generates a timelapse of Sentinel-2 data for a selected ROI, with options to draw a custom ROI on the map. The timelapse spans 2017-2023, focusing on the June to September period each year.

```{code-cell} ipython3
m = geemap.Map(center=[41.718934, -86.894547], zoom=12)
m
```

Pan and zoom the map to an area of interest. Use the drawing tools to draw a rectangle on the map. If no rectangle is drawn, the default rectangle shown below will be used.

```{code-cell} ipython3
roi = m.user_roi
if roi is None:
    roi = ee.Geometry.BBox(-87.0492, 41.6545, -86.7903, 41.7604)
    m.add_layer(roi)
    m.center_object(roi)
```

```{code-cell} ipython3
timelapse = geemap.sentinel2_timelapse(
    roi,
    out_gif="sentinel2.gif",
    start_year=2017,
    end_year=2023,
    start_date="06-01",
    end_date="09-01",
    frequency="year",
    bands=["SWIR1", "NIR", "Red"],
    frames_per_second=3,
    title="Sentinel-2 Timelapse",
)
geemap.show_image(timelapse)
```

### MODIS Timelapse

The MODIS timelapse can showcase NDVI (vegetation index) or ocean color data over time. In the vegetation example, we visualize NDVI from 2000-2022 with country overlays. The temperature example animates Aqua satellite data for monthly temperature trends from 2018-2020 with continent overlays.

```{code-cell} ipython3
m = geemap.Map()
m
```

```{code-cell} ipython3
roi = m.user_roi
if roi is None:
    roi = ee.Geometry.BBox(-18.6983, -36.1630, 52.2293, 38.1446)
    m.add_layer(roi)
    m.center_object(roi)
```

```{code-cell} ipython3
timelapse = geemap.modis_ndvi_timelapse(
    roi,
    out_gif="ndvi.gif",
    data="Terra",
    band="NDVI",
    start_date="2000-01-01",
    end_date="2022-12-31",
    frames_per_second=3,
    title="MODIS NDVI Timelapse",
    overlay_data="countries",
)
geemap.show_image(timelapse)
```

MODIS temperature

```{code-cell} ipython3
m = geemap.Map()
m
```

```{code-cell} ipython3
roi = m.user_roi
if roi is None:
    roi = ee.Geometry.BBox(-171.21, -57.13, 177.53, 79.99)
    m.add_layer(roi)
    m.center_object(roi)
```

```{code-cell} ipython3
timelapse = geemap.modis_ocean_color_timelapse(
    satellite="Aqua",
    start_date="2018-01-01",
    end_date="2020-12-31",
    roi=roi,
    frequency="month",
    out_gif="temperature.gif",
    overlay_data="continents",
    overlay_color="yellow",
    overlay_opacity=0.5,
)
geemap.show_image(timelapse)
```

### GOES Timelapse

GOES timelapse generation can animate atmospheric phenomena in near real-time. We create animations for different ROIs, including hurricane tracking and fire events using GOES-17 data with custom time windows and frame rates.

```{code-cell} ipython3
roi = ee.Geometry.BBox(167.1898, -28.5757, 202.6258, -12.4411)
start_date = "2022-01-15T03:00:00"
end_date = "2022-01-15T07:00:00"
data = "GOES-17"
scan = "full_disk"
```

```{code-cell} ipython3
timelapse = geemap.goes_timelapse(
    roi, "goes.gif", start_date, end_date, data, scan, framesPerSecond=5
)
geemap.show_image(timelapse)
```

```{code-cell} ipython3
roi = ee.Geometry.BBox(-159.5954, 24.5178, -114.2438, 60.4088)
start_date = "2021-10-24T14:00:00"
end_date = "2021-10-25T01:00:00"
data = "GOES-17"
scan = "full_disk"
```

```{code-cell} ipython3
timelapse = geemap.goes_timelapse(
    roi, "hurricane.gif", start_date, end_date, data, scan, framesPerSecond=5
)
geemap.show_image(timelapse)
```

```{code-cell} ipython3
roi = ee.Geometry.BBox(-121.0034, 36.8488, -117.9052, 39.0490)
start_date = "2020-09-05T15:00:00"
end_date = "2020-09-06T02:00:00"
data = "GOES-17"
scan = "full_disk"
```

```{code-cell} ipython3
timelapse = geemap.goes_fire_timelapse(
    roi, "fire.gif", start_date, end_date, data, scan, framesPerSecond=5
)
geemap.show_image(timelapse)
```

## Charting

### Charting Features

#### Import libraries

To create charts for Earth Engine features, import required libraries like `calendar`, `ee`, `geemap`, and `chart`.

```{code-cell} ipython3
import calendar
import ee
import geemap
from geemap import chart
```

Initialize Earth Engine using `geemap.ee_initialize()`.

```{code-cell} ipython3
geemap.ee_initialize()
```

#### feature_by_feature

This function allows feature plotting along the x-axis, with values from selected properties represented along the y-axis. Ecoregions data is used to chart average monthly temperature across regions, where months serve as series columns.

```{code-cell} ipython3
ecoregions = ee.FeatureCollection("projects/google/charts_feature_example")
features = ecoregions.select("[0-9][0-9]_tmean|label")
```

```{code-cell} ipython3
geemap.ee_to_df(features)
```

```{code-cell} ipython3
x_property = "label"
y_properties = [str(x).zfill(2) + "_tmean" for x in range(1, 13)]

labels = calendar.month_abbr[1:]  # a list of month labels, e.g. ['Jan', 'Feb', ...]

colors = [
    "#604791",
    "#1d6b99",
    "#39a8a7",
    "#0f8755",
    "#76b349",
    "#f0af07",
    "#e37d05",
    "#cf513e",
    "#96356f",
    "#724173",
    "#9c4f97",
    "#696969",
]
title = "Average Monthly Temperature by Ecoregion"
x_label = "Ecoregion"
y_label = "Temperature"
```

```{code-cell} ipython3
fig = chart.feature_by_feature(
    features,
    x_property,
    y_properties,
    colors=colors,
    labels=labels,
    title=title,
    x_label=x_label,
    y_label=y_label,
)
fig
```

![](https://i.imgur.com/MZa99Vf.png)

+++

#### feature.by_property

Displays average precipitation by month for each ecoregion. Properties represent precipitation values for each month, allowing for visual comparison across regions by month.

```{code-cell} ipython3
ecoregions = ee.FeatureCollection("projects/google/charts_feature_example")
features = ecoregions.select("[0-9][0-9]_ppt|label")
```

```{code-cell} ipython3
geemap.ee_to_df(features)
```

```{code-cell} ipython3
keys = [str(x).zfill(2) + "_ppt" for x in range(1, 13)]
values = calendar.month_abbr[1:]  # a list of month labels, e.g. ['Jan', 'Feb', ...]
```

```{code-cell} ipython3
x_properties = dict(zip(keys, values))
series_property = "label"
title = "Average Ecoregion Precipitation by Month"
colors = ["#f0af07", "#0f8755", "#76b349"]
```

```{code-cell} ipython3
fig = chart.feature_by_property(
    features,
    x_properties,
    series_property,
    title=title,
    colors=colors,
    x_label="Month",
    y_label="Precipitation (mm)",
    legend_location="top-left",
)
fig
```

![](https://i.imgur.com/6RhuUc7.png)

+++

#### feature_groups

Plots groups of features based on property values, showing average January temperature for ecoregions divided into "Warm" and "Cold" categories.

```{code-cell} ipython3
ecoregions = ee.FeatureCollection("projects/google/charts_feature_example")
features = ecoregions.select("[0-9][0-9]_ppt|label")
```

```{code-cell} ipython3
features = ee.FeatureCollection("projects/google/charts_feature_example")
x_property = "label"
y_property = "01_tmean"
series_property = "warm"
title = "Average January Temperature by Ecoregion"
colors = ["#cf513e", "#1d6b99"]
labels = ["Warm", "Cold"]
```

```{code-cell} ipython3
chart.feature_groups(
    features,
    x_property,
    y_property,
    series_property,
    title=title,
    colors=colors,
    x_label="Ecoregion",
    y_label="January Temperature (°C)",
    legend_location="top-right",
    labels=labels,
)
```

![](https://i.imgur.com/YFZlJtc.png)

+++

#### feature_histogram

Generates a histogram displaying July precipitation distribution across a region, showing pixel count for different precipitation levels, useful for understanding data spread.

```{code-cell} ipython3
source = ee.ImageCollection("OREGONSTATE/PRISM/Norm91m").toBands()
region = ee.Geometry.Rectangle(-123.41, 40.43, -116.38, 45.14)
features = source.sample(region, 5000)
```

```{code-cell} ipython3
geemap.ee_to_df(features.limit(5).select(["07_ppt"]))
```

```{code-cell} ipython3
property = "07_ppt"
title = "July Precipitation Distribution for NW USA"
```

```{code-cell} ipython3
fig = chart.feature_histogram(
    features,
    property,
    max_buckets=None,
    title=title,
    x_label="Precipitation (mm)",
    y_label="Pixel Count",
    colors=["#1d6b99"],
)
fig
```

![](https://i.imgur.com/ErIp7Oy.png)

### Charting Images

#### image_by_region

Displays monthly temperature for each ecoregion using the `image_by_region` function, aggregating data to visualize average temperature by month across regions.

```{code-cell} ipython3
ecoregions = ee.FeatureCollection("projects/google/charts_feature_example")
image = (
    ee.ImageCollection("OREGONSTATE/PRISM/Norm91m").toBands().select("[0-9][0-9]_tmean")
)
```

```{code-cell} ipython3
labels = calendar.month_abbr[1:]  # a list of month labels, e.g. ['Jan', 'Feb', ...]
title = "Average Monthly Temperature by Ecoregion"
```

```{code-cell} ipython3
fig = chart.image_by_region(
    image,
    ecoregions,
    reducer="mean",
    scale=500,
    x_property="label",
    title=title,
    x_label="Ecoregion",
    y_label="Temperature",
    labels=labels,
)
fig
```

![](https://i.imgur.com/y4rp3dK.png)

+++

#### image_regions


Generates a chart showing average monthly precipitation across regions, using properties to represent months and comparing precipitation levels.

```{code-cell} ipython3
ecoregions = ee.FeatureCollection("projects/google/charts_feature_example")
image = (
    ee.ImageCollection("OREGONSTATE/PRISM/Norm91m").toBands().select("[0-9][0-9]_ppt")
)
```

```{code-cell} ipython3
keys = [str(x).zfill(2) + "_ppt" for x in range(1, 13)]
values = calendar.month_abbr[1:]  # a list of month labels, e.g. ['Jan', 'Feb', ...]
```

```{code-cell} ipython3
x_properties = dict(zip(keys, values))
title = "Average Ecoregion Precipitation by Month"
colors = ["#f0af07", "#0f8755", "#76b349"]
```

```{code-cell} ipython3
fig = chart.image_regions(
    image,
    ecoregions,
    reducer="mean",
    scale=500,
    series_property="label",
    x_labels=x_properties,
    title=title,
    colors=colors,
    x_label="Month",
    y_label="Precipitation (mm)",
    legend_location="top-left",
)
```

![](https://i.imgur.com/5WJVCNY.png)

+++

#### image_by_class

Displays spectral signatures of ecoregions by wavelength, showing reflectance values across spectral bands for comparison.

```{code-cell} ipython3
ecoregions = ee.FeatureCollection("projects/google/charts_feature_example")

image = (
    ee.ImageCollection("MODIS/061/MOD09A1")
    .filter(ee.Filter.date("2018-06-01", "2018-09-01"))
    .select("sur_refl_b0[0-7]")
    .mean()
    .select([2, 3, 0, 1, 4, 5, 6])
)

wavelengths = [469, 555, 655, 858, 1240, 1640, 2130]
```

```{code-cell} ipython3
fig = chart.image_by_class(
    image,
    class_band="label",
    region=ecoregions,
    reducer="MEAN",
    scale=500,
    x_labels=wavelengths,
    title="Ecoregion Spectral Signatures",
    x_label="Wavelength (nm)",
    y_label="Reflectance (x1e4)",
    colors=["#f0af07", "#0f8755", "#76b349"],
    legend_location="top-left",
    interpolation="basis",
)
fig
```

![](https://i.imgur.com/XqYHvBV.png)

+++

#### image_histogram

Generates histograms to visualize MODIS surface reflectance distribution across red, NIR, and SWIR bands, providing insights into data distribution by band.

```{code-cell} ipython3
image = (
    ee.ImageCollection("MODIS/061/MOD09A1")
    .filter(ee.Filter.date("2018-06-01", "2018-09-01"))
    .select(["sur_refl_b01", "sur_refl_b02", "sur_refl_b06"])
    .mean()
)

region = ee.Geometry.Rectangle([-112.60, 40.60, -111.18, 41.22])
```

```{code-cell} ipython3
fig = chart.image_histogram(
    image,
    region,
    scale=500,
    max_buckets=200,
    min_bucket_width=1.0,
    max_raw=1000,
    max_pixels=int(1e6),
    title="MODIS SR Reflectance Histogram",
    labels=["Red", "NIR", "SWIR"],
    colors=["#cf513e", "#1d6b99", "#f0af07"],
)
fig
```

![](https://i.imgur.com/mY4yoYH.png)

### Charting Image Collections

#### image_series

Creates a time series chart of vegetation indices (NDVI and EVI) for a forest region, helping to track vegetation health over time.

```{code-cell} ipython3
# Define the forest feature collection.
forest = ee.FeatureCollection("projects/google/charts_feature_example").filter(
    ee.Filter.eq("label", "Forest")
)

# Load MODIS vegetation indices data and subset a decade of images.
veg_indices = (
    ee.ImageCollection("MODIS/061/MOD13A1")
    .filter(ee.Filter.date("2010-01-01", "2020-01-01"))
    .select(["NDVI", "EVI"])
)
```

```{code-cell} ipython3
title = "Average Vegetation Index Value by Date for Forest"
x_label = "Year"
y_label = "Vegetation index (x1e4)"
colors = ["#e37d05", "#1d6b99"]
```

```{code-cell} ipython3
fig = chart.image_series(
    veg_indices,
    region=forest,
    reducer=ee.Reducer.mean(),
    scale=500,
    x_property="system:time_start",
    chart_type="LineChart",
    x_cols="date",
    y_cols=["NDVI", "EVI"],
    colors=colors,
    title=title,
    x_label=x_label,
    y_label=y_label,
    legend_location="right",
)
fig
```

![](https://i.imgur.com/r9zSJh6.png)

+++

#### image_series_by_region

Shows NDVI time series by region, comparing desert, forest, and grassland areas. Each region has a unique series for easy comparison.

```{code-cell} ipython3
# Import the example feature collection.
ecoregions = ee.FeatureCollection("projects/google/charts_feature_example")

# Load MODIS vegetation indices data and subset a decade of images.
veg_indices = (
    ee.ImageCollection("MODIS/061/MOD13A1")
    .filter(ee.Filter.date("2010-01-01", "2020-01-01"))
    .select(["NDVI"])
)
```

```{code-cell} ipython3
title = "Average NDVI Value by Date"
x_label = "Date"
y_label = "NDVI (x1e4)"
x_cols = "index"
y_cols = ["Desert", "Forest", "Grassland"]
colors = ["#f0af07", "#0f8755", "#76b349"]
```

```{code-cell} ipython3
fig = chart.image_series_by_region(
    veg_indices,
    regions=ecoregions,
    reducer=ee.Reducer.mean(),
    band="NDVI",
    scale=500,
    x_property="system:time_start",
    series_property="label",
    chart_type="LineChart",
    x_cols=x_cols,
    y_cols=y_cols,
    title=title,
    x_label=x_label,
    y_label=y_label,
    colors=colors,
    stroke_width=3,
    legend_location="bottom-left",
)
fig
```

![](https://i.imgur.com/rnILSfI.png)

+++

#### image_doy_series

Plots average vegetation index by day of year for a specific region, showing seasonal vegetation patterns over a decade.

```{code-cell} ipython3
# Import the example feature collection and subset the grassland feature.
grassland = ee.FeatureCollection("projects/google/charts_feature_example").filter(
    ee.Filter.eq("label", "Grassland")
)

# Load MODIS vegetation indices data and subset a decade of images.
veg_indices = (
    ee.ImageCollection("MODIS/061/MOD13A1")
    .filter(ee.Filter.date("2010-01-01", "2020-01-01"))
    .select(["NDVI", "EVI"])
)
```

```{code-cell} ipython3
title = "Average Vegetation Index Value by Day of Year for Grassland"
x_label = "Day of Year"
y_label = "Vegetation Index (x1e4)"
colors = ["#f0af07", "#0f8755"]
```

```{code-cell} ipython3
fig = chart.image_doy_series(
    image_collection=veg_indices,
    region=grassland,
    scale=500,
    chart_type="LineChart",
    title=title,
    x_label=x_label,
    y_label=y_label,
    colors=colors,
    stroke_width=5,
)
fig
```

![](https://i.imgur.com/F0z088e.png)

+++

#### image_doy_series_by_year

Compares NDVI by day of year across two different years, showing how vegetation patterns vary between 2012 and 2019.

```{code-cell} ipython3
# Import the example feature collection and subset the grassland feature.
grassland = ee.FeatureCollection("projects/google/charts_feature_example").filter(
    ee.Filter.eq("label", "Grassland")
)

# Load MODIS vegetation indices data and subset years 2012 and 2019.
veg_indices = (
    ee.ImageCollection("MODIS/061/MOD13A1")
    .filter(
        ee.Filter.Or(
            ee.Filter.date("2012-01-01", "2013-01-01"),
            ee.Filter.date("2019-01-01", "2020-01-01"),
        )
    )
    .select(["NDVI", "EVI"])
)
```

```{code-cell} ipython3
title = "Average Vegetation Index Value by Day of Year for Grassland"
x_label = "Day of Year"
y_label = "Vegetation Index (x1e4)"
colors = ["#e37d05", "#1d6b99"]
```

```{code-cell} ipython3
fig = chart.doy_series_by_year(
    veg_indices,
    band_name="NDVI",
    region=grassland,
    scale=500,
    chart_type="LineChart",
    colors=colors,
    title=title,
    x_label=x_label,
    y_label=y_label,
    stroke_width=5,
)
fig
```

![](https://i.imgur.com/ui6zpbl.png)

+++

#### image_doy_series_by_region

Visualizes average NDVI by day of year across regions, showcasing seasonal changes for desert, forest, and grassland ecoregions.

```{code-cell} ipython3
# Import the example feature collection and subset the grassland feature.
ecoregions = ee.FeatureCollection("projects/google/charts_feature_example")

# Load MODIS vegetation indices data and subset a decade of images.
veg_indices = (
    ee.ImageCollection("MODIS/061/MOD13A1")
    .filter(ee.Filter.date("2010-01-01", "2020-01-01"))
    .select(["NDVI"])
)
```

```{code-cell} ipython3
title = "Average Vegetation Index Value by Day of Year for Grassland"
x_label = "Day of Year"
y_label = "Vegetation Index (x1e4)"
colors = ["#f0af07", "#0f8755", "#76b349"]
```

```{code-cell} ipython3
fig = chart.image_doy_series_by_region(
    veg_indices,
    "NDVI",
    ecoregions,
    region_reducer="mean",
    scale=500,
    year_reducer=ee.Reducer.mean(),
    start_day=1,
    end_day=366,
    series_property="label",
    stroke_width=5,
    chart_type="LineChart",
    title=title,
    x_label=x_label,
    y_label=y_label,
    colors=colors,
    legend_location="right",
)
fig
```

![](https://i.imgur.com/eGqGoRs.png)

### Charting Array and List

#### Scatter Plot

Displays relationships between spectral bands, plotting red reflectance against NIR and SWIR reflectance to examine band correlations.

```{code-cell} ipython3
# Import the example feature collection and subset the forest feature.
forest = ee.FeatureCollection("projects/google/charts_feature_example").filter(
    ee.Filter.eq("label", "Forest")
)

# Define a MODIS surface reflectance composite.
modisSr = (
    ee.ImageCollection("MODIS/061/MOD09A1")
    .filter(ee.Filter.date("2018-06-01", "2018-09-01"))
    .select("sur_refl_b0[0-7]")
    .mean()
)

# Reduce MODIS reflectance bands by forest region; get a dictionary with
# band names as keys, pixel values as lists.
pixel_vals = modisSr.reduceRegion(
    **{"reducer": ee.Reducer.toList(), "geometry": forest.geometry(), "scale": 2000}
)

# Convert NIR and SWIR value lists to an array to be plotted along the y-axis.
y_values = pixel_vals.toArray(["sur_refl_b02", "sur_refl_b06"])


# Get the red band value list; to be plotted along the x-axis.
x_values = ee.List(pixel_vals.get("sur_refl_b01"))
```

```{code-cell} ipython3
title = "Relationship Among Spectral Bands for Forest Pixels"
colors = ["rgba(29,107,153,0.4)", "rgba(207,81,62,0.4)"]
```

```{code-cell} ipython3
fig = chart.array_values(
    y_values,
    axis=1,
    x_labels=x_values,
    series_names=["NIR", "SWIR"],
    chart_type="ScatterChart",
    colors=colors,
    title=title,
    x_label="Red reflectance (x1e4)",
    y_label="NIR & SWIR reflectance (x1e4)",
    default_size=15,
    xlim=(0, 800),
)
fig
```

![](https://i.imgur.com/zkPlZIO.png)

```{code-cell} ipython3
x = ee.List(pixel_vals.get("sur_refl_b01"))
y = ee.List(pixel_vals.get("sur_refl_b06"))
```

```{code-cell} ipython3
fig = chart.array_values(
    y,
    x_labels=x,
    series_names=["SWIR"],
    chart_type="ScatterChart",
    colors=["rgba(207,81,62,0.4)"],
    title=title,
    x_label="Red reflectance (x1e4)",
    y_label="SWIR reflectance (x1e4)",
    default_size=15,
    xlim=(0, 800),
)
fig
```

![](https://i.imgur.com/WHUHjH6.png)

+++

 #### Transect Line Plot

Plots elevation along a transect line across a specific region, providing a profile view of terrain elevation.

```{code-cell} ipython3
# Define a line across the Olympic Peninsula, USA.
transect = ee.Geometry.LineString([[-122.8, 47.8], [-124.5, 47.8]])

# Define a pixel coordinate image.
lat_lon_img = ee.Image.pixelLonLat()

# Import a digital surface model and add latitude and longitude bands.
elev_img = ee.Image("USGS/SRTMGL1_003").select("elevation").addBands(lat_lon_img)

# Reduce elevation and coordinate bands by transect line; get a dictionary with
# band names as keys, pixel values as lists.
elev_transect = elev_img.reduceRegion(
    reducer=ee.Reducer.toList(),
    geometry=transect,
    scale=1000,
)

# Get longitude and elevation value lists from the reduction dictionary.
lon = ee.List(elev_transect.get("longitude"))
elev = ee.List(elev_transect.get("elevation"))

# Sort the longitude and elevation values by ascending longitude.
lon_sort = lon.sort(lon)
elev_sort = elev.sort(lon)
```

```{code-cell} ipython3
fig = chart.array_values(
    elev_sort,
    x_labels=lon_sort,
    series_names=["Elevation"],
    chart_type="AreaChart",
    colors=["#1d6b99"],
    title="Elevation Profile Across Longitude",
    x_label="Longitude",
    y_label="Elevation (m)",
    stroke_width=5,
    fill="bottom",
    fill_opacities=[0.4],
    ylim=(0, 2500),
)
fig
```

![](https://i.imgur.com/k3XRita.png)

+++

#### Metadata Scatter Plot

Visualizes Landsat image metadata by plotting cloud cover against geometric RMSE, useful for quality assessment of image collections.

```{code-cell} ipython3
# Import a Landsat 8 collection and filter to a single path/row.
col = ee.ImageCollection("LANDSAT/LC08/C02/T1_L2").filter(
    ee.Filter.expression("WRS_PATH ==  45 && WRS_ROW == 30")
)

# Reduce image properties to a series of lists; one for each selected property.
propVals = col.reduceColumns(
    reducer=ee.Reducer.toList().repeat(2),
    selectors=["CLOUD_COVER", "GEOMETRIC_RMSE_MODEL"],
).get("list")

# Get selected image property value lists; to be plotted along x and y axes.
x = ee.List(ee.List(propVals).get(0))
y = ee.List(ee.List(propVals).get(1))
```

```{code-cell} ipython3
colors = [geemap.hex_to_rgba("#96356f", 0.4)]
print(colors)
```

```{code-cell} ipython3
fig = chart.array_values(
    y,
    x_labels=x,
    series_names=["RMSE"],
    chart_type="ScatterChart",
    colors=colors,
    title="Landsat 8 Image Collection Metadata (045030)",
    x_label="Cloud cover (%)",
    y_label="Geometric RMSE (m)",
    default_size=15,
)
fig
```

![](https://i.imgur.com/3COY3xd.png)

+++

#### Mapped Function Scatter & Line Plot

Plots a sine function as a line chart, mapping mathematical functions onto chart axes for visualization.

```{code-cell} ipython3
import math

start = -2 * math.pi
end = 2 * math.pi
points = ee.List.sequence(start, end, None, 50)


def sin_func(val):
    return ee.Number(val).sin()


values = points.map(sin_func)
```

```{code-cell} ipython3
fig = chart.array_values(
    values,
    points,
    chart_type="LineChart",
    colors=["#39a8a7"],
    title="Sine Function",
    x_label="radians",
    y_label="sin(x)",
    marker="circle",
)
fig
```

![](https://i.imgur.com/7qcxvey.png)

### Charting Data Table

#### Manual DataTable chart

Creates a chart from a manually created DataTable, such as US state populations.

```{code-cell} ipython3
import pandas as pd
```

```{code-cell} ipython3
data = {
    "State": ["CA", "NY", "IL", "MI", "OR"],
    "Population": [37253956, 19378102, 12830632, 9883640, 3831074],
}

df = pd.DataFrame(data)
df
```

```{code-cell} ipython3
fig = chart.Chart(
    df,
    x_cols=["State"],
    y_cols=["Population"],
    chart_type="ColumnChart",
    colors=["#1d6b99"],
    title="State Population (US census, 2010)",
    x_label="State",
    y_label="Population",
)
fig
```

![](https://i.imgur.com/vuxNmuh.png)

+++

#### Computed DataTable chart

Computes a DataTable from MODIS vegetation indices data for a forest area, then charts NDVI and EVI time series.

```{code-cell} ipython3
# Import the example feature collection and subset the forest feature.
forest = ee.FeatureCollection("projects/google/charts_feature_example").filter(
    ee.Filter.eq("label", "Forest")
)

# Load MODIS vegetation indices data and subset a decade of images.
veg_indices = (
    ee.ImageCollection("MODIS/061/MOD13A1")
    .filter(ee.Filter.date("2010-01-01", "2020-01-01"))
    .select(["NDVI", "EVI"])
)

# Build a feature collection where each feature has a property that represents
# a DataFrame row.


def aggregate(img):
    # Reduce the image to the mean of pixels intersecting the forest ecoregion.
    stat = img.reduceRegion(
        **{"reducer": ee.Reducer.mean(), "geometry": forest, "scale": 500}
    )

    # Extract the reduction results along with the image date.
    date = geemap.image_date(img)
    evi = stat.get("EVI")
    ndvi = stat.get("NDVI")

    # Make a list of observation attributes to define a row in the DataTable.
    row = ee.List([date, evi, ndvi])

    # Return the row as a property of an ee.Feature.
    return ee.Feature(None, {"row": row})


reduction_table = veg_indices.map(aggregate)

# Aggregate the 'row' property from all features in the new feature collection
# to make a server-side 2-D list (DataTable).
data_table_server = reduction_table.aggregate_array("row")

# Define column names and properties for the DataTable. The order should
# correspond to the order in the construction of the 'row' property above.
column_header = ee.List([["Date", "EVI", "NDVI"]])

# Concatenate the column header to the table.
data_table_server = column_header.cat(data_table_server)
```

```{code-cell} ipython3
data_table = chart.DataTable(data_table_server, date_column="Date")
data_table.head()
```

```{code-cell} ipython3
fig = chart.Chart(
    data_table,
    chart_type="LineChart",
    x_cols="Date",
    y_cols=["EVI", "NDVI"],
    colors=["#e37d05", "#1d6b99"],
    title="Average Vegetation Index Value by Date for Forest",
    x_label="Date",
    y_label="Vegetation index (x1e4)",
    stroke_width=3,
    legend_location="right",
)
fig
```

![](https://i.imgur.com/PWei7QC.png)

+++

#### Interval chart

Displays annual NDVI time series with variance, showing inter-annual vegetation change and variability across the year.

```{code-cell} ipython3
# Define a point to extract an NDVI time series for.
geometry = ee.Geometry.Point([-121.679, 36.479])

# Define a band of interest (NDVI), import the MODIS vegetation index dataset,
# and select the band.
band = "NDVI"
ndvi_col = ee.ImageCollection("MODIS/061/MOD13Q1").select(band)

# Map over the collection to add a day of year (doy) property to each image.


def set_doy(img):
    doy = ee.Date(img.get("system:time_start")).getRelative("day", "year")
    # Add 8 to day of year number so that the doy label represents the middle of
    # the 16-day MODIS NDVI composite.
    return img.set("doy", ee.Number(doy).add(8))


ndvi_col = ndvi_col.map(set_doy)

# Join all coincident day of year observations into a set of image collections.
distinct_doy = ndvi_col.filterDate("2013-01-01", "2014-01-01")
filter = ee.Filter.equals(**{"leftField": "doy", "rightField": "doy"})
join = ee.Join.saveAll("doy_matches")
join_col = ee.ImageCollection(join.apply(distinct_doy, ndvi_col, filter))

# Calculate the absolute range, interquartile range, and median for the set
# of images composing each coincident doy observation group. The result is
# an image collection with an image representative per unique doy observation
# with bands that describe the 0, 25, 50, 75, 100 percentiles for the set of
# coincident doy images.


def cal_percentiles(img):
    doyCol = ee.ImageCollection.fromImages(img.get("doy_matches"))

    return doyCol.reduce(
        ee.Reducer.percentile([0, 25, 50, 75, 100], ["p0", "p25", "p50", "p75", "p100"])
    ).set({"doy": img.get("doy")})


comp = ee.ImageCollection(join_col.map(cal_percentiles))

# Extract the inter-annual NDVI doy percentile statistics for the
# point of interest per unique doy representative. The result is
# is a feature collection where each feature is a doy representative that
# contains a property (row) describing the respective inter-annual NDVI
# variance, formatted as a list of values.


def order_percentiles(img):
    stats = ee.Dictionary(
        img.reduceRegion(
            **{"reducer": ee.Reducer.first(), "geometry": geometry, "scale": 250}
        )
    )

    # Order the percentile reduction elements according to how you want columns
    # in the DataTable arranged (x-axis values need to be first).
    row = ee.List(
        [
            img.get("doy"),
            stats.get(band + "_p50"),
            stats.get(band + "_p0"),
            stats.get(band + "_p25"),
            stats.get(band + "_p75"),
            stats.get(band + "_p100"),
        ]
    )

    # Return the row as a property of an ee.Feature.
    return ee.Feature(None, {"row": row})


reduction_table = comp.map(order_percentiles)

# Aggregate the 'row' properties to make a server-side 2-D array (DataTable).
data_table_server = reduction_table.aggregate_array("row")

# Define column names and properties for the DataTable. The order should
# correspond to the order in the construction of the 'row' property above.
column_header = ee.List([["DOY", "median", "p0", "p25", "p75", "p100"]])

# Concatenate the column header to the table.
data_table_server = column_header.cat(data_table_server)
```

```{code-cell} ipython3
df = chart.DataTable(data_table_server)
df.head()
```

```{code-cell} ipython3
fig = chart.Chart(
    df,
    chart_type="IntervalChart",
    x_cols="DOY",
    y_cols=["p0", "p25", "median", "p75", "p100"],
    title="Annual NDVI Time Series with Inter-Annual Variance",
    x_label="Day of Year",
    y_label="Vegetation index (x1e4)",
    stroke_width=1,
    fill="between",
    fill_colors=["#b6d1c6", "#83b191", "#83b191", "#b6d1c6"],
    fill_opacities=[0.6] * 4,
    labels=["p0", "p25", "median", "p75", "p100"],
    display_legend=True,
    legend_location="top-right",
    ylim=(0, 10000),
)
fig
```

![](https://i.imgur.com/i8ZrGPR.png)

+++

## Exercises

### Exercise 1: Visualizing DEM Data

Find a DEM dataset in the [Earth Engine Data Catalog](https://developers.google.com/earth-engine/datasets) and clip it to a specific area (e.g., your country, state, or city). Display it with an appropriate color palette. For example, the sample map below shows the DEM of the state of Colorado.

![](https://i.imgur.com/OLeSt7n.png)

```{code-cell} ipython3

```

### Exercise 2: Cloud-Free Composite with Sentinel-2 or Landsat

Use Sentinel-2 or Landsat-9 data to create a cloud-free composite for a specific year in a region of your choice.

Use [Sentinel-2](https://developers.google.com/earth-engine/datasets/catalog/COPERNICUS_S2_SR_HARMONIZED) or [Landsat-9 data](https://developers.google.com/earth-engine/datasets/catalog/landsat-9) data to create a cloud-free composite for a specific year in a region of your choice. Display the imagery on the map with a proper band combination. For example, the sample map below shows a cloud-free false-color composite of Sentinel-2 imagery of the year 2021 for the state of Colorado.

![](https://i.imgur.com/xkxpkS1.png)

```{code-cell} ipython3

```

### Exercise 3: Visualizing NAIP Imagery

Use [NAIP](https://developers.google.com/earth-engine/datasets/catalog/USDA_NAIP_DOQQ) imagery to create a cloud-free imagery for a U.S. county of your choice. For example, the sample map below shows a cloud-free true-color composite of NAIP imagery for Knox County, Tennessee. Keep in mind that there might be some counties with the same name in different states, so make sure to select the correct county for the selected state.

![](https://i.imgur.com/iZSGqGS.png)

```{code-cell} ipython3

```

### Exercise 4: Visualizing Watershed Boundaries

Visualize the [USGS Watershed Boundary Dataset](https://developers.google.com/earth-engine/datasets/catalog/USGS_WBD_2017_HUC04) with outline color only, no fill color.

![](https://i.imgur.com/PLlNFq3.png)

```{code-cell} ipython3

```

### Exercise 5: Visualizing Land Cover Change

Use the [USGS National Land Cover Database](https://developers.google.com/earth-engine/datasets/catalog/USGS_NLCD_RELEASES_2019_REL_NLCD) and [US Census States](https://developers.google.com/earth-engine/datasets/catalog/TIGER_2018_States) to create a split-panel map for visualizing land cover change (2001-2019) for a US state of your choice. Make sure you add the NLCD legend to the map.

![](https://i.imgur.com/Au7Q5Ln.png)

```{code-cell} ipython3

```

### Exercise 6: Creating a Landsat Timelapse Animation

Generate a timelapse animation using Landsat data to show changes over time for a selected region.

![Spain](https://github.com/user-attachments/assets/f12839c0-1c30-404d-b0ab-0fa12ce12d24)

```{code-cell} ipython3

```

## Summary

This lecture introduced **geemap**, a Python library designed to streamline geospatial data visualization and analysis in the **Google Earth Engine (GEE)** environment. Geemap enables users to perform GIS and remote sensing tasks with GEE data interactively in Python notebooks. Key topics included setting up GEE with geemap, loading and manipulating data from the Earth Engine Data Catalog, and processing vector and raster data. Techniques for creating animated timelapses using data from Landsat, Sentinel, MODIS, and GOES illustrated dynamic landscape monitoring, while interactive charting tools, like scatter plots and time series, supported data exploration and trend analysis. The lecture also covered exporting images and features in multiple formats, such as GeoTIFF, Shapefile, and CSV, to facilitate data sharing. Overall, this session provided a foundational understanding of geemap's capabilities, enabling users to efficiently visualize, analyze, and derive insights from Earth observation data in a Python setting.
