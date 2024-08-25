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

# Geemap

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/geospatial/geemap.ipynb)

## Introduction

This notebook is designed for users who are new to Google Earth Engine and geemap. It provides an introduction to Earth Engine and geemap, and demonstrates how to use geemap to explore and analyze Earth Engine data.

### Prerequisites

-   To use geemap and the Earth Engine Python API, you must [register](https://code.earthengine.google.com/register) for an Earth Engine account and follow the instructions [here](https://docs.google.com/document/d/1ZGSmrNm6_baqd8CHt33kIBWOlvkh-HLr46bODgJN1h0/edit?usp=sharing) to create a Cloud Project. Earth Engine is free for [noncommercial and research use](https://earthengine.google.com/noncommercial). To test whether you can use authenticate the Earth Engine Python API, please run [this notebook](https://colab.research.google.com/github/gee-community/geemap/blob/master/docs/notebooks/geemap_colab.ipynb) on Google Colab.

-   It is recommended that attendees have a basic understanding of Python and Jupyter Notebook.
-   Familiarity with the Earth Engine JavaScript API is not required but will be helpful.
-   Attendees can use Google Colab to follow this short course without installing anything on their computer.


### Agenda

The main topics to be covered in this workshop include:

* Create interactive maps
* Visualize Earth Engine data
* Explore Earth Engine Data Catalogs
* Analyze Earth Engine data
* Export Earth Engine data
* Create timelapse animations


## Introduction to Earth Engine and geemap

Earth Engine is free for [noncommercial and research use](https://earthengine.google.com/noncommercial). For more than a decade, Earth Engine has enabled planetary-scale Earth data science and analysis by nonprofit organizations, research scientists, and other impact users.

With the launch of Earth Engine for [commercial use](https://earthengine.google.com/commercial), commercial customers will be charged for Earth Engine services. However, Earth Engine will remain free of charge for noncommercial use and research projects. Nonprofit organizations, academic institutions, educators, news media, Indigenous governments, and government researchers are eligible to use Earth Engine free of charge, just as they have done for over a decade.

The geemap Python package is built upon the Earth Engine Python API and open-source mapping libraries. It allows Earth Engine users to interactively manipulate, analyze, and visualize geospatial big data in a Jupyter environment. Since its creation in April 2020, geemap has received over 3,300 GitHub stars and is being used by over 2,700 projects on GitHub.

## Google Colab and Earth Engine Python API authentication

[![image](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/gee-community/geemap/blob/master/docs/workshops/Taiwan_2024.ipynb)

### Change Colab dark theme

Currently, ipywidgets does not work well with Colab dark theme. Some of the geemap widgets may not display properly in Colab dark theme.It is recommended that you change Colab to the light theme.

![](https://i.imgur.com/EJ0GDP8.png)


### Install geemap

The geemap package is pre-installed in Google Colab and is updated to the latest minor or major release every few weeks. Some optional dependencies of geemap being used by this notebook are not pre-installed in Colab. Uncomment the following code block to install geemap and some optional dependencies.

```{code-cell} ipython3
# %pip install -U "geemap[workshop]"
```

Note that some geemap features may not work properly in the Google Colab environmennt. If you are familiar with [Anaconda](https://www.anaconda.com/download) or [Miniconda](https://docs.anaconda.com/free/miniconda), it is recommended to create a new conda environment to install geemap and its optional dependencies on your local computer.

```bash
conda create -n gee python=3.11
conda activate gee
conda install -c conda-forge mamba
mamba install -c conda-forge geemap pygis
```

+++

### Import libraries

Import the earthengine-api and geemap.

```{code-cell} ipython3
import ee
import geemap
```

### Authenticate and initialize Earth Engine

You will need to create a [Google Cloud Project](https://console.cloud.google.com/projectcreate) and enable the [Earth Engine API](https://console.cloud.google.com/apis/api/earthengine.googleapis.com) for the project. You can find detailed instructions [here](https://book.geemap.org/chapters/01_introduction.html#earth-engine-authentication).

```{code-cell} ipython3
ee.Authenticate()
```

```{code-cell} ipython3
ee.Initialize(project="YOUR-PROJECT-ID")
```

## Creating interactive maps

Let's create an interactive map using the `ipyleaflet` plotting backend. The [`geemap.Map`](https://geemap.org/geemap/#geemap.geemap.m) class inherits the [`ipyleaflet.Map`](https://ipyleaflet.readthedocs.io/en/latest/map_and_basemaps/map.html) class. Therefore, you can use the same syntax to create an interactive map as you would with `ipyleaflet.Map`.

```{code-cell} ipython3
m = geemap.Map()
```

To display it in a Jupyter notebook, simply ask for the object representation:

```{code-cell} ipython3
m
```

To customize the map, you can specify various keyword arguments, such as `center` ([lat, lon]), `zoom`, `width`, and `height`. The default `width` is `100%`, which takes up the entire cell width of the Jupyter notebook. The `height` argument accepts a number or a string. If a number is provided, it represents the height of the map in pixels. If a string is provided, the string must be in the format of a number followed by `px`, e.g., `600px`.

```{code-cell} ipython3
m = geemap.Map(center=[40, -100], zoom=4, height="600xp")
m
```

To hide a control, set `control_name` to `False`, e.g., `draw_ctrl=False`.

```{code-cell} ipython3
m = geemap.Map(data_ctrl=False, toolbar_ctrl=False, draw_ctrl=False)
m
```

### Adding basemaps

There are several ways to add basemaps to a map. You can specify the basemap to use in the `basemap` keyword argument when creating the map. Alternatively, you can add basemap layers to the map using the `add_basemap` method. Geemap has hundreds of built-in basemaps available that can be easily added to the map with only one line of code.

Create a map by specifying the basemap to use as follows. For example, the `Esri.WorldImagery` basemap represents the Esri world imagery basemap.

```{code-cell} ipython3
m = geemap.Map(basemap="Esri.WorldImagery")
m
```

You can add as many basemaps as you like to the map. For example, the following code adds the `OpenTopoMap` basemap to the map above:

```{code-cell} ipython3
m.add_basemap("OpenTopoMap")
```

You can also change basemaps interactively using the basemap GUI.

```{code-cell} ipython3
m = geemap.Map()
m.add("basemap_selector")
m
```

## Using Earth Engine data

### Earth Engine data types

Earth Engine objects are server-side objects rather than client-side objects, which means that they are not stored locally on your computer. Similar to video streaming services (e.g., YouTube, Netflix, and Hulu), which store videos/movies on their servers, Earth Engine data are stored on the Earth Engine servers. We can stream geospatial data from Earth Engine on-the-fly without having to download the data just like we can watch videos from streaming services using a web browser without having to download the entire video to your computer.

-   **Image**: the fundamental raster data type in Earth Engine.
-   **ImageCollection**: a stack or time-series of images.
-   **Geometry**: the fundamental vector data type in Earth Engine.
-   **Feature**: a Geometry with attributes.
-   **FeatureCollection**: a set of features.

### Image

Raster data in Earth Engine are represented as **Image** objects. Images are composed of one or more bands and each band has its own name, data type, scale, mask and projection. Each image has metadata stored as a set of properties.

#### Loading Earth Engine images

```{code-cell} ipython3
image = ee.Image("USGS/SRTMGL1_003")
image
```

#### Visualizing Earth Engine images

```{code-cell} ipython3
m = geemap.Map(center=[23.5790, 121.4181], zoom=8)
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

An `ImageCollection` is a stack or sequence of images. An `ImageCollection` can be loaded by passing an Earth Engine asset ID into the `ImageCollection` constructor. You can find `ImageCollection` IDs in the [Earth Engine Data Catalog](https://developers.google.com/earth-engine/datasets).

#### Loading image collections

For example, to load the image collection of the [Sentinel-2 surface reflectance](https://developers.google.com/earth-engine/datasets/catalog/COPERNICUS_S2_SR):

```{code-cell} ipython3
collection = ee.ImageCollection("COPERNICUS/S2_SR")
```

#### Visualizing image collections

To visualize an Earth Engine **ImageCollection**, we need to convert an **ImageCollection** to an **Image** by compositing all the images in the collection to a single image representing, for example, the min, max, median, mean or standard deviation of the images. For example, to create a median value image from a collection, use the `collection.median()` method. Let's create a median image from the Sentinel-2 surface reflectance collection:

```{code-cell} ipython3
m = geemap.Map()
collection = (
    ee.ImageCollection("COPERNICUS/S2_SR")
    .filterDate("2023-01-01", "2024-01-01")
    .filter(ee.Filter.lt("CLOUDY_PIXEL_PERCENTAGE", 5))
)
image = collection.median()

vis = {
    "min": 0.0,
    "max": 3000,
    "bands": ["B4", "B3", "B2"],
}

m.set_center(121.4181, 23.5790, 8)
m.add_layer(image, vis, "Sentinel-2")
m
```

### FeatureCollection

A **FeatureCollection** is a collection of Features. A FeatureCollection is analogous to a GeoJSON FeatureCollection object, i.e., a collection of features with associated properties/attributes. Data contained in a shapefile can be represented as a FeatureCollection.

#### Loading feature collections

The [Earth Engine Data Catalog](https://developers.google.com/earth-engine/datasets) hosts a variety of vector datasets (e.g,, US Census data, country boundaries, and more) as feature collections. You can find feature collection IDs by searching the data catalog. For example, to load the [TIGER roads data](https://developers.google.com/earth-engine/datasets/catalog/TIGER_2016_Roads) by the U.S. Census Bureau:

```{code-cell} ipython3
m = geemap.Map()
fc = ee.FeatureCollection("TIGER/2016/Roads")
m.set_center(-73.9596, 40.7688, 12)
m.add_layer(fc, {}, "Census roads")
m
```

#### Filtering feature collections

* [geoBoundaries: Political administrative boundaries at Country level (ADM0)](https://developers.google.com/earth-engine/datasets/catalog/WM_geoLab_geoBoundaries_600_ADM0)
* [geoBoundaries: Political administrative boundaries at District level (ADM1)](https://developers.google.com/earth-engine/datasets/catalog/WM_geoLab_geoBoundaries_600_ADM1)

```{code-cell} ipython3
m = geemap.Map()
countries = ee.FeatureCollection("WM/geoLab/geoBoundaries/600/ADM0")
fc = countries.filter(ee.Filter.eq("shapeName", "Taiwan"))
m.add_layer(fc, {}, "Taiwan")
m.center_object(fc, 8)
m
```

```{code-cell} ipython3
m = geemap.Map()
countries = ee.FeatureCollection("WM/geoLab/geoBoundaries/600/ADM1")
fc = countries.filter(ee.Filter.eq("shapeGroup", "TWN"))
m.add_layer(fc, {}, "Taiwan")
m.center_object(fc, 8)
m
```

```{code-cell} ipython3
region = m.user_roi
if region is None:
    region = ee.Geometry.BBox(119.1687, 21.7799, 122.981, 25.4234)

fc = fc.filterBounds(region)
m.add_layer(fc, {}, "Taiwan 2")
m.center_object(fc, 8)
```

#### Visualizing feature collections

```{code-cell} ipython3
m = geemap.Map()
countries = ee.FeatureCollection("WM/geoLab/geoBoundaries/600/ADM1")
fc = countries.filter(ee.Filter.eq("shapeGroup", "TWN"))
m.add_layer(fc, {}, "Taiwan")
m.center_object(fc, 8)
m
```

```{code-cell} ipython3
m = geemap.Map()
countries = ee.FeatureCollection("WM/geoLab/geoBoundaries/600/ADM1")
fc = countries.filter(ee.Filter.eq("shapeGroup", "TWN"))
style = {"color": "000000ff", "width": 2, "lineType": "solid", "fillColor": "FF000000"}
m.add_layer(fc.style(**style), {}, "Taiwan")
m.center_object(fc, 8)
m
```

```{code-cell} ipython3
m = geemap.Map()
countries = ee.FeatureCollection("WM/geoLab/geoBoundaries/600/ADM1")
fc = countries.filter(ee.Filter.eq("shapeGroup", "TWN"))
style = {"color": "0000ffff", "width": 2, "lineType": "solid", "fillColor": "FF000080"}
m.add_layer(fc.style(**style), {}, "Taiwan")
m.center_object(fc, 8)
m
```

### Earth Engine Data Catalog

The [Earth Engine Data Catalog](https://developers.google.com/earth-engine/datasets) hosts a variety of geospatial datasets. As of July 2024, the catalog contains over [1,100 datasets](https://github.com/opengeos/Earth-Engine-Catalog/blob/master/gee_catalog.tsv) with a total size of over 100 petabytes. Some notable datasets include: Landsat, Sentinel, MODIS, NAIP, etc. For a complete list of datasets in CSV or JSON formats, see the [Earth Engine Datasets List](https://github.com/giswqs/Earth-Engine-Catalog/blob/master/gee_catalog.tsv).

#### Searching for datasets

The [Earth Engine Data Catalog](https://developers.google.com/earth-engine/datasets/catalog) is searchable. You can search datasets by name, keyword, or tag. For example, enter "elevation" in the search box will filter the catalog to show only datasets containing "elevation" in their name, description, or tags. 52 datasets are returned for this search query. Scroll down the list to find the [NASA SRTM Digital Elevation 30m](https://developers.google.com/earth-engine/datasets/catalog/USGS_SRTMGL1_003#description) dataset. On each dataset page, you can find the following information, including Dataset Availability, Dataset Provider, Earth Engine Snippet, Tags, Description, Code Example, and more. One important piece of information is the Image/ImageCollection/FeatureCollection ID of each dataset, which is essential for accessing the dataset through the Earth Engine JavaScript or Python APIs.

![](https://i.imgur.com/B3rf4QN.jpg)

```{code-cell} ipython3
m = geemap.Map()
m
```

```{code-cell} ipython3
m = geemap.Map()
dem = ee.Image("USGS/SRTMGL1_003")
vis_params = {
    "min": 0,
    "max": 4000,
    "palette": ["006633", "E5FFCC", "662A00", "D8D8D8", "F5F5F5"],
}
m.add_layer(dem, vis_params, "SRTM DEM")
m
```

```{code-cell} ipython3
m = geemap.Map()
counties = ee.FeatureCollection("WM/geoLab/geoBoundaries/600/ADM0")
fc = counties.filter(ee.Filter.eq("shapeName", "Taiwan"))
dem = ee.Image("USGS/SRTMGL1_003").clipToCollection(fc)
vis_params = {
    "min": 0,
    "max": 4000,
    "palette": ["006633", "E5FFCC", "662A00", "D8D8D8", "F5F5F5"],
}

m.add_layer(fc, {}, "Taiwan")
m.add_layer(dem, vis_params, "SRTM DEM")
m.center_object(fc, 8)
m
```

### Exercise 1 - Creating cloud-free imagery

Create a cloud-free imagery of Taiwan for the year of 2023. You can use either Landsat 9 or Sentinel-2 imagery. Relevant Earth Engine assets:

-   [ee.FeatureCollection("TIGER/2018/States")](https://developers.google.com/earth-engine/datasets/catalog/TIGER_2018_States)
-   [ee.ImageCollection("COPERNICUS/S2_SR")](https://developers.google.com/earth-engine/datasets/catalog/COPERNICUS_S2_SR)
-   [ee.ImageCollection("LANDSAT/LC09/C02/T1_L2")](https://developers.google.com/earth-engine/datasets/catalog/LANDSAT_LC09_C02_T1_L2)

A sample map of cloud-free imagery for the state of Texas is shown below:

![](https://i.imgur.com/i3IT0lF.png)

```{code-cell} ipython3
# Type your code here
```

## Visualizing Earth Engine data

### Using the inspector tool

Inspect pixel values and vector features using the inspector tool.

```{code-cell} ipython3
m = geemap.Map()

counties = ee.FeatureCollection("WM/geoLab/geoBoundaries/600/ADM0")
fc = counties.filter(ee.Filter.eq("shapeName", "Taiwan"))

dem = ee.Image("USGS/SRTMGL1_003")
landsat7 = ee.Image("LANDSAT/LE7_TOA_5YEAR/1999_2003").select(
    ["B1", "B2", "B3", "B4", "B5", "B7"]
)

vis_params = {
    "min": 0,
    "max": 4000,
    "palette": ["006633", "E5FFCC", "662A00", "D8D8D8", "F5F5F5"],
}

m.add_layer(
    landsat7,
    {"bands": ["B4", "B3", "B2"], "min": 20, "max": 200, "gamma": 2.0},
    "Landsat 7",
)
m.add_layer(dem, vis_params, "SRTM DEM")
m.add_layer(fc, {}, "Taiwan")
m.add("inspector")
m.center_object(fc, 8)
m
```

### Using the plotting tool

Plot spectral profiles of pixels using the plotting tool.

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
m.center_object(fc, 8)
m
```

Set plotting options for Landsat.

```{code-cell} ipython3
m.set_plot_options(add_marker_cluster=True, overlay=True)
```

Set plotting options for Hyperion.

```{code-cell} ipython3
m.set_plot_options(add_marker_cluster=True, plot_type="bar")
```

### Legends, color bars, and labels

#### Built-in legends

```{code-cell} ipython3
from geemap.legends import builtin_legends
```

```{code-cell} ipython3
for legend in builtin_legends:
    print(legend)
```

Add ESA WorldCover and legend to the map.

https://developers.google.com/earth-engine/datasets/catalog/ESA_WorldCover_v200

```{code-cell} ipython3
m = geemap.Map()
m.add_basemap("Esri.WorldImagery")

dataset = ee.ImageCollection("ESA/WorldCover/v200").first()
visualization = {"bands": ["Map"]}
m.add_layer(dataset, visualization, "Landcover")
m.add_legend(title="Land Cover Type", builtin_legend="ESA_WorldCover")
m.set_center(121.4181, 23.5790, 8)
m
```

#### Custom legends

+++

Add a custom legend by specifying a dictionary of colors and labels.

```{code-cell} ipython3
m = geemap.Map()
m.add_basemap("Esri.WorldImagery")

dataset = ee.ImageCollection("ESA/WorldCover/v200").first()
visualization = {"bands": ["Map"]}
m.add_layer(dataset, visualization, "Landcover")
legend_dict = {
    "10 Trees": "006400",
    "20 Shrubland": "ffbb22",
    "30 Grassland": "ffff4c",
    "40 Cropland": "f096ff",
    "50 Built-up": "fa0000",
    "60 Barren / sparse vegetation": "b4b4b4",
    "70 Snow and ice": "f0f0f0",
    "80 Open water": "0064c8",
    "90 Herbaceous wetland": "0096a0",
    "95 Mangroves": "00cf75",
    "100 Moss and lichen": "fae6a0",
}
m.add_legend(title="Land Cover Type", legend_dict=legend_dict)
m.set_center(121.4181, 23.5790, 8)
m
```

#### Creating color bars

Add a horizontal color bar.

```{code-cell} ipython3
m = geemap.Map()
countries = ee.FeatureCollection("WM/geoLab/geoBoundaries/600/ADM0")
fc = countries.filter(ee.Filter.eq("shapeName", "Taiwan"))
dem = ee.Image("USGS/SRTMGL1_003").clipToCollection(fc)
vis_params = {
    "min": 0,
    "max": 4000,
    "palette": ["006633", "E5FFCC", "662A00", "D8D8D8", "F5F5F5"],
}

m.add_layer(dem, vis_params, "SRTM DEM")
m.add_colorbar(vis_params, label="Elevation (m)", layer_name="SRTM DEM")
m.center_object(fc, 8)
m
```

Add a vertical color bar.

```{code-cell} ipython3
m.add_colorbar(
    vis_params,
    label="Elevation (m)",
    layer_name="SRTM DEM",
    orientation="vertical",
    max_width="100px",
)
```

Make the color bar background transparent.

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

### Split-panel map and linked maps

### Split-panel maps

Create a split map with basemaps. Note that ipyleaflet has a bug with the SplitControl. You can't pan the map, which should be resolved in the next ipyleaflet release.

```{code-cell} ipython3
m = geemap.Map()
m.split_map(left_layer="Esri.WorldTopoMap", right_layer="OpenTopoMap")
m.set_center(121.4181, 23.5790, 8)
m
```

Create a split map with Earth Engine layers.

```{code-cell} ipython3
m = geemap.Map()

esa_2020 = ee.ImageCollection("ESA/WorldCover/v100").first()
esa_2021 = ee.ImageCollection("ESA/WorldCover/v200").first()
visualization = {"bands": ["Map"]}

left_layer = geemap.ee_tile_layer(esa_2020, visualization, "Land Cover 2020")
right_layer = geemap.ee_tile_layer(esa_2021, visualization, "Land Cover 2021")

m.split_map(
    left_layer, right_layer, left_label="Land Cover 2020", right_label="Land Cover 2021"
)
m.add_legend(title="Land Cover Type", builtin_legend="ESA_WorldCover")
m.set_center(121.4181, 23.5790, 8)
m
```

### Linked maps

Create a 2x2 linked map for visualizing Sentinel-2 imagery with different band combinations. Note that this feature does not work properly with Colab. Panning one map would not pan other maps.

```{code-cell} ipython3
countries = ee.FeatureCollection("WM/geoLab/geoBoundaries/600/ADM0")
fc = countries.filter(ee.Filter.eq("shapeName", "Taiwan"))
image = (
    ee.ImageCollection("COPERNICUS/S2")
    .filterDate("2023-01-01", "2024-01-01")
    .filter(ee.Filter.lt("CLOUDY_PIXEL_PERCENTAGE", 5))
    .filterBounds(fc)
    .map(lambda img: img.divide(10000))
    .median()
    .clipToCollection(fc)
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
    height="400px",
    center=[23.5790, 121.4181],
    zoom=8,
    ee_objects=[image],
    vis_params=vis_params,
    labels=labels,
    label_position="topright",
)
```

### Timeseries inspector and time slider

#### Timeseries inspector

Check the available years of NLCD.

```{code-cell} ipython3
m = geemap.Map(center=[40, -100], zoom=4)
collection = ee.ImageCollection("USGS/NLCD_RELEASES/2019_REL/NLCD").select("landcover")
vis_params = {"bands": ["landcover"]}
years = collection.aggregate_array("system:index").getInfo()
years
```

Create a timeseries inspector for NLCD. Note that ipyleaflet has a bug with the SplitControl. You can't pan the map, which should be resolved in a future ipyleaflet release.

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

#### Time slider

Note that this feature may not work properly with in the Colab environment. Restart Colab runtime if the time slider does not work.

Create a map for visualizing MODIS vegetation data.

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

Create a map for visualizing weather data.

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

Visualizing Sentinel-2 imagery

```{code-cell} ipython3
m = geemap.Map(center=[37.75, -122.45], zoom=12)

collection = (
    ee.ImageCollection("COPERNICUS/S2_SR")
    .filterBounds(ee.Geometry.Point([-122.45, 37.75]))
    .filterMetadata("CLOUDY_PIXEL_PERCENTAGE", "less_than", 10)
)

vis_params = {"min": 0, "max": 4000, "bands": ["B8", "B4", "B3"]}

m.add_time_slider(collection, vis_params)
m
```

### Exercise 2 - Visualizing satellite data for an area of interest

Visualize the time series of [Sentinel-2](https://developers.google.com/earth-engine/datasets/catalog/COPERNICUS_S2_SR_HARMONIZED) imagery for an area of interest in Taiwan. You can use the following Earth Engine assets:

- `ee.ImageCollection("COPERNICUS/S2_SR_HARMONIZED")`

+++

## Analyzing Earth Engine data

### Zonal statistics

```{code-cell} ipython3
m = geemap.Map()
countries = ee.FeatureCollection("WM/geoLab/geoBoundaries/600/ADM1")
fc = countries.filter(ee.Filter.eq("shapeGroup", "TWN"))
# Add NASA SRTM
dem = ee.Image("USGS/SRTMGL1_003").clipToCollection(fc)
dem_vis = {
    "min": 0,
    "max": 4000,
    "palette": ["006633", "E5FFCC", "662A00", "D8D8D8", "F5F5F5"],
}
m.add_layer(dem, dem_vis, "SRTM DEM")

# Add 5-year Landsat TOA composite
landsat = ee.Image("LANDSAT/LE7_TOA_5YEAR/1999_2003").clipToCollection(fc)
landsat_vis = {"bands": ["B4", "B3", "B2"], "gamma": 1.4, "min": 20, "max": 150}
m.add_layer(landsat, landsat_vis, "Landsat", False)
m.add_layer(fc, {}, "Taiwan")
m.center_object(fc, 8)
m
```

```{code-cell} ipython3
out_dem_stats = "dem_stats.csv"
geemap.zonal_stats(dem, fc, out_dem_stats, stat_type="MEAN", scale=30, return_fc=False)
```

```{code-cell} ipython3
geemap.csv_to_df(out_dem_stats).sort_values(by=["mean"])
```

```{code-cell} ipython3
out_landsat_stats = "landsat_stats.csv"
geemap.zonal_stats(
    landsat,
    fc,
    out_landsat_stats,
    stat_type="MEAN",
    scale=30,
    return_fc=False,
)
```

```{code-cell} ipython3
geemap.csv_to_df(out_landsat_stats)
```

### Zonal statistics by group

```{code-cell} ipython3
m = geemap.Map()
m.add_basemap("Esri.WorldImagery")
countries = ee.FeatureCollection("WM/geoLab/geoBoundaries/600/ADM1")
fc = countries.filter(ee.Filter.eq("shapeGroup", "TWN"))
dataset = ee.ImageCollection("ESA/WorldCover/v200").first().clipToCollection(fc)
visualization = {"bands": ["Map"]}
m.add_layer(dataset, visualization, "Landcover")
m.add_legend(title="Land Cover Type", builtin_legend="ESA_WorldCover")
m.add_layer(fc, {}, "Taiwan")
m.set_center(121.4181, 23.5790, 8)
m
```

```{code-cell} ipython3
landcover_stats = "landcover_stats.csv"

geemap.zonal_stats_by_group(
    dataset,
    fc,
    landcover_stats,
    stat_type="SUM",
    denominator=1e6,
    decimal_places=2,
)
```

```{code-cell} ipython3
geemap.csv_to_df(landcover_stats)
```

```{code-cell} ipython3
landcover_stats = "landcover_stats_pct.csv"

geemap.zonal_stats_by_group(
    dataset,
    fc,
    landcover_stats,
    stat_type="PERCENTAGE",
    denominator=1e6,
    decimal_places=2,
)
```

```{code-cell} ipython3
geemap.csv_to_df(landcover_stats)
```

## Exporting Earth Engine data

### Exporting images

```{code-cell} ipython3
m = geemap.Map()
roi = ee.Geometry.Point([121.615219, 25.041219])
image = (
    ee.ImageCollection("COPERNICUS/S2_SR_HARMONIZED")
    .filterDate("2024-01-01", "2024-08-01")
    .filter(ee.Filter.lt("CLOUDY_PIXEL_PERCENTAGE", 10))
    .filterBounds(roi)
    .sort("CLOUDY_PIXEL_PERCENTAGE")
    .first()
    .select(["B8", "B4", "B3"])
)

vis_params = {"min": 0, "max": 3000}

m.add_layer(image, vis_params, "Sentinel-2")
m.center_object(roi, 8)
m
```

```{code-cell} ipython3
region = ee.Geometry.BBox(121.3824, 24.9325, 121.6653, 25.1496)
fc = ee.FeatureCollection(region)
style = {"color": "ffff00ff", "fillColor": "00000000"}
m.add_layer(fc.style(**style), {}, "ROI")
```

```{code-cell} ipython3
geemap.ee_export_image(image, filename="sentinel-2.tif", scale=30, region=region)
```

```{code-cell} ipython3
geemap.ee_export_image_to_drive(
    image, description="sentinel-2", folder="export", region=region, scale=30
)
```

```{code-cell} ipython3
geemap.download_ee_image(image, "sentinel-2_10m.tif", region=region, scale=10)
```

### Export image collections

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

```{code-cell} ipython3
geemap.ee_export_image_collection(collection, out_dir="naip", scale=10)
```

```{code-cell} ipython3
geemap.ee_export_image_collection_to_drive(collection, folder="export", scale=10)
```

### Exporting feature collections

```{code-cell} ipython3
m = geemap.Map()
countries = ee.FeatureCollection("WM/geoLab/geoBoundaries/600/ADM0")
fc = countries.filter(ee.Filter.eq("shapeName", "Taiwan"))
m.add_layer(fc, {}, "Taiwan")
m.center_object(fc, 8)
m
```

```{code-cell} ipython3
geemap.ee_to_shp(fc, filename="Taiwan.shp")
```

```{code-cell} ipython3
geemap.ee_export_vector(fc, filename="Taiwan.shp")
```

```{code-cell} ipython3
geemap.ee_to_geojson(fc, filename="Taiwan.geojson")
```

```{code-cell} ipython3
geemap.ee_to_csv(fc, filename="Taiwan.csv")
```

```{code-cell} ipython3
gdf = geemap.ee_to_gdf(fc)
gdf
```

```{code-cell} ipython3
df = geemap.ee_to_df(fc)
df
```

```{code-cell} ipython3
geemap.ee_export_vector_to_drive(
    fc, description="Alaska", fileFormat="SHP", folder="export"
)
```

## Creating timelapse animations

### Landsat timelapse

```{code-cell} ipython3
m = geemap.Map()
m.set_center(121.615219, 25.041219, 12)
m
```

```{code-cell} ipython3
roi = m.user_roi
if roi is None:
    roi = ee.Geometry.BBox(121.3824, 24.9325, 121.6653, 25.1496)
    m.add_layer(roi)
    m.center_object(roi)
```

```{code-cell} ipython3
timelapse = geemap.landsat_timelapse(
    roi,
    out_gif="Taiwan.gif",
    start_year=1988,
    end_year=2024,
    start_date="01-01",
    end_date="12-31",
    bands=["SWIR1", "NIR", "Red"],
    frames_per_second=5,
    title="Taipei",
    progress_bar_color="blue",
    mp4=True,
)
geemap.show_image(timelapse)
```

```{code-cell} ipython3
roi = ee.Geometry.BBox(113.8252, 22.1988, 114.0851, 22.3497)
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

```{code-cell} ipython3
roi = ee.Geometry.BBox(-115.5541, 35.8044, -113.9035, 36.5581)
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

### Sentinel-2 timelapse

```{code-cell} ipython3
m = geemap.Map()
m.set_center(121.615219, 25.041219, 12)
m
```

```{code-cell} ipython3
roi = m.user_roi
if roi is None:
    roi = ee.Geometry.BBox(121.3824, 24.9325, 121.6653, 25.1496)
    m.add_layer(roi)
    m.center_object(roi)
```

```{code-cell} ipython3
timelapse = geemap.sentinel2_timelapse(
    roi,
    out_gif="sentinel2.gif",
    start_year=2017,
    end_year=2024,
    start_date="01-01",
    end_date="12-31",
    frequency="year",
    bands=["SWIR1", "NIR", "Red"],
    frames_per_second=3,
    title="Sentinel-2 Timelapse",
)
geemap.show_image(timelapse)
```

### MODIS vegetation indices

```{code-cell} ipython3
Map = geemap.Map()
Map
```

```{code-cell} ipython3
roi = Map.user_roi
if roi is None:
    roi = ee.Geometry.BBox(-18.6983, -36.1630, 52.2293, 38.1446)
    Map.addLayer(roi)
    Map.centerObject(roi)
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

### MODIS temperature data

```{code-cell} ipython3
Map = geemap.Map()
Map
```

```{code-cell} ipython3
roi = Map.user_roi
if roi is None:
    roi = ee.Geometry.BBox(-171.21, -57.13, 177.53, 79.99)
    Map.addLayer(roi)
    Map.centerObject(roi)
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

### GOES timelapse

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

### Exercise 3 - Creating timelapse animations

Use the geemap timelapse GUI to create a timelapse animation for any location of your choice. Share the timelapse on social media and use the hashtag such as #EarthEngine and #geemap. See [this](https://i.imgur.com/YaCHvKC.gif) example.

![](https://i.imgur.com/ohrXeFC.png)

```{code-cell} ipython3
m = geemap.Map()
m.add_gui("timelapse")
m
```
