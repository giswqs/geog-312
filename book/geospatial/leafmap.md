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

# Leafmap

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/geospatial/leafmap.ipynb)


## Overview

This lecture offers a comprehensive introduction to [Leafmap](https://leafmap.org), a powerful, open-source Python package for creating, managing, and analyzing interactive geospatial maps. Leafmap simplifies working with geospatial data by providing a high-level, Pythonic interface that integrates seamlessly with Jupyter environments, such as Google Colab, Jupyter Notebook, and JupyterLab.

Built on top of several well-established libraries like [folium](https://python-visualization.github.io/folium), [ipyleaflet](https://ipyleaflet.readthedocs.io), [maplibre](https://eodagmbh.github.io/py-maplibregl), [bokeh](https://docs.bokeh.org/en/latest/docs/user_guide/topics/geo.html), [pydeck](https://deckgl.readthedocs.io), [kepler.gl](https://docs.kepler.gl/docs/keplergl-jupyter), and [plotly](https://plotly.com/python/maps), Leafmap extends their functionalities with a unified API. This extension streamlines the process of visualizing and analyzing geospatial data interactively, minimizing the amount of coding required.

In this lecture, we will explore Leafmap’s key features, including how to create interactive maps, add and customize basemaps, visualize both vector and raster data, and edit vector layers. Each section provides practical examples and guidance essential for using Leafmap effectively in GIS programming tasks.

## Learning Objectives

By the end of this lecture, you will be able to:
- Create and customize interactive maps using Leafmap.
- Add and configure different basemap layers.
- Visualize and style vector and raster geospatial data.
- Edit vector data directly on interactive maps.
- Search for open geospatial datasets and incorporate them into your maps.

+++

## Install leafmap

To install Leafmap, uncomment the following line and run the cell.

```{code-cell} ipython3
# %pip install -U leafmap
```

## Import libraries

To get started, import the necessary libraries.

```{code-cell} ipython3
import leafmap
```

Leafmap supports multiple plotting backends, including `folium`, `ipyleaflet`, `maplibre`, `bokeh`, `pydeck`, `keplergl`, and `plotly`. The default plotting backend is `ipyleaflet`, offering the most extensive features.

To switch the plotting backend, uncomment one of the following lines and run the cell:

```{code-cell} ipython3
# import leafmap.foliumap as leafmap
# import leafmap.bokehmap as leafmap
# import leafmap.maplibregl as leafmap
# import leafmap.deck as leafmap
# import leafmap.kepler as leafmap
# import leafmap.plotlymap as leafmap
```

## Creating interactive maps

Leafmap provides a high-level, Pythonic interface for creating interactive maps. You can create a basic interactive map by calling the `Map` function. The default basemap is `OpenStreetMap`.

```{code-cell} ipython3
m = leafmap.Map()
m
```

### Customizing the Map

You can customize the map's center, zoom level, and height. The `center` takes a tuple of latitude and longitude, `zoom` is an integer, and `height` specifies the map height in pixels. The example below centers the map on the U.S. with a zoom level of 4 and a height of 600 pixels:

```{code-cell} ipython3
m = leafmap.Map(center=(40, -100), zoom=4, height="600px")
m
```

### Adding or Removing Controls

By default, the map includes controls such as zoom, fullscreen, scale, attribution, and toolbar. You can toggle these controls using parameters like `zoom_control`, `fullscreen_control`, `scale_control`, `attribution_control`, and `toolbar_control` parameters to `True` or `False`. The example below disables all controls:

```{code-cell} ipython3
m = leafmap.Map(
    zoom_control=False,
    draw_control=False,
    scale_control=False,
    fullscreen_control=False,
    attribution_control=False,
    toolbar_control=False,
)
m
```

To add a search control to the map, use the `m.add_search_control()` method. The search control allows users to search for places and zoom to them. The example below adds a search control to the map:

```{code-cell} ipython3
url = "https://nominatim.openstreetmap.org/search?format=json&q={s}"
m.add_search_control(url, zoom=10, position="topleft")
```

### Working with Layers

You can access the layers on the map using the `layers` attribute:

```{code-cell} ipython3
m.layers
```

To add or remove layers, use the `add` and `remove` methods. For example, to remove the last layer:

```{code-cell} ipython3
m.remove(m.layers[-1])
```

### Clearing Controls and Layers

You can clear all controls and layers from the map with `clear_controls` and `clear_layers` methods. First, create a map:

```{code-cell} ipython3
m = leafmap.Map()
m
```

Then, remove all controls:

```{code-cell} ipython3
m.clear_controls()
```

And clear all layers:

```{code-cell} ipython3
m.clear_layers()
```

## Changing Basemaps

You can easily change the basemap of a map. For example, the following code adds the `OpenTopoMap` basemap:

```{code-cell} ipython3
m = leafmap.Map()
m.add_basemap("OpenTopoMap")
m
```

To change basemap interactively, add the `basemap` control to the map with the `add_basemap_gui()` method:

```{code-cell} ipython3
m = leafmap.Map()
m.add_basemap_gui()
m
```

### Adding an XYZ Tile Layer

To add custom XYZ tile layers, you can use the `add_tile_layer()` method. The example below adds a Google Satellite layer using an XYZ URL template:

```{code-cell} ipython3
m = leafmap.Map()
m.add_tile_layer(
    url="https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}",
    name="Google Satellite",
    attribution="Google",
)
m
```

### Adding a WMS Tile Layer

Web Map Service (WMS) layers can be added using the `add_wms_layer()` method. The following code adds a WMS layer of NAIP Imagery from the USGS, centered on the U.S. with a zoom level of 4:

```{code-cell} ipython3
m = leafmap.Map(center=[40, -100], zoom=4)
url = "https://imagery.nationalmap.gov/arcgis/services/USGSNAIPImagery/ImageServer/WMSServer?"
m.add_wms_layer(
    url=url,
    layers="USGSNAIPImagery:FalseColorComposite",
    name="NAIP",
    attribution="USGS",
    format="image/png",
    shown=True,
)
m
```

### Adding a Legend to a Map

To provide better context for the data layers, you can add a legend to your map. In this example, we add a WMS layer displaying the 2021 NLCD land cover data and a corresponding legend to explain the land cover types:

```{code-cell} ipython3
m = leafmap.Map(center=[40, -100], zoom=4)
m.add_basemap("Esri.WorldImagery")
url = "https://www.mrlc.gov/geoserver/mrlc_display/NLCD_2021_Land_Cover_L48/wms?"
m.add_wms_layer(
    url=url,
    layers="NLCD_2021_Land_Cover_L48",
    name="NLCD 2021",
    attribution="MRLC",
    format="image/png",
    shown=True,
)
m.add_legend(title="NLCD Land Cover Type", builtin_legend="NLCD")
m
```

### Adding a Colorbar to Visualize Data

If you need to visualize continuous data like elevation, you can add a colorbar to the map. The example below shows how to add a colorbar with a terrain colormap for elevation, ranging from 0 to 4000 meters:

```{code-cell} ipython3
m = leafmap.Map()
m.add_basemap("OpenTopoMap")
m.add_colormap(
    "terrain",
    label="Elevation",
    orientation="horizontal",
    vmin=0,
    vmax=4000,
)
m
```

Each of these sections demonstrates different features of the Leafmap library, allowing you to customize maps by adding basemaps, XYZ tiles, WMS layers, legends, and colorbars to enhance map visualization.

+++

## Visualizing Vector Data

Leafmap makes it easy to visualize various vector data formats such as GeoJSON, Shapefile, GeoPackage, and others supported by [GeoPandas](https://geopandas.org). The following examples demonstrate different ways to add vector data to your map.


### Adding a Marker

You can add individual markers to the map at specific locations. In this example, a draggable marker is placed at the given latitude and longitude.

```{code-cell} ipython3
m = leafmap.Map()
location = [40, -100]
m.add_marker(location, draggable=True)
m
```

### Adding Multiple Markers

To add multiple markers at once, use the `add_markers()` method. This example places markers at three different locations:

```{code-cell} ipython3
m = leafmap.Map()
m.add_markers(markers=[[40, -100], [45, -110], [50, -120]])
m
```

### Adding Marker Clusters

For a large number of points, you can group them into clusters. This method reduces map clutter by aggregating nearby points. The example below uses a CSV file of world cities to create marker clusters:

```{code-cell} ipython3
m = leafmap.Map()
url = "https://github.com/opengeos/datasets/releases/download/world/world_cities.csv"
m.add_marker_cluster(url, x="longitude", y="latitude", layer_name="World cities")
m
```

### Customizing Markers

Markers can be customized with colors, icons, and labels. The following example customizes points from a CSV file of U.S. cities, using different icons and adding a legend:

```{code-cell} ipython3
m = leafmap.Map(center=[40, -100], zoom=4)
cities = "https://github.com/opengeos/datasets/releases/download/us/cities.csv"
regions = "https://github.com/opengeos/datasets/releases/download/us/us_regions.geojson"
m.add_geojson(regions, layer_name="US Regions")
m.add_points_from_xy(
    cities,
    x="longitude",
    y="latitude",
    color_column="region",
    icon_names=["gear", "map", "leaf", "globe"],
    spin=True,
    add_legend=True,
)
m
```

### Visualizing Polylines

Polyline visualization is useful for displaying linear features such as roads or pipelines. In this example, a GeoJSON file containing submarine cable lines is added to the map:

```{code-cell} ipython3
m = leafmap.Map(center=[20, 0], zoom=2)
data = "https://github.com/opengeos/datasets/releases/download/vector/cables.geojson"
m.add_vector(data, layer_name="Cable lines", info_mode="on_hover")
m
```

#### Customizing Polyline Styles

You can further customize polylines with a style callback function. This example dynamically changes the color and weight of each polyline based on its properties:

```{code-cell} ipython3
m = leafmap.Map(center=[20, 0], zoom=2)
m.add_basemap("CartoDB.DarkMatter")
data = "https://github.com/opengeos/datasets/releases/download/vector/cables.geojson"
callback = lambda feat: {"color": feat["properties"]["color"], "weight": 1}
m.add_vector(data, layer_name="Cable lines", style_callback=callback)
m
```

### Visualizing Polygons

To visualize polygon features, you can use the `add_vector()` method. In this example, a GeoJSON file of New York City buildings is added and the map automatically zooms to the layer's extent:

```{code-cell} ipython3
m = leafmap.Map()
url = "https://github.com/opengeos/datasets/releases/download/places/nyc_buildings.geojson"
m.add_vector(url, layer_name="NYC Buildings", zoom_to_layer=True)
m
```

### Visualizing GeoPandas GeoDataFrames

You can directly visualize GeoPandas GeoDataFrames on the map. In this example, a GeoDataFrame containing building footprints from Las Vegas is displayed with custom styling:

```{code-cell} ipython3
import geopandas as gpd
```

```{code-cell} ipython3
url = "https://github.com/opengeos/datasets/releases/download/places/las_vegas_buildings.geojson"
gdf = gpd.read_file(url)
gdf.head()
```

You can use the GeoDataFrame.explore() method to visualize the data interactively, which utilizes the folium library. The example below displays the building footprints interactively:

```{code-cell} ipython3
gdf.explore()
```

To display the GeoDataFrame using Leaflet, use the `add_gdf()` method. The following code adds the building footprints to the map:

```{code-cell} ipython3
m = leafmap.Map()
m.add_basemap("HYBRID")
style = {"color": "red", "fillColor": "red", "fillOpacity": 0.1, "weight": 2}
m.add_gdf(gdf, style=style, layer_name="Las Vegas Buildings", zoom_to_layer=True)
m
```

## Creating Choropleth Maps

Choropleth maps are useful for visualizing data distributions. The add_data() method allows you to create choropleth maps from various vector formats. Below is an example that visualizes population data using the "Quantiles" classification scheme:

```{code-cell} ipython3
m = leafmap.Map()
data = "https://raw.githubusercontent.com/opengeos/leafmap/master/docs/data/countries.geojson"
m.add_data(
    data, column="POP_EST", scheme="Quantiles", cmap="Blues", legend_title="Population"
)
m
```

You can also use different classification schemes like "EqualInterval" for different data visualizations:

```{code-cell} ipython3
m = leafmap.Map()
m.add_data(
    data,
    column="POP_EST",
    scheme="EqualInterval",
    cmap="Blues",
    legend_title="Population",
)
m
```

## Visualizing GeoParquet Data

[GeoParquet](https://geoparquet.org) is a columnar format for geospatial data that allows efficient storage and retrieval. The following example demonstrates how to download, read, and visualize GeoParquet files using GeoPandas and Leafmap.

### Loading and Visualizing Point Data

First, import the necessary libraries:

```{code-cell} ipython3
import geopandas as gpd
```

Download and load a GeoParquet file containing city data:

```{code-cell} ipython3
url = "https://open.gishub.org/data/duckdb/cities.parquet"
filename = "cities.parquet"
leafmap.download_file(url, filename, quiet=True)
```

Read the GeoParquet file into a GeoDataFrame and preview the first few rows:

```{code-cell} ipython3
gdf = gpd.read_parquet(filename)
gdf.head()
```

You can use `GeoDataFrame.explore()` to visualize the data interactively:

```{code-cell} ipython3
gdf.explore()
```

Alternatively, you can add the data to a Leafmap interactive map and plot the points by specifying their latitude and longitude:

```{code-cell} ipython3
m = leafmap.Map()
m.add_points_from_xy(gdf, x="longitude", y="latitude")
m
```

### Visualizing Polygon Data

For polygon data, such as wetlands, you can follow a similar process. Start by downloading the GeoParquet file containing wetland polygons:

```{code-cell} ipython3
url = "https://data.source.coop/giswqs/nwi/wetlands/DC_Wetlands.parquet"
filename = "DC_Wetlands.parquet"
leafmap.download_file(url, filename, quiet=True)
```

Load the data into a GeoDataFrame and check its coordinate reference system (CRS):

```{code-cell} ipython3
gdf = gpd.read_parquet(filename)
gdf.head()
```

```{code-cell} ipython3
gdf.crs
```

You can visualize the polygon data directly using `explore()` with folium:

```{code-cell} ipython3
gdf.explore()
```

For visualization with Leafmap, use the following code to add the polygons to the map with the "Satellite" basemap:

```{code-cell} ipython3
m = leafmap.Map()
m.add_basemap("Satellite")
m.add_nwi(gdf, col_name="WETLAND_TYPE", zoom_to_layer=True)
m
```

## Visualizing PMTiles

[PMTiles](https://github.com/protomaps/PMTiles) is a single-file archive format for tiled data that enables efficient, serverless map applications. PMTiles archives can be hosted on platforms like S3 and allow low-cost, scalable map hosting without the need for custom servers.

### Retrieving Metadata from PMTiles

To visualize PMTiles data, first retrieve metadata such as available layers and bounds. Here’s an example using a PMTiles archive of Florence, Italy:

```{code-cell} ipython3
url = "https://open.gishub.org/data/pmtiles/protomaps_firenze.pmtiles"
metadata = leafmap.pmtiles_metadata(url)
print(f"layer names: {metadata['layer_names']}")
print(f"bounds: {metadata['bounds']}")
```

### Visualizing PMTiles Data

You can add PMTiles layers to a Leafmap map by specifying the tile source and defining a custom style. The style specifies how different vector layers, such as buildings and roads, should be rendered:

```{code-cell} ipython3
m = leafmap.Map()

style = {
    "version": 8,
    "sources": {
        "example_source": {
            "type": "vector",
            "url": "pmtiles://" + url,
            "attribution": "PMTiles",
        }
    },
    "layers": [
        {
            "id": "buildings",
            "source": "example_source",
            "source-layer": "landuse",
            "type": "fill",
            "paint": {"fill-color": "steelblue"},
        },
        {
            "id": "roads",
            "source": "example_source",
            "source-layer": "roads",
            "type": "line",
            "paint": {"line-color": "black"},
        },
    ],
}

# style = leafmap.pmtiles_style(url)  # Use default style

m.add_pmtiles(
    url, name="PMTiles", style=style, overlay=True, show=True, zoom_to_layer=True
)
m
```

### Visualizing Open Buildings Data with PMTiles

You can also visualize large datasets like the [Google-Microsoft Open Buildings data](https://beta.source.coop/repositories/vida/google-microsoft-open-buildings/description) hosted on Source Cooperative. First, check the PMTiles metadata for the building footprints layer:

```{code-cell} ipython3
url = "https://data.source.coop/vida/google-microsoft-open-buildings/pmtiles/go_ms_building_footprints.pmtiles"
metadata = leafmap.pmtiles_metadata(url)
print(f"layer names: {metadata['layer_names']}")
print(f"bounds: {metadata['bounds']}")
```

Now, visualize the building footprints using a custom style for the fill color and opacity:

```{code-cell} ipython3
m = leafmap.Map(center=[20, 0], zoom=2)
m.add_basemap("CartoDB.DarkMatter")
m.add_basemap("Esri.WorldImagery", show=False)

style = {
    "version": 8,
    "sources": {
        "example_source": {
            "type": "vector",
            "url": "pmtiles://" + url,
            "attribution": "PMTiles",
        }
    },
    "layers": [
        {
            "id": "buildings",
            "source": "example_source",
            "source-layer": "building_footprints",
            "type": "fill",
            "paint": {"fill-color": "#3388ff", "fill-opacity": 0.5},
        },
    ],
}

m.add_pmtiles(
    url, name="Buildings", style=style, overlay=True, show=True, zoom_to_layer=False
)

m
```

### Visualizing Overture Maps Data

[Overture](https://overturemaps.org) Maps Foundation provides open-source, high-quality basemaps for web mapping applications. You can visualize Overture Maps data using PMTiles archives. The following example demonstrates how to visualize the building footprints layer from the Overture Maps. For more information, visit the [Overture Maps website](https://docs.overturemaps.org).

```{code-cell} ipython3
release = "2024-09-18"
theme = "buildings"
url = f"https://overturemaps-tiles-us-west-2-beta.s3.amazonaws.com/{release}/{theme}.pmtiles"
```

```{code-cell} ipython3
style = {
    "version": 8,
    "sources": {
        "example_source": {
            "type": "vector",
            "url": "pmtiles://" + url,
            "attribution": "PMTiles",
        }
    },
    "layers": [
        {
            "id": "Building",
            "source": "example_source",
            "source-layer": "building",
            "type": "fill",
            "paint": {
                "fill-color": "#ffff00",
                "fill-opacity": 0.4,
                "fill-outline-color": "#ff0000",
            },
        },
    ],
}
```

```{code-cell} ipython3
m = leafmap.Map(center=[47.65350739, -117.59664999], zoom=16)
m.add_basemap("Satellite")
m.add_pmtiles(url, style=style, layer_name="Buildings", zoom_to_layer=False)
m
```

## Visualizing Raster Data

Leafmap supports various raster data formats, including GeoTIFF, Cloud Optimized GeoTIFF (COG), SpatioTemporal Asset Catalog (STAC), and others. This section demonstrates how to visualize raster data using Leafmap.

### Visualizing Cloud Optimized GeoTIFFs (COGs)

A Cloud Optimized GeoTIFF ([COG](https://cogeo.org/)) is a regular GeoTIFF file, aimed at being hosted on a HTTP file server, with an internal organization that enables more efficient workflows on the cloud. It does this by leveraging the ability of clients issuing ​HTTP GET range requests to ask for just the parts of a file they need.

#### Adding a Cloud Optimized GeoTIFF (COG)

You can load remote COGs directly from a URL. In this example, we load pre-event imagery of the 2020 California fire:

```{code-cell} ipython3
m = leafmap.Map(center=[39.494897, -108.507278], zoom=10)
url = "https://opendata.digitalglobe.com/events/california-fire-2020/pre-event/2018-02-16/pine-gulch-fire20/1030010076004E00.tif"
m.add_cog_layer(url, name="Fire (pre-event)")
m
```

Under the hood, the `add_cog_layer()` method uses the [TiTiler](https://developmentseed.org/titiler) demo endpoint (https://titiler.xyz) to serve COGs as map tiles. The method also supports custom styling and visualization parameters. Please refer to the [TiTiler documentation](https://developmentseed.org/titiler/endpoints/cog/#api) for more information.

Please note that the `add_cog_layer()` method requires an internet connection to fetch the COG tiles from the TiTiler endpoint. If you need to work offline, you can download the COG and load it as a local GeoTIFF file using the `add_raster()` method covered in the next section.

+++

To show the image metadata, use the `cog_info()` method:

```{code-cell} ipython3
leafmap.cog_info(url)
```

To check the available bands, use the `cog_bands()` method:

```{code-cell} ipython3
leafmap.cog_bands(url)
```

To get the band statistics, use the `cog_stats()` method:

```{code-cell} ipython3
stats = leafmap.cog_stats(url)
# stats
```

#### Adding Multiple COGs

You can visualize and compare multiple COGs by adding them to the same map. Below, we add post-event imagery to the map:

```{code-cell} ipython3
url2 = "https://opendata.digitalglobe.com/events/california-fire-2020/post-event/2020-08-14/pine-gulch-fire20/10300100AAC8DD00.tif"
m.add_cog_layer(url2, name="Fire (post-event)")
m
```

#### Creating a Split Map for Comparison

Leafmap also provides a convenient way to compare two COGs side by side using a split map. In this example, we create a map comparing pre-event and post-event fire imagery:

```{code-cell} ipython3
m = leafmap.Map(center=[39.494897, -108.507278], zoom=10)
m.split_map(
    left_layer=url, right_layer=url2, left_label="Pre-event", right_label="Post-event"
)
m
```

Here is another example comparing two COGs using a split map:

```{code-cell} ipython3
m = leafmap.Map(center=[47.653149, -117.59825], zoom=16)
m.add_basemap("Satellite")
image1 = "https://github.com/opengeos/datasets/releases/download/places/wa_building_image.tif"
image2 = "https://github.com/opengeos/datasets/releases/download/places/wa_building_masks.tif"
m.split_map(
    image2,
    image1,
    left_label="Building Masks",
    right_label="Aerial Imagery",
    left_args={"colormap_name": "tab20", "nodata": 0, "opacity": 0.7},
)
m
```

#### Using a Custom Colormap

You can apply a custom colormap to raster data for better visualization. The example below shows how to visualize the [US National Land Cover Database (NLCD)](https://www.mrlc.gov/data/nlcd-2021-land-cover-conus) data with a custom colormap:

```{code-cell} ipython3
url = "https://github.com/opengeos/datasets/releases/download/raster/nlcd_2021_land_cover_30m.tif"
colormap = {
    "11": "#466b9f",
    "12": "#d1def8",
    "21": "#dec5c5",
    "22": "#d99282",
    "23": "#eb0000",
    "24": "#ab0000",
    "31": "#b3ac9f",
    "41": "#68ab5f",
    "42": "#1c5f2c",
    "43": "#b5c58f",
    "51": "#af963c",
    "52": "#ccb879",
    "71": "#dfdfc2",
    "72": "#d1d182",
    "73": "#a3cc51",
    "74": "#82ba9e",
    "81": "#dcd939",
    "82": "#ab6c28",
    "90": "#b8d9eb",
    "95": "#6c9fb8",
}
m = leafmap.Map(center=[40, -100], zoom=4, height="650px")
m.add_basemap("Satellite")
m.add_cog_layer(url, colormap=colormap, name="NLCD Land Cover", nodata=0)
m.add_legend(title="NLCD Land Cover Type", builtin_legend="NLCD")
m.add_layer_manager()
m
```

### Visualizing Local Raster Datasets

Leafmap supports visualizing local GeoTIFF datasets as well. In this example, we download a sample Digital Elevation Model (DEM) dataset and visualize it.

#### Downloading and Visualizing a Local Raster

Start by downloading a sample DEM GeoTIFF file:

```{code-cell} ipython3
dem_url = "https://github.com/opengeos/datasets/releases/download/raster/dem_90m.tif"
filename = "dem_90m.tif"
leafmap.download_file(dem_url, filename, quiet=True)
```

Next, visualize the raster using the `add_raster()` method with a "terrain" colormap to highlight elevation differences:

```{code-cell} ipython3
m = leafmap.Map()
m.add_raster(filename, colormap="terrain", layer_name="DEM")
m
```

You can also check the minimum and maximum values of the raster:

```{code-cell} ipython3
leafmap.image_min_max(filename)
```

Optionally, add a colormap legend to indicate the range of elevation values:

```{code-cell} ipython3
m.add_colormap(cmap="terrain", vmin=15, vmax=4338, label="Elevation (m)")
```

Keep in mind that the `add_raster()` method works for both local and remote GeoTIFF files. You can use it to visualize COGs available online or local GeoTIFF files stored on your computer. The example below demonstrates how to visualize the same COG from the previous section as a remote file:

```{code-cell} ipython3
m = leafmap.Map()
m.add_raster(dem_url, colormap="terrain", layer_name="DEM")
m
```

You can also use a custom colormap to visualize the COG by providing a list of colors as the `colormap` parameter:

```{code-cell} ipython3
m = leafmap.Map()
m.add_raster(dem_url, colormap=["blue", "green", "white"], layer_name="DEM")
m
```

#### Visualizing a Multi-Band Raster

Multi-band rasters, such as satellite images, can also be visualized. The following example loads a multi-band Landsat image and displays it as an RGB composite:

```{code-cell} ipython3
landsat_url = "https://github.com/opengeos/datasets/releases/download/raster/cog.tif"
filename = "cog.tif"
leafmap.download_file(landsat_url, filename, quiet=True)
```

```{code-cell} ipython3
m = leafmap.Map()
m.add_raster(filename, indexes=[4, 3, 2], layer_name="RGB")
m
```

#### Inspecting Pixel Values

To inspect pixel values interactively, use the `m.add("inspector")` method to add an inspector control to the map. The inspector control displays pixel values when you click on the map:

```{code-cell} ipython3
m = leafmap.Map(center=[53.407089, 6.875480], zoom=13)
m.add_raster(filename, indexes=[4, 3, 2], layer_name="RGB")
m.add("inspector")
m
```

### Visualizing SpatioTemporal Asset Catalog (STAC) Data


The [STAC specification](https://stacspec.org) provides a standardized way to describe geospatial information, enabling easier discovery and use. In this section, we will visualize STAC data using Leafmap.

#### Exploring STAC Bands
To begin, retrieve the available bands for a STAC item. This example uses the [SPOT Orthoimages of Canada](https://stacindex.org/catalogs/spot-orthoimages-canada-2005):

```{code-cell} ipython3
url = "https://canada-spot-ortho.s3.amazonaws.com/canada_spot_orthoimages/canada_spot5_orthoimages/S5_2007/S5_11055_6057_20070622/S5_11055_6057_20070622.json"
leafmap.stac_bands(url)
```

#### Adding STAC Layers to the Map

Once you have explored the available bands, you can add them to your map. In this example, we visualize both the panchromatic band and false-color composite of the SPOT Orthoimage:

```{code-cell} ipython3
m = leafmap.Map(center=[60.95410, -110.90184], zoom=10)
m.add_stac_layer(url, bands=["pan"], name="Panchromatic")
m.add_stac_layer(url, bands=["B3", "B2", "B1"], name="False color")
m
```

#### Using a Custom STAC Catalog

You can integrate custom STAC API endpoints into your map. Simply provide a dictionary of STAC endpoints, where the keys are names and the values are the API URLs. This example demonstrates how to add custom STAC catalogs:

```{code-cell} ipython3
catalogs = {
    "Element84 Earth Search": "https://earth-search.aws.element84.com/v1",
    "Microsoft Planetary Computer": "https://planetarycomputer.microsoft.com/api/stac/v1",
}
```

After setting up the catalog source, you can search and display items from the selected STAC collections using a GUI:

```{code-cell} ipython3
m = leafmap.Map(center=[40, -100], zoom=4)
m.set_catalog_source(catalogs)
m.add_stac_gui()
m
```

Once the catalog panel is open, you can search for items from the custom STAC API endpoints. Simply draw a bounding box on the map or zoom to a location of interest. Click on the **Collections** button to retrieve the collections from the custom STAC API endpoints. Next, select a collection from the dropdown menu. Then, click on the **Items** button to retrieve the items from the selected collection. Finally, click on the **Display** button to add the selected item to the map.

+++

![](https://i.imgur.com/M8IbRsM.png)

```{code-cell} ipython3
# m.stac_gdf  # The GeoDataFrame of the STAC search results
```

```{code-cell} ipython3
# m.stac_dict  # The STAC search results as a dictionary
```

```{code-cell} ipython3
# m.stac_item  # The selected STAC item of the search result
```

### AWS S3 Integration

Leafmap allows you to visualize raster datasets stored in AWS S3. In this example, we work with datasets from [Maxar Open Data Program on AWS](https://registry.opendata.aws/maxar-open-data/).

#### Accessing Datasets in an S3 Bucket

To list and access datasets stored in S3, you need to set up AWS credentials as environment variables. Uncomment the following lines and provide your credentials:

```{code-cell} ipython3
import os
```

```{code-cell} ipython3
# os.environ["AWS_ACCESS_KEY_ID"] = "YOUR AWS ACCESS ID HERE"
# os.environ["AWS_SECRET_ACCESS_KEY"] = "YOUR AWS ACCESS KEY HERE"
```

Once the credentials are set, list the datasets in the bucket:

```{code-cell} ipython3
BUCKET = "maxar-opendata"
FOLDER = "events/Kahramanmaras-turkey-earthquake-23/"
items = leafmap.s3_list_objects(BUCKET, FOLDER, ext=".tif")
items[:10]
```

#### Visualizing a Raster Dataset from S3

Finally, visualize a raster dataset from the S3 bucket by adding it to the map:

```{code-cell} ipython3
m = leafmap.Map(center=[37.045802, 35.333319], zoom=14)
m.add_cog_layer(items[2], name="Maxar")
m
```

![](https://i.imgur.com/NkTZ6Lj.png)

+++

Some S3 buckets may require additional permissions to access the data. For example, for requester pays buckets, you need to set the environment variable `AWS_REQUEST_PAYER` to `requester`:

```{code-cell} ipython3
os.environ["AWS_REQUEST_PAYER"] = "requester"
```

The example below shows how to visualize a [NAIP imagery](https://registry.opendata.aws/naip/) from a requester pays bucket:

```{code-cell} ipython3
m = leafmap.Map(center=[34.979166, -84.920496], zoom=14)
m.add_basemap("Satellite")
src = "s3://naip-analytic/tn/2021/60cm/rgbir_cog/34084/m_3408401_ne_16_060_20210404.tif"
m.add_raster(src, layer_name="NAIP")
m
```

## Exercises

### Exercise 1: Creating an Interactive Map

1. Create an interactive map with search functionality that allows users to search for places and zoom to them. Disable the draw control on the map.

```{code-cell} ipython3

```

![image](https://github.com/user-attachments/assets/b930fb63-3bd1-4d7e-9bf8-87e6d398e5c3)

+++

### Exercise 2: Adding XYZ and WMS Tile Layers

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

### Exercise 3: Adding Map Legends

1. Add the [ESA World Cover](https://esa-worldcover.org/en) WMS tile layer to the map.
    - URL: `https://services.terrascope.be/wms/v2?`
    - Layer name: `WORLDCOVER_2021_MAP`
2. Add a legend to the map using the leafmap built-in `ESA_WorldCover` legend.

```{code-cell} ipython3

```

![image](https://github.com/user-attachments/assets/be5a9b07-4f6c-4245-9737-31db2df14f7f)

+++

### Exercise 4: Creating Marker Clusters

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

### Exercise 5: Visualizing Vector Data

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

### Exercise 6: Visualizing GeoParquet Data

1. Visualize GeoParquet data of US states:

    - URL: https://github.com/opengeos/datasets/releases/download/us/us_states.parquet
    - Style: Outline color of "red" with no fill.

```{code-cell} ipython3

```

![image](https://github.com/user-attachments/assets/b6d9ec09-035b-4df7-8ab7-a7b4588f1e71)

+++

### Exercise 7: Visualizing PMTiles

1. Visualize the Overture Maps building dataset using PMTiles:
    * URL: https://overturemaps-tiles-us-west-2-beta.s3.amazonaws.com/2024-09-18/buildings.pmtiles
    * Style: Blue fill with 0.4 opacity, red outline.

```{code-cell} ipython3

```

![image](https://github.com/user-attachments/assets/4ee08461-c962-4c37-8979-7105f588842a)

+++

### Exercise 8: Visualizing Cloud Optimized GeoTIFFs (COGs)

1. Visualize Digital Elevation Model (DEM) data using the following COG file:
    - URL: https://github.com/opengeos/datasets/releases/download/raster/dem.tif
    - Apply a terrain colormap to show elevation values.

```{code-cell} ipython3

```

![image](https://github.com/user-attachments/assets/21e1f7dd-466e-4880-94a5-0365bf1495dc)

+++

### Exercise 9: Visualizing Local Raster Data

1. Visualize the following raster datasets using the Map.add_raster() method:

    * Aerial Imagery: https://github.com/opengeos/datasets/releases/download/places/wa_building_image.tif
    * Building Footprints: https://github.com/opengeos/datasets/releases/download/places/wa_building_masks.tif (use the "tab20" colormap and opacity of 0.7)

```{code-cell} ipython3

```

![image](https://github.com/user-attachments/assets/faf7c345-6a3f-4ca0-8eca-7417e6568867)

+++

### Exercise 10: Creating a Split Map

1. Create a split map to compare imagery of Libya before and after the 2023 flood event:

    * Pre-event imagery: https://github.com/opengeos/datasets/releases/download/raster/Libya-2023-07-01.tif
    * Post-event imagery: https://github.com/opengeos/datasets/releases/download/raster/Libya-2023-09-13.tif

```{code-cell} ipython3

```

![image](https://github.com/user-attachments/assets/8cab4f1c-2dba-4652-a644-3ce6be4bbbd2)

## Summary

This chapter has introduced **Leafmap**, a versatile Python library for creating, managing, and analyzing interactive geospatial maps. It covers essential tools for GIS programming, allowing for streamlined workflows in handling spatial data. Leafmap’s integration with Jupyter environments enables users to visualize and analyze geospatial data with minimal code.

Key takeaways from this chapter include:

1. **Setting Up Leafmap**: Instructions for installing and importing Leafmap, alongside switching between supported plotting backends.
2. **Interactive Map Customization**: Techniques to create and customize maps, add various basemaps, and control map elements like zoom, scale, and toolbar settings.
3. **Data Layer Management**: Methods for adding/removing layers, customizing basemaps, and incorporating layers like WMS and XYZ tiles for expanded data visualization.
4. **Vector and Raster Data Visualization**: Examples on adding vector data (points, lines, polygons) from formats like GeoJSON and GeoParquet and visualizing raster formats like GeoTIFF, COG, and STAC.
5. **Advanced Data Interactions**: How to use specialized formats and datasets, such as PMTiles, Open Buildings data, and STAC API catalogs, and AWS S3 data integration for remote geospatial data.

This chapter provides the foundational knowledge to effectively use Leafmap in GIS projects, making it an invaluable tool for visualizing and analyzing diverse geospatial datasets within Python.
