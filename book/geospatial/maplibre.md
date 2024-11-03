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

# MapLibre

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/geospatial/maplibre.ipynb)

## Overview

This lecture introduces the [MapLibre](https://github.com/eodaGmbH/py-maplibregl) mapping backend in the Leafmap library—a powerful open-source Python tool for creating customizable 2D and 3D interactive maps. With MapLibre, GIS professionals can develop tailored visualizations that enhance data presentation and geospatial analysis. The provided Jupyter notebook demonstrates foundational skills, including interactive map creation, basemap customization, and data layer integration. Additionally, advanced features such as 3D building visualizations and dynamic map controls equip students with practical skills for effective geospatial data visualization and analysis.

## Learning Outcomes

By the end of this lecture, students will be able to:

1. **Set up and install MapLibre** for Python-based geospatial visualization.
2. **Create interactive maps** and apply various basemap styles.
3. **Customize map elements**, including markers, lines, polygons, and interactive controls.
4. **Explore advanced features** like 3D building models and choropleth maps.
5. **Integrate and manage multiple data layers**, such as GeoJSON, raster, and vector formats.
6. **Export interactive maps** as standalone HTML files for easy sharing and web deployment.

## Useful Resources

- [MapLibre GL JS Documentation](https://maplibre.org/maplibre-gl-js/docs): Comprehensive documentation for MapLibre GL JS.
- [MapLibre Python Bindings](https://github.com/eoda-dev/py-maplibregl): Information on using MapLibre with Python.
- [MapLibre in Leafmap](https://leafmap.org/maplibre/overview): Examples and tutorials for MapLibre in Leafmap.
- [Video Tutorials](https://bit.ly/maplibre): Video guides for practical MapLibre skills.
- [MapLibre Demos](https://maps.gishub.org): Interactive demos showcasing MapLibre’s capabilities.


## Installation and Setup

To install the required packages, uncomment and run the line below.

```{code-cell} ipython3
# %pip install -U "leafmap[maplibre]"
```

Once installed, import the `maplibregl` backend from the `leafmap` package:

```{code-cell} ipython3
import leafmap.maplibregl as leafmap
```

## Creating Interactive Maps

### Basic Map Setup

Let’s start by creating a simple interactive map with default settings. This basic setup provides simple map with the `dark-matter` style on which you can add data layers, controls, and other customizations.

```{code-cell} ipython3
m = leafmap.Map()
m
```

### Customizing the Map's Center and Zoom Level

You can specify the map’s center (latitude and longitude), zoom level, pitch, and bearing for a more focused view. These parameters help direct the user's attention to specific areas.

```{code-cell} ipython3
m = leafmap.Map(center=[-100, 40], zoom=3, pitch=0, bearing=0)
m
```

Hold down the `Ctrl` key. Click and drag to pan the map.

+++

### Choosing a Basemap Style

MapLibre supports several pre-defined basemap styles such as `dark-matter`, `positron`, `voyager`, `liberty`, `demotiles`. You can also use custom basemap URLs for unique styling.

```{code-cell} ipython3
m = leafmap.Map(style="positron")
m
```

[OpenFreeMap](https://openfreemap.org) provides a variety of basemap styles that you can use in your interactive maps. These styles include `liberty`, `bright`, and `positron`.

```{code-cell} ipython3
m = leafmap.Map(style="liberty")
m
```

### Adding Background Colors

Background color styles, such as `background-lightgray` and `background-green`, are helpful for simple or thematic maps where color-coding is needed.

```{code-cell} ipython3
m = leafmap.Map(style="background-lightgray")
m
```

Alternatively, you can provide a URL to a vector style.

```{code-cell} ipython3
style = "https://demotiles.maplibre.org/style.json"
m = leafmap.Map(style=style)
m
```

## Adding Map Controls

Map controls enhance the usability of the map by allowing users to interact in various ways, adding elements like scale bars, zoom tools, and drawing options.

### Available Controls

- **Geolocate**: Centers the map based on the user’s current location, if available.
- **Fullscreen**: Expands the map to a full-screen view for better focus.
- **Navigation**: Provides zoom controls and a compass for reorientation.
- **Draw**: Allows users to draw and edit shapes on the map.

### Adding Geolocate Control

The Geolocate control centers the map based on the user’s current location, a helpful feature for location-based applications.

```{code-cell} ipython3
m = leafmap.Map()
m.add_control("geolocate", position="top-left")
m
```

### Adding Fullscreen Control

Fullscreen control enables users to expand the map to full screen, enhancing focus and visual clarity. This is especially useful when viewing complex or large datasets.

```{code-cell} ipython3
m = leafmap.Map(center=[11.255, 43.77], zoom=13, style="positron", controls={})
m.add_control("fullscreen", position="top-right")
m
```

### Adding Navigation Control

The Navigation control provides buttons for zooming and reorienting the map, improving the user's ability to navigate efficiently.

```{code-cell} ipython3
m = leafmap.Map(center=[11.255, 43.77], zoom=13, style="positron", controls={})
m.add_control("navigation", position="top-left")
m
```

### Adding Draw Control

The Draw control enables users to interact with the map by adding shapes such as points, lines, and polygons. This control is essential for tasks requiring spatial data input directly on the map.

```{code-cell} ipython3
m = leafmap.Map(center=[-100, 40], zoom=3, style="positron")
m.add_draw_control(position="top-left")
m
```

You can configure the Draw control to activate specific tools, like polygon, line, or point drawing, while also enabling or disabling a "trash" button to remove unwanted shapes.

```{code-cell} ipython3
from maplibre.plugins import MapboxDrawControls, MapboxDrawOptions
```

```{code-cell} ipython3
m = leafmap.Map(center=[-100, 40], zoom=3, style="positron")
draw_options = MapboxDrawOptions(
    display_controls_default=False,
    controls=MapboxDrawControls(polygon=True, line_string=True, point=True, trash=True),
)
m.add_draw_control(draw_options)
m
```

Additionally, you can load a GeoJSON FeatureCollection into the Draw control, which will allow users to view, edit, or interact with pre-defined geographical features, such as boundaries or points of interest.

```{code-cell} ipython3
m = leafmap.Map(center=[-100, 40], zoom=3, style="positron")
geojson = {
    "type": "FeatureCollection",
    "features": [
        {
            "id": "abc",
            "type": "Feature",
            "properties": {},
            "geometry": {
                "coordinates": [
                    [
                        [-119.08, 45.95],
                        [-119.79, 42.08],
                        [-107.28, 41.43],
                        [-108.15, 46.44],
                        [-119.08, 45.95],
                    ]
                ],
                "type": "Polygon",
            },
        },
        {
            "id": "xyz",
            "type": "Feature",
            "properties": {},
            "geometry": {
                "coordinates": [
                    [
                        [-103.87, 38.08],
                        [-108.54, 36.44],
                        [-106.25, 33.00],
                        [-99.91, 31.79],
                        [-96.82, 35.48],
                        [-98.80, 37.77],
                        [-103.87, 38.08],
                    ]
                ],
                "type": "Polygon",
            },
        },
    ],
}
m.add_draw_control(position="top-left", geojson=geojson)
m
```

![](https://i.imgur.com/w8UFssd.png)

+++

Two key methods for accessing drawn features:

- **Selected Features**: Accesses only the currently selected features.
- **All Features**: Accesses all features added, regardless of selection, giving you full control over the spatial data on the map.

```{code-cell} ipython3
m.draw_features_selected
```

```{code-cell} ipython3
m.draw_feature_collection_all
```

## Adding Layers

Adding layers to a map enhances the data it presents, allowing different types of basemaps, tile layers, and thematic overlays to be combined for in-depth analysis.

### Adding Basemaps

Basemaps provide a geographical context for the map. Using the `add_basemap` method, you can select from various basemaps, including `OpenTopoMap` and `Esri.WorldImagery`. Adding a layer control allows users to switch between multiple basemaps interactively.

```{code-cell} ipython3
m = leafmap.Map()
m.add_basemap("OpenTopoMap")
m.add_layer_control()
m
```

```{code-cell} ipython3
m.add_basemap("Esri.WorldImagery")
```

You can also add basemaps interactively, which provides flexibility for selecting the best background for your map content.

```{code-cell} ipython3
m = leafmap.Map()
m
```

```{code-cell} ipython3
m.add_basemap()
```

### Adding XYZ Tile Layer

XYZ tile layers allow integration of specific tile services like topographic, satellite, or other thematic imagery from XYZ tile servers. By specifying the URL and parameters such as `opacity` and `visibility`, XYZ layers can be customized and styled to fit the needs of your map.

```{code-cell} ipython3
m = leafmap.Map()
url = "https://basemap.nationalmap.gov/arcgis/rest/services/USGSTopo/MapServer/tile/{z}/{y}/{x}"
m.add_tile_layer(url, name="USGS TOpo", attribution="USGS", opacity=1.0, visible=True)
m
```

### Adding WMS Layer

Web Map Service (WMS) layers provide access to external datasets served by web servers, such as thematic maps or detailed satellite imagery. Adding a WMS layer involves specifying the WMS URL and layer names, which allows for overlaying various data types such as natural imagery or land cover classifications.

```{code-cell} ipython3
m = leafmap.Map(center=[-74.5447, 40.6892], zoom=8, style="liberty")
url = "https://img.nj.gov/imagerywms/Natural2015"
layers = "Natural2015"
m.add_wms_layer(url, layers=layers, before_id="aeroway_fill")
m.add_layer_control()
m
```

```{code-cell} ipython3
m = leafmap.Map(center=[-100.307965, 46.98692], zoom=13, pitch=45, style="liberty")
m.add_basemap("Esri.WorldImagery")
url = "https://fwspublicservices.wim.usgs.gov/wetlandsmapservice/services/Wetlands/MapServer/WMSServer"
m.add_wms_layer(url, layers="1", name="NWI", opacity=0.6)
m.add_layer_control()
m.add_legend(builtin_legend="NWI", title="Wetland Type")
m
```

### Adding Raster Tiles

Raster tiles provide a set of customized styles for map layers, such as watercolor or artistic styles, which can add unique visual elements. Configuring raster tile styles involves setting tile URLs, tile size, and attribution information. This setup provides access to a wide array of predefined designs, offering creative flexibility in how data is presented.

With raster tiles, you can control zoom limits and apply unique visual IDs to distinguish between multiple raster sources on the map.

```{code-cell} ipython3
style = {
    "version": 8,
    "sources": {
        "raster-tiles": {
            "type": "raster",
            "tiles": [
                "https://tiles.stadiamaps.com/tiles/stamen_watercolor/{z}/{x}/{y}.jpg"
            ],
            "tileSize": 256,
            "attribution": "Map tiles by Stamen Design; Hosting by Stadia Maps. Data © OpenStreetMap contributors",
        }
    },
    "layers": [
        {
            "id": "simple-tiles",
            "type": "raster",
            "source": "raster-tiles",
            "minzoom": 0,
            "maxzoom": 22,
        }
    ],
}
```

```{code-cell} ipython3
m = leafmap.Map(center=[-74.5, 40], zoom=2, style=style)
m
```

## MapTiler

To use MapTiler with this notebook, you need to set up a MapTiler API key. You can obtain a free API key by signing up at [https://cloud.maptiler.com/](https://cloud.maptiler.com).

```{code-cell} ipython3
# import os
# os.environ["MAPTILER_KEY"] = "YOUR_API_KEY"
```

Set the API key as an environment variable to access MapTiler's resources. Once set up, you can specify any named style from MapTiler by using the style parameter in the map setup.

![](https://i.imgur.com/dp2HxR2.png)

The following are examples of different styles available through MapTiler:

- **Streets style**: This style displays detailed street information and is suited for urban data visualization.
- **Satellite style**: Provides high-resolution satellite imagery for various locations.
- **Hybrid style**: Combines satellite imagery with labels for a clear geographic context.
- **Topo style**: A topographic map showing terrain details, ideal for outdoor-related applications.

```{code-cell} ipython3
m = leafmap.Map(style="streets")
m
```

```{code-cell} ipython3
m = leafmap.Map(style="satellite")
m
```

```{code-cell} ipython3
m = leafmap.Map(style="hybrid")
m
```

```{code-cell} ipython3
m = leafmap.Map(style="topo")
m
```

### Adding a vector tile source

To include vector data from MapTiler, first obtain the MapTiler API key and then set up a vector source with the desired tile data URL. The vector tile source can then be added to a layer to display features such as contour lines, which are styled for better visibility and engagement.

```{code-cell} ipython3
MAPTILER_KEY = leafmap.get_api_key("MAPTILER_KEY")
```

```{code-cell} ipython3
m = leafmap.Map(center=[-122.447303, 37.753574], zoom=13, style="streets")
source = {
    "type": "vector",
    "url": f"https://api.maptiler.com/tiles/contours/tiles.json?key={MAPTILER_KEY}",
}
layer = {
    "id": "terrain-data",
    "type": "line",
    "source": "contours",
    "source-layer": "contour",
    "layout": {"line-join": "round", "line-cap": "round"},
    "paint": {"line-color": "#ff69b4", "line-width": 1},
}
m.add_source("contours", source)
m.add_layer(layer)
m
```

## 3D Mapping

MapTiler provides a variety of 3D styles that enhance geographic data visualization. Styles can be prefixed with `3d-` to utilize 3D effects such as hybrid, satellite, and topo. The `3d-hillshade` style is used for visualizing hillshade effects alone.

### 3D Terrain

These examples demonstrate different ways to implement 3D terrain visualization:

- **3D Hybrid style**: Adds terrain relief to urban data with hybrid visualization.
- **3D Satellite style**: Combines satellite imagery with 3D elevation, enhancing visual context for topography.
- **3D Topo style**: Provides a topographic view with elevation exaggeration and optional hillshade.
- **3D Terrain style**: Displays terrain with default settings for natural geographic areas.
- **3D Ocean style**: A specialized terrain style with oceanic details, using exaggeration and hillshade to emphasize depth.

Each terrain map setup includes a pitch and bearing to adjust the map's angle and orientation, giving a better perspective of 3D features.

```{code-cell} ipython3
m = leafmap.Map(
    center=[-122.1874314, 46.2022386], zoom=13, pitch=60, bearing=220, style="3d-hybrid"
)
m.add_layer_control(bg_layers=True)
m
```

![](https://i.imgur.com/3Q2Q3CG.png)

```{code-cell} ipython3
m = leafmap.Map(
    center=[-122.1874314, 46.2022386],
    zoom=13,
    pitch=60,
    bearing=220,
    style="3d-satellite",
)
m.add_layer_control(bg_layers=True)
m
```

![](https://i.imgur.com/5PNMbAv.png)

```{code-cell} ipython3
m = leafmap.Map(
    center=[-122.1874314, 46.2022386],
    zoom=13,
    pitch=60,
    bearing=220,
    style="3d-topo",
    exaggeration=1.5,
    hillshade=False,
)
m.add_layer_control(bg_layers=True)
m
```

![](https://i.imgur.com/y33leIj.png)

```{code-cell} ipython3
m = leafmap.Map(
    center=[-122.1874314, 46.2022386],
    zoom=13,
    pitch=60,
    bearing=220,
    style="3d-terrain",
)
m.add_layer_control(bg_layers=True)
m
```

```{code-cell} ipython3
m = leafmap.Map(style="3d-ocean", exaggeration=1.5, hillshade=True)
m.add_layer_control(bg_layers=True)
m
```

![](https://i.imgur.com/m6NwSWG.png)

+++

### 3D Buildings

Adding 3D buildings enhances urban visualizations, showing buildings with height variations. The setup involves specifying the MapTiler API key for vector tiles and adding building data as a 3D extrusion layer. The extrusion height and color can be set based on data attributes to visualize structures with varying heights, which can be useful in city planning and urban analysis.

```{code-cell} ipython3
m = leafmap.Map(
    center=[-74.01201, 40.70473], zoom=16, pitch=60, bearing=35, style="basic-v2"
)
MAPTILER_KEY = leafmap.get_api_key("MAPTILER_KEY")
m.add_basemap("Esri.WorldImagery", visible=False)
source = {
    "url": f"https://api.maptiler.com/tiles/v3/tiles.json?key={MAPTILER_KEY}",
    "type": "vector",
}

layer = {
    "id": "3d-buildings",
    "source": "openmaptiles",
    "source-layer": "building",
    "type": "fill-extrusion",
    "min-zoom": 15,
    "paint": {
        "fill-extrusion-color": [
            "interpolate",
            ["linear"],
            ["get", "render_height"],
            0,
            "lightgray",
            200,
            "royalblue",
            400,
            "lightblue",
        ],
        "fill-extrusion-height": [
            "interpolate",
            ["linear"],
            ["zoom"],
            15,
            0,
            16,
            ["get", "render_height"],
        ],
        "fill-extrusion-base": [
            "case",
            [">=", ["get", "zoom"], 16],
            ["get", "render_min_height"],
            0,
        ],
    },
}
m.add_source("openmaptiles", source)
m.add_layer(layer)
m.add_layer_control()
m
```

![](https://i.imgur.com/9QeicaE.png)

```{code-cell} ipython3
m = leafmap.Map(
    center=[-74.01201, 40.70473], zoom=16, pitch=60, bearing=35, style="basic-v2"
)
m.add_basemap("Esri.WorldImagery", visible=False)
m.add_3d_buildings(min_zoom=15)
m.add_layer_control()
m
```

### 3D Indoor Mapping

Indoor mapping data can be visualized by loading a GeoJSON file and applying the `add_geojson` method. This setup allows for displaying floorplans with attributes such as color, height, and opacity. It provides a realistic indoor perspective, which is useful for visualizing complex structures or navigating interior spaces.

```{code-cell} ipython3
data = "https://maplibre.org/maplibre-gl-js/docs/assets/indoor-3d-map.geojson"
gdf = leafmap.geojson_to_gdf(data)
gdf.explore()
```

```{code-cell} ipython3
gdf.head()
```

```{code-cell} ipython3
m = leafmap.Map(
    center=(-87.61694, 41.86625), zoom=17, pitch=40, bearing=20, style="positron"
)
m.add_basemap("OpenStreetMap.Mapnik")
m.add_geojson(
    data,
    layer_type="fill-extrusion",
    name="floorplan",
    paint={
        "fill-extrusion-color": ["get", "color"],
        "fill-extrusion-height": ["get", "height"],
        "fill-extrusion-base": ["get", "base_height"],
        "fill-extrusion-opacity": 0.5,
    },
)
m.add_layer_control()
m
```

![](https://i.imgur.com/eYhSWaT.png)

+++

### 3D Choropleth Map

Choropleth maps in 3D allow visualizing attribute data by height, where regions are colored and extruded based on specific attributes, such as age or population area. Two examples are provided below:

- **European Countries (Age at First Marriage)**: The map displays different colors and extrusion heights based on age data. Color interpolations help represent data variations across regions, making it a suitable map for demographic studies.

- **US Counties (Census Area)**: This example uses census data to display county areas in the United States, where each county’s area is represented with a different color and height based on its size. This type of map provides insights into geographic distribution and area proportions across the region.

Both maps use a fill-extrusion style to dynamically adjust color and height, creating a 3D effect that enhances data interpretation.

```{code-cell} ipython3
m = leafmap.Map(center=[19.43, 49.49], zoom=3, pitch=60, style="basic")
source = {
    "type": "geojson",
    "data": "https://docs.maptiler.com/sdk-js/assets/Mean_age_of_women_at_first_marriage_in_2019.geojson",
}
m.add_source("countries", source)
layer = {
    "id": "eu-countries",
    "source": "countries",
    "type": "fill-extrusion",
    "paint": {
        "fill-extrusion-color": [
            "interpolate",
            ["linear"],
            ["get", "age"],
            23.0,
            "#fff5eb",
            24.0,
            "#fee6ce",
            25.0,
            "#fdd0a2",
            26.0,
            "#fdae6b",
            27.0,
            "#fd8d3c",
            28.0,
            "#f16913",
            29.0,
            "#d94801",
            30.0,
            "#8c2d04",
        ],
        "fill-extrusion-opacity": 1,
        "fill-extrusion-height": ["*", ["get", "age"], 5000],
    },
}
first_symbol_layer_id = m.find_first_symbol_layer()["id"]
m.add_layer(layer, first_symbol_layer_id)
m.add_layer_control()
m
```

![](https://i.imgur.com/fLgqYTa.png)

```{code-cell} ipython3
m = leafmap.Map(center=[-100, 40], zoom=3, pitch=60, style="basic")
source = {
    "type": "geojson",
    "data": "https://open.gishub.org/data/us/us_counties.geojson",
}
m.add_source("counties", source)
layer = {
    "id": "us-counties",
    "source": "counties",
    "type": "fill-extrusion",
    "paint": {
        "fill-extrusion-color": [
            "interpolate",
            ["linear"],
            ["get", "CENSUSAREA"],
            400,
            "#fff5eb",
            600,
            "#fee6ce",
            800,
            "#fdd0a2",
            1000,
            "#fdae6b",
        ],
        "fill-extrusion-opacity": 1,
        "fill-extrusion-height": ["*", ["get", "CENSUSAREA"], 50],
    },
}
first_symbol_layer_id = m.find_first_symbol_layer()["id"]
m.add_layer(layer, first_symbol_layer_id)
m.add_layer_control()
m
```

## Visualizing Vector Data

Leafmap provides a variety of methods to visualize vector data on a map, allowing you to display points, lines, polygons, and other vector shapes with custom styling and interactivity.

### Point Data

The following examples demonstrate how to display points on the map.

- **Simple Marker**: Initializes the map centered on a specific latitude and longitude, then adds a static marker to the location.

- **Draggable Marker**: Similar to the simple marker, but with an additional option to make the marker draggable. This allows users to reposition it directly on the map.

- **Multiple Points with GeoJSON**: Loads point data from a GeoJSON file containing world city locations. After reading the data, it’s added to the map as a layer named “cities.” Popups can be enabled to display additional information when a user clicks on a city.

- **Custom Symbol Layer**: Loads point data as symbols instead of markers and customizes the symbol layout using icons, which can be scaled to any size.

```{code-cell} ipython3
m = leafmap.Map(center=[12.550343, 55.665957], zoom=8, style="positron")
m.add_marker(lng_lat=[12.550343, 55.665957])
m
```

![](https://i.imgur.com/ufmqTzx.png)

```{code-cell} ipython3
m = leafmap.Map(center=[12.550343, 55.665957], zoom=8, style="positron")
m.add_marker(lng_lat=[12.550343, 55.665957], options={"draggable": True})
m
```

```{code-cell} ipython3
url = (
    "https://github.com/opengeos/datasets/releases/download/world/world_cities.geojson"
)
geojson = leafmap.read_geojson(url)
```

```{code-cell} ipython3
m = leafmap.Map(style="streets")
m.add_geojson(geojson, name="cities")
m.add_popup("cities")
m
```

```{code-cell} ipython3
m = leafmap.Map(style="streets")
source = {"type": "geojson", "data": geojson}

layer = {
    "id": "cities",
    "type": "symbol",
    "source": "point",
    "layout": {
        "icon-image": "marker_15",
        "icon-size": 1,
    },
}
m.add_source("point", source)
m.add_layer(layer)
m.add_popup("cities")
m
```

### Customizing Marker Icon Image

To further customize point data, an image icon can be used instead of the default marker:

- **Add Custom Icon**: Loads an OSGeo logo as the custom marker image. The GeoJSON source for conference locations is loaded, and each location is marked with the custom icon and labeled with the year. Layout options define the placement of text and icons.

```{code-cell} ipython3
m = leafmap.Map(center=[0, 0], zoom=1, style="positron")
image = "https://maplibre.org/maplibre-gl-js/docs/assets/osgeo-logo.png"
m.add_image("custom-marker", image)

url = "https://github.com/opengeos/datasets/releases/download/places/osgeo_conferences.geojson"
geojson = leafmap.read_geojson(url)

source = {"type": "geojson", "data": geojson}

m.add_source("conferences", source)
layer = {
    "id": "conferences",
    "type": "symbol",
    "source": "conferences",
    "layout": {
        "icon-image": "custom-marker",
        "text-field": ["get", "year"],
        "text-font": ["Open Sans Semibold", "Arial Unicode MS Bold"],
        "text-offset": [0, 1.25],
        "text-anchor": "top",
    },
}

m.add_layer(layer)
m
```

### Line Data

Lines can be displayed to represent routes, boundaries, or connections between locations:

- **Basic Line**: Sets up a line with multiple coordinates to create a path. The map displays this path with rounded line joins and a defined color and width, giving it a polished appearance.

```{code-cell} ipython3
m = leafmap.Map(center=[-122.486052, 37.830348], zoom=15, style="streets")

source = {
    "type": "geojson",
    "data": {
        "type": "Feature",
        "properties": {},
        "geometry": {
            "type": "LineString",
            "coordinates": [
                [-122.48369693756104, 37.83381888486939],
                [-122.48348236083984, 37.83317489144141],
                [-122.48339653015138, 37.83270036637107],
                [-122.48356819152832, 37.832056363179625],
                [-122.48404026031496, 37.83114119107971],
                [-122.48404026031496, 37.83049717427869],
                [-122.48348236083984, 37.829920943955045],
                [-122.48356819152832, 37.82954808664175],
                [-122.48507022857666, 37.82944639795659],
                [-122.48610019683838, 37.82880236636284],
                [-122.48695850372314, 37.82931081282506],
                [-122.48700141906738, 37.83080223556934],
                [-122.48751640319824, 37.83168351665737],
                [-122.48803138732912, 37.832158048267786],
                [-122.48888969421387, 37.83297152392784],
                [-122.48987674713133, 37.83263257682617],
                [-122.49043464660643, 37.832937629287755],
                [-122.49125003814696, 37.832429207817725],
                [-122.49163627624512, 37.832564787218985],
                [-122.49223709106445, 37.83337825839438],
                [-122.49378204345702, 37.83368330777276],
            ],
        },
    },
}

layer = {
    "id": "route",
    "type": "line",
    "source": "route",
    "layout": {"line-join": "round", "line-cap": "round"},
    "paint": {"line-color": "#888", "line-width": 8},
}
m.add_source("route", source)
m.add_layer(layer)
m
```

### Polygon Data

Polygons represent regions or areas on the map. Leafmap offers options to display filled polygons with customizable colors and opacities.

- **Basic Polygon**: Adds a GeoJSON polygon representing an area and customizes its fill color and opacity.

- **Outlined Polygon**: In addition to filling the polygon, an outline color is specified to highlight the polygon’s boundary. Both fill and line layers are defined, enhancing visual clarity.

- **Building Visualization with GeoJSON**: Uses a URL to load building data and displays it with a customized fill color and outline. The style uses a hybrid map view for additional context.

```{code-cell} ipython3
m = leafmap.Map(center=[-68.137343, 45.137451], zoom=5, style="streets")
geojson = {
    "type": "Feature",
    "geometry": {
        "type": "Polygon",
        "coordinates": [
            [
                [-67.13734351262877, 45.137451890638886],
                [-66.96466, 44.8097],
                [-68.03252, 44.3252],
                [-69.06, 43.98],
                [-70.11617, 43.68405],
                [-70.64573401557249, 43.090083319667144],
                [-70.75102474636725, 43.08003225358635],
                [-70.79761105007827, 43.21973948828747],
                [-70.98176001655037, 43.36789581966826],
                [-70.94416541205806, 43.46633942318431],
                [-71.08482, 45.3052400000002],
                [-70.6600225491012, 45.46022288673396],
                [-70.30495378282376, 45.914794623389355],
                [-70.00014034695016, 46.69317088478567],
                [-69.23708614772835, 47.44777598732787],
                [-68.90478084987546, 47.184794623394396],
                [-68.23430497910454, 47.35462921812177],
                [-67.79035274928509, 47.066248887716995],
                [-67.79141211614706, 45.702585354182816],
                [-67.13734351262877, 45.137451890638886],
            ]
        ],
    },
}
source = {"type": "geojson", "data": geojson}
m.add_source("maine", source)
layer = {
    "id": "maine",
    "type": "fill",
    "source": "maine",
    "layout": {},
    "paint": {"fill-color": "#088", "fill-opacity": 0.8},
}
m.add_layer(layer)
m
```

```{code-cell} ipython3
m = leafmap.Map(center=[-68.137343, 45.137451], zoom=5, style="streets")
paint = {"fill-color": "#088", "fill-opacity": 0.8}
m.add_geojson(geojson, layer_type="fill", paint=paint)
m
```

```{code-cell} ipython3
m = leafmap.Map(style="hybrid")
geojson = "https://github.com/opengeos/datasets/releases/download/places/wa_overture_buildings.geojson"
paint = {"fill-color": "#ffff00", "fill-opacity": 0.5, "fill-outline-color": "#ff0000"}
m.add_geojson(geojson, layer_type="fill", paint=paint, name="Fill")
m
```

```{code-cell} ipython3
m = leafmap.Map(style="hybrid")
geojson = "https://github.com/opengeos/datasets/releases/download/places/wa_overture_buildings.geojson"
paint_line = {"line-color": "#ff0000", "line-width": 3}
m.add_geojson(geojson, layer_type="line", paint=paint_line, name="Outline")
paint_fill = {"fill-color": "#ffff00", "fill-opacity": 0.5}
m.add_geojson(geojson, layer_type="fill", paint=paint_fill, name="Fill")
m.add_layer_control()
m
```

### Multiple Geometries

This example displays both line and extrusion fills for complex data types:

- **Extruded Blocks with Line Overlay**: Loads Vancouver building blocks data and applies both line and fill-extrusion styles. Each block’s height is based on an attribute, which provides a 3D effect. This is useful for visualizing value distribution across an urban landscape.

```{code-cell} ipython3
m = leafmap.Map(
    center=[-123.13, 49.254], zoom=11, style="dark-matter", pitch=45, bearing=0
)
url = "https://raw.githubusercontent.com/visgl/deck.gl-data/master/examples/geojson/vancouver-blocks.json"
paint_line = {
    "line-color": "white",
    "line-width": 2,
}
paint_fill = {
    "fill-extrusion-color": {
        "property": "valuePerSqm",
        "stops": [
            [0, "grey"],
            [1000, "yellow"],
            [5000, "orange"],
            [10000, "darkred"],
            [50000, "lightblue"],
        ],
    },
    "fill-extrusion-height": ["*", 10, ["sqrt", ["get", "valuePerSqm"]]],
    "fill-extrusion-opacity": 0.9,
}
m.add_geojson(url, layer_type="line", paint=paint_line, name="blocks-line")
m.add_geojson(url, layer_type="fill-extrusion", paint=paint_fill, name="blocks-fill")
m
```

```{code-cell} ipython3
m.layer_interact()
```

### Marker Cluster

Clusters help manage large datasets, such as earthquake data, by grouping nearby markers. The color and size of clusters change based on the point count, and filters differentiate individual points from clusters. This example uses nested GeoJSON layers for visualizing clustered earthquake occurrences, with separate styles for individual points and clusters.

```{code-cell} ipython3
m = leafmap.Map(center=[-103.59179, 40.66995], zoom=3, style="streets")
data = "https://docs.mapbox.com/mapbox-gl-js/assets/earthquakes.geojson"
source_args = {
    "cluster": True,
    "cluster_radius": 50,
    "cluster_min_points": 2,
    "cluster_max_zoom": 14,
    "cluster_properties": {
        "maxMag": ["max", ["get", "mag"]],
        "minMag": ["min", ["get", "mag"]],
    },
}

m.add_geojson(
    data,
    layer_type="circle",
    name="earthquake-circles",
    filter=["!", ["has", "point_count"]],
    paint={"circle-color": "darkblue"},
    source_args=source_args,
)

m.add_geojson(
    data,
    layer_type="circle",
    name="earthquake-clusters",
    filter=["has", "point_count"],
    paint={
        "circle-color": [
            "step",
            ["get", "point_count"],
            "#51bbd6",
            100,
            "#f1f075",
            750,
            "#f28cb1",
        ],
        "circle-radius": ["step", ["get", "point_count"], 20, 100, 30, 750, 40],
    },
    source_args=source_args,
)

m.add_geojson(
    data,
    layer_type="symbol",
    name="earthquake-labels",
    filter=["has", "point_count"],
    layout={
        "text-field": ["get", "point_count_abbreviated"],
        "text-size": 12,
    },
    source_args=source_args,
)
m
```

![](https://i.imgur.com/VWvJKwl.png)

+++

### Local Vector Data

Local vector files, such as GeoJSON, can be loaded directly into the map. The example downloads a GeoJSON file representing U.S. states and adds it to the map using `open_geojson`.

```{code-cell} ipython3
url = "https://github.com/opengeos/datasets/releases/download/us/us_states.geojson"
filepath = "data/us_states.geojson"
leafmap.download_file(url, filepath, quiet=True)
```

```{code-cell} ipython3
m = leafmap.Map(center=[-100, 40], zoom=3)
m
```

```{code-cell} ipython3
m.open_geojson()
```

### Changing Building Color

You can customize the color and opacity of buildings based on the map’s zoom level. This example changes building colors from orange at lower zoom levels to lighter shades as the zoom level increases. Additionally, the opacity gradually transitions to fully opaque, making buildings more visible at close-up zoom levels.

```{code-cell} ipython3
m = leafmap.Map(center=[-90.73414, 14.55524], zoom=13, style="basic")
m.set_paint_property(
    "building",
    "fill-color",
    ["interpolate", ["exponential", 0.5], ["zoom"], 15, "#e2714b", 22, "#eee695"],
)
m.set_paint_property(
    "building",
    "fill-opacity",
    ["interpolate", ["exponential", 0.5], ["zoom"], 15, 0, 22, 1],
)
m.add_layer_control(bg_layers=True)
m
```

```{code-cell} ipython3
m.add_call("zoomTo", 19, {"duration": 9000})
```

![](https://i.imgur.com/PayiTON.png)

+++

### Adding a New Layer Below Labels

A layer can be added below existing labels on the map to enhance clarity without obscuring labels. The urban areas dataset is displayed as a fill layer in a color and opacity that visually distinguishes it from other map elements. The layer is positioned below symbols, allowing place names to remain visible.

```{code-cell} ipython3
m = leafmap.Map(center=[-88.137343, 35.137451], zoom=4, style="streets")
source = {
    "type": "geojson",
    "data": "https://d2ad6b4ur7yvpq.cloudfront.net/naturalearth-3.3.0/ne_50m_urban_areas.geojson",
}
m.add_source("urban-areas", source)
first_symbol_layer = m.find_first_symbol_layer()
layer = {
    "id": "urban-areas-fill",
    "type": "fill",
    "source": "urban-areas",
    "layout": {},
    "paint": {"fill-color": "#f08", "fill-opacity": 0.4},
}
m.add_layer(layer, before_id=first_symbol_layer["id"])
m
```

### Heat Map

Heatmaps visually represent data density. This example uses earthquake data and configures the heatmap layer with dynamic properties, such as weight, intensity, color, and radius, based on earthquake magnitudes. Circles are added to indicate individual earthquakes, with colors and sizes varying according to their magnitude.

```{code-cell} ipython3
m = leafmap.Map(center=[-120, 50], zoom=2, style="basic")
source = {
    "type": "geojson",
    "data": "https://maplibre.org/maplibre-gl-js/docs/assets/earthquakes.geojson",
}
m.add_source("earthquakes", source)
layer = {
    "id": "earthquakes-heat",
    "type": "heatmap",
    "source": "earthquakes",
    "maxzoom": 9,
    "paint": {
        # Increase the heatmap weight based on frequency and property magnitude
        "heatmap-weight": ["interpolate", ["linear"], ["get", "mag"], 0, 0, 6, 1],
        # Increase the heatmap color weight weight by zoom level
        # heatmap-intensity is a multiplier on top of heatmap-weight
        "heatmap-intensity": ["interpolate", ["linear"], ["zoom"], 0, 1, 9, 3],
        # Color ramp for heatmap.  Domain is 0 (low) to 1 (high).
        # Begin color ramp at 0-stop with a 0-transparency color
        # to create a blur-like effect.
        "heatmap-color": [
            "interpolate",
            ["linear"],
            ["heatmap-density"],
            0,
            "rgba(33,102,172,0)",
            0.2,
            "rgb(103,169,207)",
            0.4,
            "rgb(209,229,240)",
            0.6,
            "rgb(253,219,199)",
            0.8,
            "rgb(239,138,98)",
            1,
            "rgb(178,24,43)",
        ],
        # Adjust the heatmap radius by zoom level
        "heatmap-radius": ["interpolate", ["linear"], ["zoom"], 0, 2, 9, 20],
        # Transition from heatmap to circle layer by zoom level
        "heatmap-opacity": ["interpolate", ["linear"], ["zoom"], 7, 1, 9, 0],
    },
}
m.add_layer(layer, before_id="waterway")
layer2 = {
    "id": "earthquakes-point",
    "type": "circle",
    "source": "earthquakes",
    "minzoom": 7,
    "paint": {
        # Size circle radius by earthquake magnitude and zoom level
        "circle-radius": [
            "interpolate",
            ["linear"],
            ["zoom"],
            7,
            ["interpolate", ["linear"], ["get", "mag"], 1, 1, 6, 4],
            16,
            ["interpolate", ["linear"], ["get", "mag"], 1, 5, 6, 50],
        ],
        # Color circle by earthquake magnitude
        "circle-color": [
            "interpolate",
            ["linear"],
            ["get", "mag"],
            1,
            "rgba(33,102,172,0)",
            2,
            "rgb(103,169,207)",
            3,
            "rgb(209,229,240)",
            4,
            "rgb(253,219,199)",
            5,
            "rgb(239,138,98)",
            6,
            "rgb(178,24,43)",
        ],
        "circle-stroke-color": "white",
        "circle-stroke-width": 1,
        # Transition from heatmap to circle layer by zoom level
        "circle-opacity": ["interpolate", ["linear"], ["zoom"], 7, 0, 8, 1],
    },
}
m.add_layer(layer2, before_id="waterway")
m
```

![](https://i.imgur.com/OLCRPKj.png)

+++

### Visualizing Population Density

Population density can be calculated and displayed dynamically. This example loads a GeoJSON of Rwandan provinces, calculating density by dividing population by area. The fill color of each province is then adjusted based on density, with different color schemes applied depending on the zoom level.

```{code-cell} ipython3
m = leafmap.Map(center=[30.0222, -1.9596], zoom=7, style="streets")
source = {
    "type": "geojson",
    "data": "https://maplibre.org/maplibre-gl-js/docs/assets/rwanda-provinces.geojson",
}
m.add_source("rwanda-provinces", source)
layer = {
    "id": "rwanda-provinces",
    "type": "fill",
    "source": "rwanda-provinces",
    "layout": {},
    "paint": {
        "fill-color": [
            "let",
            "density",
            ["/", ["get", "population"], ["get", "sq-km"]],
            [
                "interpolate",
                ["linear"],
                ["zoom"],
                8,
                [
                    "interpolate",
                    ["linear"],
                    ["var", "density"],
                    274,
                    ["to-color", "#edf8e9"],
                    1551,
                    ["to-color", "#006d2c"],
                ],
                10,
                [
                    "interpolate",
                    ["linear"],
                    ["var", "density"],
                    274,
                    ["to-color", "#eff3ff"],
                    1551,
                    ["to-color", "#08519c"],
                ],
            ],
        ],
        "fill-opacity": 0.7,
    },
}
m.add_layer(layer)
m
```

## Visualizing Raster Data

### Local Raster Data

To visualize local raster files, use the `add_raster` method. In the example, a Landsat image is downloaded and displayed using two different band combinations:

- **Band Combination 3-2-1 (True Color)**: Simulates natural colors in the RGB channels.
- **Band Combination 4-3-2**: Enhances vegetation, displaying it in red for better visual contrast.
These layers are added to the map along with controls to toggle them. You can adjust brightness and contrast with the `vmin` and `vmax` arguments to improve clarity.

```{code-cell} ipython3
url = "https://github.com/opengeos/datasets/releases/download/raster/landsat.tif"
filepath = "landsat.tif"
leafmap.download_file(url, filepath, quiet=True)
```

```{code-cell} ipython3
m = leafmap.Map(style="streets")
m.add_raster(filepath, indexes=[3, 2, 1], vmin=0, vmax=100, name="Landsat-321")
m.add_raster(filepath, indexes=[4, 3, 2], vmin=0, vmax=100, name="Landsat-432")
m.add_layer_control()
m
```

```{code-cell} ipython3
m.layer_interact()
```

A Digital Elevation Model (DEM) is also downloaded and visualized with a terrain color scheme. Leafmap’s `layer_interact` method allows interactive adjustments.

```{code-cell} ipython3
url = "https://github.com/opengeos/datasets/releases/download/raster/srtm90.tif"
filepath = "srtm90.tif"
leafmap.download_file(url, filepath, quiet=True)
```

```{code-cell} ipython3
m = leafmap.Map(style="satellite")
m.add_raster(filepath, colormap="terrain", name="DEM")
m
```

```{code-cell} ipython3
m.layer_interact()
```

### Cloud Optimized GeoTIFF (COG)

Cloud Optimized GeoTIFFs (COG) are large raster files stored on cloud platforms, allowing efficient streaming and loading. This example loads satellite imagery of Libya before and after an event, showing the change over time. Each image is loaded with `add_cog_layer`, and layers can be toggled for comparison. Using `fit_bounds`, the map centers on the COG layer to fit its boundaries.

```{code-cell} ipython3
m = leafmap.Map(style="satellite")
before = (
    "https://github.com/opengeos/datasets/releases/download/raster/Libya-2023-07-01.tif"
)
after = (
    "https://github.com/opengeos/datasets/releases/download/raster/Libya-2023-09-13.tif"
)
m.add_cog_layer(before, name="Before", attribution="Maxar")
m.add_cog_layer(after, name="After", attribution="Maxar", fit_bounds=True)
m.add_layer_control()
m
```

```{code-cell} ipython3
m.layer_interact()
```

### STAC Layer

The SpatioTemporal Asset Catalog (STAC) standard organizes large satellite data collections. With `add_stac_layer`, this example loads Canadian satellite data, displaying both a panchromatic and an RGB layer from the same source. This approach allows easy switching between views.

```{code-cell} ipython3
m = leafmap.Map(style="streets")
url = "https://canada-spot-ortho.s3.amazonaws.com/canada_spot_orthoimages/canada_spot5_orthoimages/S5_2007/S5_11055_6057_20070622/S5_11055_6057_20070622.json"
m.add_stac_layer(url, bands=["pan"], name="Panchromatic", vmin=0, vmax=150)
m.add_stac_layer(url, bands=["B4", "B3", "B2"], name="RGB", vmin=0, vmax=150)
m.add_layer_control()
m
```

```{code-cell} ipython3
m.layer_interact()
```

Leafmap also supports loading STAC items from the [Microsoft Planetary Computer](https://planetarycomputer.microsoft.com). The example demonstrates how to load a STAC item from the Planetary Computer and display it on the map.

```{code-cell} ipython3
collection = "landsat-8-c2-l2"
item = "LC08_L2SP_047027_20201204_02_T1"
```

```{code-cell} ipython3
leafmap.stac_assets(collection=collection, item=item, titiler_endpoint="pc")
```

```{code-cell} ipython3
m = leafmap.Map(style="satellite")
m.add_stac_layer(
    collection=collection,
    item=item,
    assets=["SR_B5", "SR_B4", "SR_B3"],
    name="Color infrared",
)
m
```

## Interacting with the Map

Interactivity allows for a more tailored map experience.


### Displaying a Non-Interactive Map

To create a static map, set `interactive=False`. This disables all user interactions, making it ideal for static presentations.

```{code-cell} ipython3
m = leafmap.Map(
    center=[-122.65, 45.52], zoom=9, interactive=False, style="liberty", controls={}
)
m
```

### Disabling Scroll Zoom

Use `scroll_zoom=False` to prevent map zooming with the scroll wheel, maintaining a fixed zoom level.

```{code-cell} ipython3
m = leafmap.Map(center=[-122.65, 45.52], zoom=9, scroll_zoom=False, style="liberty")
m
```

### Fitting Bounds

The `fit_bounds` method focuses the map on a specified area. In this example, the map centers on Kenya. Additionally, a GeoJSON line is added to the map, and its bounds are automatically calculated with `geojson_bounds` for a custom zoom fit.

```{code-cell} ipython3
m = leafmap.Map(center=[-74.5, 40], zoom=9, style="liberty")
m
```

Fit to Kenya.

```{code-cell} ipython3
bounds = [[32.958984, -5.353521], [43.50585, 5.615985]]
m.fit_bounds(bounds)
```

```{code-cell} ipython3
m = leafmap.Map(center=[-77.0214, 38.897], zoom=12, style="liberty")

geojson = {
    "type": "FeatureCollection",
    "features": [
        {
            "type": "Feature",
            "geometry": {
                "type": "LineString",
                "properties": {},
                "coordinates": [
                    [-77.0366048812866, 38.89873175227713],
                    [-77.03364372253417, 38.89876515143842],
                    [-77.03364372253417, 38.89549195896866],
                    [-77.02982425689697, 38.89549195896866],
                    [-77.02400922775269, 38.89387200688839],
                    [-77.01519012451172, 38.891416957534204],
                    [-77.01521158218382, 38.892068305429156],
                    [-77.00813055038452, 38.892051604275686],
                    [-77.00832366943358, 38.89143365883688],
                    [-77.00818419456482, 38.89082405874451],
                    [-77.00815200805664, 38.88989712255097],
                ],
            },
        }
    ],
}

m.add_source("LineString", {"type": "geojson", "data": geojson})
layer = {
    "id": "LineString",
    "type": "line",
    "source": "LineString",
    "layout": {"line-join": "round", "line-cap": "round"},
    "paint": {"line-color": "#BF93E4", "line-width": 5},
}
m.add_layer(layer)
m
```

```{code-cell} ipython3
bounds = leafmap.geojson_bounds(geojson)
bounds
```

```{code-cell} ipython3
m.fit_bounds(bounds)
```

### Restricting Map Panning to an Area

To limit map panning to a specific area, define a bounding box. The map is then restricted within the bounds, ensuring users do not accidentally pan away from the area of interest.

```{code-cell} ipython3
bounds = [
    [-74.04728500751165, 40.68392799015035],
    [-73.91058699000139, 40.87764500765852],
]
```

```{code-cell} ipython3
m = leafmap.Map(center=[-73.9978, 40.7209], zoom=13, max_bounds=bounds, style="liberty")
m
```

### Flying To

The `fly_to` method smoothly navigates to specified coordinates. Parameters like speed and zoom provide control over the fly-to effect. This example flies from the initial map location to New York City.

```{code-cell} ipython3
m = leafmap.Map(center=[-2.242467, 53.478122], zoom=9, style="liberty")
m
```

```{code-cell} ipython3
m.fly_to(lon=-73.983609, lat=40.754368, zoom=12)
```

```{code-cell} ipython3
m = leafmap.Map(center=[-74.5, 40], zoom=9, style="liberty")
m
```

```{code-cell} ipython3
options = {
    "lon": 74.5,
    "lat": 40,
    "zoom": 9,
    "bearing": 0,
    "speed": 0.2,
    "curve": 1,
    "essential": True,
}

m.fly_to(**options)
```

### Jumping to a Series of Locations

Using `jump_to`, you can navigate between multiple locations. This example sets up a list of coordinates representing cities and automatically pans to each one in sequence. Adding a delay between transitions enhances the animation effect.

```{code-cell} ipython3
import time
```

```{code-cell} ipython3
m = leafmap.Map(center=[100.507, 13.745], zoom=9, style="streets")

cities = {
    "type": "FeatureCollection",
    "features": [
        {
            "type": "Feature",
            "properties": {},
            "geometry": {"type": "Point", "coordinates": [100.507, 13.745]},
        },
        {
            "type": "Feature",
            "properties": {},
            "geometry": {"type": "Point", "coordinates": [98.993, 18.793]},
        },
        {
            "type": "Feature",
            "properties": {},
            "geometry": {"type": "Point", "coordinates": [99.838, 19.924]},
        },
        {
            "type": "Feature",
            "properties": {},
            "geometry": {"type": "Point", "coordinates": [102.812, 17.408]},
        },
        {
            "type": "Feature",
            "properties": {},
            "geometry": {"type": "Point", "coordinates": [100.458, 7.001]},
        },
        {
            "type": "Feature",
            "properties": {},
            "geometry": {"type": "Point", "coordinates": [100.905, 12.935]},
        },
    ],
}
m
```

```{code-cell} ipython3
for index, city in enumerate(cities["features"]):
    time.sleep(2)
    coords = city["geometry"]["coordinates"]
    m.jump_to({"center": coords})
```

### Getting Coordinates of the Mouse Pointer

With widgets, you can display the current mouse pointer coordinates as it moves across the map. This is useful for precision mapping tasks where knowing exact coordinates is essential.

```{code-cell} ipython3
import ipywidgets as widgets
```

```{code-cell} ipython3
m = leafmap.Map(center=[-74.5, 40], zoom=9, style="streets")
m
```

```{code-cell} ipython3
m.clicked
```

```{code-cell} ipython3
output = widgets.Output()


def log_lng_lat(lng_lat):
    with output:
        output.clear_output()
        print(lng_lat.new)


m.observe(log_lng_lat, names="clicked")
output
```

## Customizing Layer Styles

Customizing layer styles enables personalized map designs.

### Changing Layer Color

Use `style_layer_interact` to interactively change the color of map layers, such as water bodies. This method provides an interactive palette for immediate style changes.

```{code-cell} ipython3
m = leafmap.Map(center=[12.338, 45.4385], zoom=17, style="streets")
m
```

```{code-cell} ipython3
m.style_layer_interact(id="water")
```

### Changing Case of Labels

This example displays labels in upper or lower case based on their properties. The layout options let you customize font, size, and alignment. For example, facility names are displayed in uppercase, and comments are displayed in lowercase for contrast.

```{code-cell} ipython3
m = leafmap.Map(center=[-116.231, 43.604], zoom=11, style="streets")
geojson = {
    "type": "geojson",
    "data": "https://maplibre.org/maplibre-gl-js/docs/assets/boise.geojson",
}
m.add_source("off-leash-areas", geojson)
layer = {
    "id": "off-leash-areas",
    "type": "symbol",
    "source": "off-leash-areas",
    "layout": {
        "icon-image": "dog-park-11",
        "text-field": [
            "format",
            ["upcase", ["get", "FacilityName"]],
            {"font-scale": 0.8},
            "\n",
            {},
            ["downcase", ["get", "Comments"]],
            {"font-scale": 0.6},
        ],
        "text-font": ["Open Sans Semibold", "Arial Unicode MS Bold"],
        "text-offset": [0, 0.6],
        "text-anchor": "top",
    },
}
m.add_layer(layer)
m
```

![](https://i.imgur.com/FzGOovv.png)

+++

### Variable Label Placement

Labels can be automatically positioned around features with `text-variable-anchor`. This example defines multiple anchor points for labels to avoid overlap and ensure clear visibility. The radial offset and auto-justification properties create a professional, clutter-free appearance around points of interest.

```{code-cell} ipython3
m = leafmap.Map(center=[-77.04, 38.907], zoom=11, style="streets")

places = {
    "type": "FeatureCollection",
    "features": [
        {
            "type": "Feature",
            "properties": {"description": "Ford's Theater", "icon": "theatre"},
            "geometry": {"type": "Point", "coordinates": [-77.038659, 38.931567]},
        },
        {
            "type": "Feature",
            "properties": {"description": "The Gaslight", "icon": "theatre"},
            "geometry": {"type": "Point", "coordinates": [-77.003168, 38.894651]},
        },
        {
            "type": "Feature",
            "properties": {"description": "Horrible Harry's", "icon": "bar"},
            "geometry": {"type": "Point", "coordinates": [-77.090372, 38.881189]},
        },
        {
            "type": "Feature",
            "properties": {"description": "Bike Party", "icon": "bicycle"},
            "geometry": {"type": "Point", "coordinates": [-77.052477, 38.943951]},
        },
        {
            "type": "Feature",
            "properties": {"description": "Rockabilly Rockstars", "icon": "music"},
            "geometry": {"type": "Point", "coordinates": [-77.031706, 38.914581]},
        },
        {
            "type": "Feature",
            "properties": {"description": "District Drum Tribe", "icon": "music"},
            "geometry": {"type": "Point", "coordinates": [-77.020945, 38.878241]},
        },
        {
            "type": "Feature",
            "properties": {"description": "Motown Memories", "icon": "music"},
            "geometry": {"type": "Point", "coordinates": [-77.007481, 38.876516]},
        },
    ],
}
source = {"type": "geojson", "data": places}
m.add_source("places", source)

layer = {
    "id": "poi-labels",
    "type": "symbol",
    "source": "places",
    "layout": {
        "text-field": ["get", "description"],
        "text-variable-anchor": ["top", "bottom", "left", "right"],
        "text-radial-offset": 0.5,
        "text-justify": "auto",
        "icon-image": ["concat", ["get", "icon"], "_15"],
    },
}
m.add_layer(layer)
m
```

```{code-cell} ipython3
m.rotate_to(bearing=180, options={"duration": 10000})
```

## Adding Custom Components

Enhance your maps by adding custom components such as images, videos, text, color bars, and legends.

### Adding Image

You can add an image as an overlay or as an icon for a specific layer. For instance:
- Overlaying an image directly on the map at the "bottom-right" corner.
- Adding an icon image to a feature. In the example, a "cat" image is loaded, and a marker is added at coordinates `[0, 0]` with a label "I love kitty!" above the icon.

```{code-cell} ipython3
m = leafmap.Map(center=[0.349419, -1.80921], zoom=3, style="streets")
image = "https://upload.wikimedia.org/wikipedia/commons/7/7c/201408_cat.png"
source = {
    "type": "geojson",
    "data": {
        "type": "FeatureCollection",
        "features": [
            {"type": "Feature", "geometry": {"type": "Point", "coordinates": [0, 0]}}
        ],
    },
}

layer = {
    "id": "points",
    "type": "symbol",
    "source": "point",
    "layout": {
        "icon-image": "cat",
        "icon-size": 0.25,
        "text-field": "I love kitty!",
        "text-font": ["Open Sans Regular"],
        "text-offset": [0, 3],
        "text-anchor": "top",
    },
}
m.add_image("cat", image)
m.add_source("point", source)
m.add_layer(layer)
m
```

![](https://i.imgur.com/Nq1uV9d.png)

```{code-cell} ipython3
m = leafmap.Map(center=[-100, 40], zoom=3, style="positron")
image = "https://i.imgur.com/LmTETPX.png"
m.add_image(image=image, position="bottom-right")
m
```

```{code-cell} ipython3
m = leafmap.Map(center=[-100, 40], zoom=3, style="positron")
content = '<img src="https://i.imgur.com/LmTETPX.png">'
m.add_html(content, bg_color="transparent", position="bottom-right")
m
```

To customize icons, you can also generate icon data with `numpy`, creating unique color gradients and using it as a map icon.

```{code-cell} ipython3
import numpy as np


# Generate the icon data
width = 64  # The image will be 64 pixels square
height = 64
bytes_per_pixel = 4  # Each pixel is represented by 4 bytes: red, green, blue, and alpha
data = np.zeros((width, width, bytes_per_pixel), dtype=np.uint8)

for x in range(width):
    for y in range(width):
        data[y, x, 0] = int((y / width) * 255)  # red
        data[y, x, 1] = int((x / width) * 255)  # green
        data[y, x, 2] = 128  # blue
        data[y, x, 3] = 255  # alpha

# Flatten the data array
flat_data = data.flatten()

# Create the image dictionary
image_dict = {
    "width": width,
    "height": height,
    "data": flat_data.tolist(),
}

m = leafmap.Map(center=[0, 0], zoom=1, style="liberty")
m.add_image("gradient", image_dict)
source = {
    "type": "geojson",
    "data": {
        "type": "FeatureCollection",
        "features": [
            {"type": "Feature", "geometry": {"type": "Point", "coordinates": [0, 0]}}
        ],
    },
}

layer = {
    "id": "points",
    "type": "symbol",
    "source": "point",
    "layout": {"icon-image": "gradient"},
}

m.add_source("point", source)
m.add_layer(layer)
m
```

![](https://i.imgur.com/qWWlnAm.png)

+++

### Adding Text

Add text annotations to the map, specifying parameters like font size and background color. For example:
- Text "Hello World" in the bottom-right corner with a transparent background.
- "Awesome Text!" in the top-left corner with a slightly opaque white background, making it stand out.

```{code-cell} ipython3
m = leafmap.Map(center=[-100, 40], zoom=3, style="liberty")
text = "Hello World"
m.add_text(text, fontsize=20, position="bottom-right")
text2 = "Awesome Text!"
m.add_text(text2, fontsize=25, bg_color="rgba(255, 255, 255, 0.8)", position="top-left")
m
```

![](https://i.imgur.com/UAtlh3r.png)

+++

### Adding GIF

GIFs can be added as animated overlays to bring your map to life. Example: add a sloth GIF in the bottom-right and a second GIF in the bottom-left corner, with a text label indicating “I love sloth!” for added character.

```{code-cell} ipython3
m = leafmap.Map(center=[-100, 40], zoom=3, style="positron")
image = "https://i.imgur.com/KeiAsTv.gif"
m.add_image(image=image, width=250, height=250, position="bottom-right")
text = "I love sloth!🦥"
m.add_text(text, fontsize=35, padding="20px")
image2 = "https://i.imgur.com/kZC2tpr.gif"
m.add_image(image=image2, bg_color="transparent", position="bottom-left")
m
```

![](https://i.imgur.com/auytBtD.png)

+++

### Adding HTML

Embed custom HTML content to display various HTML elements, such as emojis or stylized text. You can also adjust the font size and background transparency for better integration into the map design.

```{code-cell} ipython3
m = leafmap.Map(center=[-100, 40], zoom=3, style="positron")
html = """
<html>
<style>
body {
  font-size: 20px;
}
</style>
<body>

<span style='font-size:100px;'>&#128640;</span>
<p>I will display &#128641;</p>
<p>I will display &#128642;</p>

</body>
</html>
"""
m.add_html(html, bg_color="transparent")
m
```

![](https://i.imgur.com/TgalNOv.png)

+++

### Adding Color bar

Adding a color bar enhances data interpretation. In the example:
1. A Digital Elevation Model (DEM) is displayed with a color ramp from 0 to 1500 meters.
2. `add_colorbar` method is used to create a color bar with labels, adjusting its position, opacity, and orientation for optimal readability.

```{code-cell} ipython3
m = leafmap.Map(style="topo")
dem = "https://github.com/opengeos/datasets/releases/download/raster/dem.tif"
m.add_cog_layer(
    dem,
    name="DEM",
    colormap_name="terrain",
    rescale="0, 1500",
    fit_bounds=True,
    nodata=np.nan,
)
m.add_colorbar(
    cmap="terrain", vmin=0, vmax=1500, label="Elevation (m)", position="bottom-right"
)
m.add_layer_control()
m
```

Make the color bar background transparent to blend seamlessly with the map.

```{code-cell} ipython3
m = leafmap.Map(style="topo")
m.add_cog_layer(
    dem,
    name="DEM",
    colormap_name="terrain",
    rescale="0, 1500",
    nodata=np.nan,
    fit_bounds=True,
)
m.add_colorbar(
    cmap="terrain",
    vmin=0,
    vmax=1500,
    label="Elevation (m)",
    position="bottom-right",
    transparent=True,
)
m
```

Make the color bar vertical for a different layout.

```{code-cell} ipython3
m = leafmap.Map(style="topo")
m.add_cog_layer(
    dem,
    name="DEM",
    colormap_name="terrain",
    rescale="0, 1500",
    nodata=np.nan,
    fit_bounds=True,
)
m.add_colorbar(
    cmap="terrain",
    vmin=0,
    vmax=1500,
    label="Elevation (m)",
    position="bottom-right",
    width=0.2,
    height=3,
    orientation="vertical",
)
m
```

### Adding Legend

Custom legends help users understand data classifications. Two methods are shown:
1. Using built-in legends, such as for NLCD (National Land Cover Database) or wetland types.
2. Custom legends are built with a dictionary of land cover types and colors. This legend provides descriptive color-coding for various land cover types, with configurable background opacity to blend with the map.

```{code-cell} ipython3
m = leafmap.Map(center=[-100, 40], zoom=3, style="positron")
m.add_basemap("Esri.WorldImagery")
url = "https://www.mrlc.gov/geoserver/mrlc_display/NLCD_2021_Land_Cover_L48/wms"
layers = "NLCD_2021_Land_Cover_L48"
m.add_wms_layer(url, layers=layers, name="NLCD 2021")
m.add_legend(
    title="NLCD Land Cover Type",
    builtin_legend="NLCD",
    bg_color="rgba(255, 255, 255, 0.5)",
    position="bottom-left",
)
m
```

```{code-cell} ipython3
m = leafmap.Map(center=[-100, 40], zoom=3, style="positron")
m.add_basemap("Esri.WorldImagery")
url = "https://fwspublicservices.wim.usgs.gov/wetlandsmapservice/services/Wetlands/MapServer/WMSServer"
m.add_wms_layer(url, layers="1", name="NWI", opacity=0.6)
m.add_layer_control()
m.add_legend(builtin_legend="NWI", title="Wetland Type")
m
```

```{code-cell} ipython3
m = leafmap.Map(center=[-100, 40], zoom=3, style="positron")
m.add_basemap("Esri.WorldImagery")
url = "https://www.mrlc.gov/geoserver/mrlc_display/NLCD_2021_Land_Cover_L48/wms"
layers = "NLCD_2021_Land_Cover_L48"
m.add_wms_layer(url, layers=layers, name="NLCD 2021")

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
m.add_legend(
    title="NLCD Land Cover Type",
    legend_dict=legend_dict,
    bg_color="rgba(255, 255, 255, 0.5)",
    position="bottom-left",
)
m
```

![](https://i.imgur.com/dy60trf.png)

+++

### Adding Video

Videos can be added with geographic context by specifying corner coordinates. Videos must be listed in multiple formats to ensure compatibility across browsers. The coordinates array should define the video’s location on the map in the order: top-left, top-right, bottom-right, and bottom-left. This is demonstrated by adding drone footage to a satellite map view, enhancing the user experience with real-world visuals.

```{code-cell} ipython3
m = leafmap.Map(
    center=[-122.514426, 37.562984], zoom=17, bearing=-96, style="satellite"
)
urls = [
    "https://static-assets.mapbox.com/mapbox-gl-js/drone.mp4",
    "https://static-assets.mapbox.com/mapbox-gl-js/drone.webm",
]
coordinates = [
    [-122.51596391201019, 37.56238816766053],
    [-122.51467645168304, 37.56410183312965],
    [-122.51309394836426, 37.563391708549425],
    [-122.51423120498657, 37.56161849366671],
]
m.add_video(urls, coordinates)
m.add_layer_control()
m
```

```{code-cell} ipython3
m = leafmap.Map(center=[-115, 25], zoom=4, style="satellite")
urls = [
    "https://data.opengeos.org/patricia_nasa.mp4",
    "https://data.opengeos.org/patricia_nasa.webm",
]
coordinates = [
    [-130, 32],
    [-100, 32],
    [-100, 13],
    [-130, 13],
]
m.add_video(urls, coordinates)
m.add_layer_control()
m
```

## PMTiles

Leafmap supports visualizing [PMTiles](https://protomaps.com/docs/pmtiles/), which enables efficient storage and fast rendering of vector tiles directly in the browser.

### Protomaps Sample Data

Load Protomaps data in PMTiles format for fast, high-resolution vector map data rendering. Use `pmtiles_metadata()` to fetch details like layer names and map bounds, then style and add these tiles to your map. For instance, the example shows two layers: `buildings` styled in "steelblue" and `roads` styled in "black".

```{code-cell} ipython3
url = "https://open.gishub.org/data/pmtiles/protomaps_firenze.pmtiles"
metadata = leafmap.pmtiles_metadata(url)
print(f"layer names: {metadata['layer_names']}")
print(f"bounds: {metadata['bounds']}")
```

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
    url,
    style=style,
    visible=True,
    opacity=1.0,
    tooltip=True,
)
m
```

```{code-cell} ipython3
m.layer_interact()
```

### Building Footprint Data

Visualize the [Google-Microsoft Open Buildings dataset](https://beta.source.coop/repositories/vida/google-microsoft-open-buildings/description), managed by VIDA, in PMTiles format. Fetch metadata to identify available layers, apply custom styles to the building footprints, and render them with semi-transparent colors for a clear visualization.

```{code-cell} ipython3
url = "https://data.source.coop/vida/google-microsoft-open-buildings/pmtiles/go_ms_building_footprints.pmtiles"
metadata = leafmap.pmtiles_metadata(url)
print(f"layer names: {metadata['layer_names']}")
print(f"bounds: {metadata['bounds']}")
```

```{code-cell} ipython3
m = leafmap.Map(center=[0, 20], zoom=2)
m.add_basemap("Google Hybrid", visible=False)

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

# style = leafmap.pmtiles_style(url)  # Use default style

m.add_pmtiles(
    url,
    style=style,
    visible=True,
    opacity=1.0,
    tooltip=True,
)
m
```

```{code-cell} ipython3
m.layer_interact()
```

### Fields of The World

Visualize the Agricultural Field Boundary dataset - Fields of The World ([FTW](https://fieldsofthe.world)). The dataset is available on Source Cooperative at https://source.coop/repositories/kerner-lab/fields-of-the-world/description.

```{code-cell} ipython3
url = "https://data.source.coop/kerner-lab/fields-of-the-world/ftw-sources.pmtiles"
metadata = leafmap.pmtiles_metadata(url)
print(f"layer names: {metadata['layer_names']}")
print(f"bounds: {metadata['bounds']}")
```

```{code-cell} ipython3
m = leafmap.Map()
# Define colors for each last digit (0-9)
style = {
    "layers": [
        {
            "id": "Field Polygon",
            "source": "example_source",
            "source-layer": "ftw-sources",
            "type": "fill",
            "paint": {
                "fill-color": [
                    "case",
                    ["==", ["%", ["to-number", ["get", "id"]], 10], 0],
                    "#FF5733",  # Color for last digit 0
                    ["==", ["%", ["to-number", ["get", "id"]], 10], 1],
                    "#33FF57",  # Color for last digit 1
                    ["==", ["%", ["to-number", ["get", "id"]], 10], 2],
                    "#3357FF",  # Color for last digit 2
                    ["==", ["%", ["to-number", ["get", "id"]], 10], 3],
                    "#FF33A1",  # Color for last digit 3
                    ["==", ["%", ["to-number", ["get", "id"]], 10], 4],
                    "#FF8C33",  # Color for last digit 4
                    ["==", ["%", ["to-number", ["get", "id"]], 10], 5],
                    "#33FFF6",  # Color for last digit 5
                    ["==", ["%", ["to-number", ["get", "id"]], 10], 6],
                    "#A833FF",  # Color for last digit 6
                    ["==", ["%", ["to-number", ["get", "id"]], 10], 7],
                    "#FF333D",  # Color for last digit 7
                    ["==", ["%", ["to-number", ["get", "id"]], 10], 8],
                    "#33FFBD",  # Color for last digit 8
                    ["==", ["%", ["to-number", ["get", "id"]], 10], 9],
                    "#FF9933",  # Color for last digit 9
                    "#FF0000",  # Fallback color if no match
                ],
                "fill-opacity": 0.5,
            },
        },
        {
            "id": "Field Outline",
            "source": "example_source",
            "source-layer": "ftw-sources",
            "type": "line",
            "paint": {"line-color": "#ffffff", "line-width": 1, "line-opacity": 1},
        },
    ],
}

m.add_basemap("Satellite")
m.add_pmtiles(url, style=style, name="FTW", zoom_to_layer=False)
m.add_layer_control()
m
```

```{code-cell} ipython3
m.layer_interact()
```

```{code-cell} ipython3
m = leafmap.Map()
style = {
    "layers": [
        {
            "id": "Field Polygon",
            "source": "example_source",
            "source-layer": "ftw-sources",
            "type": "fill",
            "paint": {
                "fill-color": "#ffff00",
                "fill-opacity": 0.2,
            },
        },
        {
            "id": "Field Outline",
            "source": "example_source",
            "source-layer": "ftw-sources",
            "type": "line",
            "paint": {"line-color": "#ff0000", "line-width": 1, "line-opacity": 1},
        },
    ],
}

m.add_basemap("Satellite")
m.add_pmtiles(url, style=style, name="FTW", zoom_to_layer=False)
m.add_layer_control()
m
```

```{code-cell} ipython3
m.layer_interact()
```

### 3D PMTiles

Render global building data in 3D for a realistic, textured experience. Set building colors and extrusion heights to create visually compelling cityscapes. For example, apply color gradients and height scaling based on building attributes to differentiate buildings by their heights.

```{code-cell} ipython3
url = "https://data.source.coop/cholmes/overture/overture-buildings.pmtiles"
metadata = leafmap.pmtiles_metadata(url)
print(f"layer names: {metadata['layer_names']}")
print(f"bounds: {metadata['bounds']}")
```

```{code-cell} ipython3
m = leafmap.Map(
    center=[-74.0095, 40.7046], zoom=16, pitch=60, bearing=-17, style="positron"
)
m.add_basemap("OpenStreetMap.Mapnik")
m.add_basemap("Esri.WorldImagery", visible=False)

style = {
    "layers": [
        {
            "id": "buildings",
            "source": "example_source",
            "source-layer": "buildings",
            "type": "fill-extrusion",
            "filter": [
                ">",
                ["get", "height"],
                0,
            ],  # only show buildings with height info
            "paint": {
                "fill-extrusion-color": [
                    "interpolate",
                    ["linear"],
                    ["get", "height"],
                    0,
                    "lightgray",
                    200,
                    "royalblue",
                    400,
                    "lightblue",
                ],
                "fill-extrusion-height": ["*", ["get", "height"], 1],
            },
        },
    ],
}

m.add_pmtiles(
    url,
    style=style,
    visible=True,
    opacity=1.0,
    tooltip=True,
    template="Height: {{height}}<br>Country: {{country_iso}}",
    fit_bounds=False,
)
m.add_layer_control()
m
```

### 3D Buildings

For a simplified setup, the `add_overture_3d_buildings` function quickly adds 3D building data from Overture’s latest release to a basemap, creating depth and spatial realism on the map.

```{code-cell} ipython3
m = leafmap.Map(
    center=[-74.0095, 40.7046], zoom=16, pitch=60, bearing=-17, style="positron"
)
m.add_basemap("Esri.WorldImagery", visible=False)
m.add_overture_3d_buildings(release="2024-09-18", template="simple")
m.add_layer_control()
m
```

### 2D Buildings, Transportation, and Other Themes

Switch between specific Overture themes, such as `buildings`, `transportation`, `places`, or `addresses`, depending on the data focus. Each theme overlays relevant features with adjustable opacity for thematic visualization, providing easy customization for urban planning or transportation studies.

Building theme:

```{code-cell} ipython3
m = leafmap.Map(center=[-74.0095, 40.7046], zoom=16)
m.add_basemap("Esri.WorldImagery", visible=False)
m.add_overture_data(theme="buildings", opacity=0.8)
m.add_layer_control()
m
```

Transportation theme:

```{code-cell} ipython3
m = leafmap.Map(center=[-74.0095, 40.7046], zoom=16)
m.add_basemap("Esri.WorldImagery", visible=False)
m.add_overture_data(theme="transportation", opacity=0.8)
m.add_layer_control()
m
```

Places theme:

```{code-cell} ipython3
m = leafmap.Map(center=[-74.0095, 40.7046], zoom=16)
m.add_basemap("Esri.WorldImagery", visible=False)
m.add_overture_data(theme="places", opacity=0.8)
m.add_layer_control()
m
```

Addresses theme:

```{code-cell} ipython3
m = leafmap.Map(center=[-74.0095, 40.7046], zoom=16)
m.add_basemap("Esri.WorldImagery", visible=False)
m.add_overture_data(theme="addresses", opacity=0.8)
m.add_layer_control()
m
```

Base theme:

```{code-cell} ipython3
m = leafmap.Map(center=[-74.0095, 40.7046], zoom=16)
m.add_basemap("Esri.WorldImagery", visible=False)
m.add_overture_data(theme="base", opacity=0.8)
m.add_layer_control()
m
```

Divisions themem:

```{code-cell} ipython3
m = leafmap.Map()
m.add_basemap("Esri.WorldImagery", visible=False)
m.add_overture_data(theme="divisions", opacity=0.8)
m.add_layer_control()
m
```

## Deck.GL Layers

Integrate interactive, high-performance visualization layers using Deck.GL. Leafmap’s `add_deck_layer` method supports multiple Deck.GL layer types, including Grid, GeoJSON, and Arc layers.

### Single Deck.GL Layer

Add a `GridLayer` to visualize point data, such as the density of bike parking in San Francisco. Customize the grid cell size, elevation, and color to represent data density visually and interactively.

```{code-cell} ipython3
m = leafmap.Map(
    style="positron",
    center=(-122.4, 37.74),
    zoom=12,
    pitch=40,
)
deck_grid_layer = {
    "@@type": "GridLayer",
    "id": "GridLayer",
    "data": "https://raw.githubusercontent.com/visgl/deck.gl-data/master/website/sf-bike-parking.json",
    "extruded": True,
    "getPosition": "@@=COORDINATES",
    "getColorWeight": "@@=SPACES",
    "getElevationWeight": "@@=SPACES",
    "elevationScale": 4,
    "cellSize": 200,
    "pickable": True,
}

m.add_deck_layers([deck_grid_layer], tooltip="Number of points: {{ count }}")
m
```

### Multiple Deck.GL Layers

Combine layers like `GeoJsonLayer` and `ArcLayer` for complex visualizations. For example:
1. Use `GeoJsonLayer` to show airports with varying point sizes based on significance.
2. Use `ArcLayer` to connect selected airports with London, coloring arcs to represent different paths.

```{code-cell} ipython3
url = "https://d2ad6b4ur7yvpq.cloudfront.net/naturalearth-3.3.0/ne_10m_airports.geojson"
data = leafmap.read_geojson(url)
```

```{code-cell} ipython3
m = leafmap.Map(
    style="positron",
    center=(0.45, 51.47),
    zoom=4,
    pitch=30,
)
deck_geojson_layer = {
    "@@type": "GeoJsonLayer",
    "id": "airports",
    "data": data,
    "filled": True,
    "pointRadiusMinPixels": 2,
    "pointRadiusScale": 2000,
    "getPointRadius": "@@=11 - properties.scalerank",
    "getFillColor": [200, 0, 80, 180],
    "autoHighlight": True,
    "pickable": True,
}

deck_arc_layer = {
    "@@type": "ArcLayer",
    "id": "arcs",
    "data": [
        feature
        for feature in data["features"]
        if feature["properties"]["scalerank"] < 4
    ],
    "getSourcePosition": [-0.4531566, 51.4709959],  # London
    "getTargetPosition": "@@=geometry.coordinates",
    "getSourceColor": [0, 128, 200],
    "getTargetColor": [200, 0, 80],
    "getWidth": 2,
    "pickable": True,
}

m.add_deck_layers(
    [deck_geojson_layer, deck_arc_layer],
    tooltip={
        "airports": "{{ &properties.name }}",
        "arcs": "gps_code: {{ properties.gps_code }}",
    },
)
m
```

The result is a rich, interactive visualization that highlights both point data and relational data connections, useful for airport connectivity or hub-and-spoke modeling.


## Google Earth Engine

Leafmap enables integration with the Google Earth Engine (GEE) Python API, allowing for powerful visualization of Earth Engine datasets directly on a Leafmap map.

To add Earth Engine layers, initialize a map and use `add_ee_layer` to add specific datasets, such as ESA WorldCover data. A legend can be included using `add_legend` to provide a visual reference.

```{code-cell} ipython3
m = leafmap.Map(
    center=[-120.4482, 38.0399], zoom=13, pitch=60, bearing=30, style="3d-terrain"
)
m.add_ee_layer(asset_id="ESA/WorldCover/v200", opacity=0.5)
m.add_legend(builtin_legend="ESA_WorldCover", title="ESA Landcover")
m.add_layer_control()
m
```

```{code-cell} ipython3
m.layer_interact()
```

![](https://i.imgur.com/oHQDf79.png)

+++

You can overlay Earth Engine data with other 3D elements, like buildings, to create a multi-layered, interactive map.

```{code-cell} ipython3
m = leafmap.Map(
    center=[-74.012998, 40.70414], zoom=15.6, pitch=60, bearing=30, style="3d-terrain"
)
m.add_ee_layer(asset_id="ESA/WorldCover/v200", opacity=0.5)
m.add_3d_buildings()
m.add_legend(builtin_legend="ESA_WorldCover", title="ESA Landcover")
m
```

![](https://i.imgur.com/Y52jep5.png)

+++

If you have an Earth Engine account, authenticate and initialize Earth Engine in your notebook by uncommenting the relevant code.

```{code-cell} ipython3
# import ee

# ee.Authenticate()
# ee.Initialize(project="YOUR-PROJECT-ID")
```

```{code-cell} ipython3
# m = leafmap.Map(center=[-120.4482, 38.03994], zoom=13, pitch=60, bearing=30, style="3d-terrain")
# dataset = ee.ImageCollection("ESA/WorldCover/v200").first()
# vis_params = {"bands": ["Map"]}
# m.add_ee_layer(dataset, vis_params, name="ESA Worldcover", opacity=0.5)
# m.add_legend(builtin_legend="ESA_WorldCover", title="ESA Landcover")
# m.add_layer_control()
# m
```

## Animations

### Animating a Line

Using Leafmap’s animation capabilities, you can animate a line by updating the coordinates of a GeoJSON line feature in real-time. The sample includes data loaded from a CSV file, which is sorted and plotted sequentially to show the line’s movement.

```{code-cell} ipython3
import time
import pandas as pd
```

```{code-cell} ipython3
url = "https://github.com/opengeos/datasets/releases/download/world/animated_line_data.csv"
df = pd.read_csv(url)
df_sample = df.sample(n=1000, random_state=1).sort_index()
df_sample.loc[len(df_sample)] = df.iloc[-1]
df_sample.head()
```

```{code-cell} ipython3
m = leafmap.Map(center=[0, 0], zoom=0.5, style="liberty")
geojson = {
    "type": "FeatureCollection",
    "features": [
        {"type": "Feature", "geometry": {"type": "LineString", "coordinates": [[0, 0]]}}
    ],
}
source = {"type": "geojson", "data": geojson}
m.add_source("line", source)
layer = {
    "id": "line-animation",
    "type": "line",
    "source": "line",
    "layout": {"line-cap": "round", "line-join": "round"},
    "paint": {"line-color": "#ed6498", "line-width": 5, "line-opacity": 0.8},
}
m.add_layer(layer)
m
```

```{code-cell} ipython3
run_times = 2
for i in range(run_times):
    geojson["features"][0]["geometry"]["coordinates"] = [[0, 0]]
    for row in df_sample.itertuples():
        time.sleep(0.005)
        geojson["features"][0]["geometry"]["coordinates"].append([row.x, row.y])
        m.set_data("line", geojson)
```

![](https://i.imgur.com/LRwfBl9.png)

+++

### Animating the Map Camera Around a Point

Control the map camera's rotation, zoom, and angle around a given point to create a smooth animation effect. This technique is especially useful for visualizing cityscapes or other 3D environments by making buildings appear dynamic.

```{code-cell} ipython3
m = leafmap.Map(center=[-87.62712, 41.89033], zoom=15, pitch=45, style="streets")
layers = m.get_style_layers()
for layer in layers:
    if layer["type"] == "symbol" and ("text-field" in layer["layout"]):
        m.remove_layer(layer["id"])
layer = {
    "id": "3d-buildings",
    "source": "composite",
    "source-layer": "building",
    "filter": ["==", "extrude", "true"],
    "type": "fill-extrusion",
    "min_zoom": 15,
    "paint": {
        "fill-extrusion-color": "#aaa",
        "fill-extrusion-height": [
            "interpolate",
            ["linear"],
            ["zoom"],
            15,
            0,
            15.05,
            ["get", "height"],
        ],
        "fill-extrusion-base": [
            "interpolate",
            ["linear"],
            ["zoom"],
            15,
            0,
            15.05,
            ["get", "min_height"],
        ],
        "fill-extrusion-opacity": 0.6,
    },
}
m.add_layer(layer)
m
```

```{code-cell} ipython3
for degree in range(0, 180, 1):
    m.rotate_to(degree, {"duration": 0})
    time.sleep(0.1)
```

![](https://i.imgur.com/odCwtjT.png)

+++

### Animating a Point

Animate a point along a circular path by computing points on a circle and updating the map. This is ideal for showing circular motion on the map, and can be customized for duration and frame rate to control the animation speed.

```{code-cell} ipython3
import math
```

```{code-cell} ipython3
def point_on_circle(angle, radius):
    return {
        "type": "Point",
        "coordinates": [math.cos(angle) * radius, math.sin(angle) * radius],
    }
```

```{code-cell} ipython3
m = leafmap.Map(center=[0, 0], zoom=2, style="liberty")
radius = 20
source = {"type": "geojson", "data": point_on_circle(0, radius)}
m.add_source("point", source)
layer = {
    "id": "point",
    "source": "point",
    "type": "circle",
    "paint": {"circle-radius": 10, "circle-color": "#007cbf"},
}
m.add_layer(layer)
m
```

```{code-cell} ipython3
def animate_marker(duration, frame_rate, radius):
    start_time = time.time()
    while (time.time() - start_time) < duration:
        timestamp = (time.time() - start_time) * 1000  # Convert to milliseconds
        angle = timestamp / 1000  # Divisor controls the animation speed
        point = point_on_circle(angle, radius)
        m.set_data("point", point)
        # Wait for the next frame
        time.sleep(1 / frame_rate)
```

```{code-cell} ipython3
duration = 10  # Duration of the animation in seconds
frame_rate = 30  # Frames per second
```

```{code-cell} ipython3
animate_marker(duration, frame_rate, radius)
```

![](https://i.imgur.com/EAxNQx4.png)

+++

### Animating a Point Along a Route

Create a point that follows a route specified by GeoJSON coordinates. For added realism, include rotation properties to simulate the direction of movement along the path. This animation is useful for tracking paths, such as vehicle or drone routes.

```{code-cell} ipython3
m = leafmap.Map(center=[-100, 40], zoom=3, style="streets")
url = "https://github.com/opengeos/datasets/releases/download/us/arc_with_bearings.geojson"
geojson = leafmap.read_geojson(url)
bearings = geojson["features"][0]["properties"]["bearings"]
coordinates = geojson["features"][0]["geometry"]["coordinates"][:-1]
m.add_geojson(geojson, name="route")

origin = [-122.414, 37.776]
destination = [-77.032, 38.913]

point = {
    "type": "FeatureCollection",
    "features": [
        {
            "type": "Feature",
            "properties": {},
            "geometry": {"type": "Point", "coordinates": origin},
        }
    ],
}
source = {"type": "geojson", "data": point}
m.add_source("point", source)
layer = {
    "id": "point",
    "source": "point",
    "type": "symbol",
    "layout": {
        "icon-image": "airport_15",
        "icon-rotate": ["get", "bearing"],
        "icon-rotation-alignment": "map",
        "icon-overlap": "always",
        "icon-ignore-placement": True,
    },
}
m.add_layer(layer)
m
```

```{code-cell} ipython3
for index, coordinate in enumerate(coordinates):
    point["features"][0]["geometry"]["coordinates"] = coordinate
    point["features"][0]["properties"]["bearing"] = bearings[index]
    m.set_data("point", point)
    time.sleep(0.05)
```

![](https://i.imgur.com/kdP1oT1.png)

+++

### Updating a Feature in Real-Time

For applications such as tracking or tracing a path in real time, load data from a source like GeoDataFrame, append coordinates incrementally to a line feature, and update the map display as the path extends.

```{code-cell} ipython3
import geopandas as gpd
```

```{code-cell} ipython3
m = leafmap.Map(center=[-122.019807, 45.632433], zoom=14, pitch=60, style="3d-terrain")
m
```

```{code-cell} ipython3
url = "https://maplibre.org/maplibre-gl-js/docs/assets/hike.geojson"
gdf = gpd.read_file(url)
coordinates = list(gdf.geometry[0].coords)
print(coordinates[:5])
```

```{code-cell} ipython3
source = {
    "type": "geojson",
    "data": {
        "type": "Feature",
        "geometry": {"type": "LineString", "coordinates": [coordinates[0]]},
    },
}
m.add_source("trace", source)
layer = {
    "id": "trace",
    "type": "line",
    "source": "trace",
    "paint": {"line-color": "yellow", "line-opacity": 0.75, "line-width": 5},
}
m.add_layer(layer)
m.jump_to({"center": coordinates[0], "zoom": 14})
m.set_pitch(30)
```

```{code-cell} ipython3
for coord in coordinates:
    time.sleep(0.005)
    source["data"]["geometry"]["coordinates"].append(coord)
    m.set_data("trace", source["data"])
    m.pan_to(coord)
```

## To HTML

Export the final map to HTML using the `to_html` method. This allows you to share interactive maps online while keeping your private API keys secure. Create public API keys restricted to your website’s domain for safety. Customize the HTML output, including dimensions, title, and embedding options.

```{code-cell} ipython3
# import os
# os.environ["MAPTILER_KEY"] = "YOUR_PRIVATE_API_KEY"
# os.environ["MAPTILER_KEY_PUBLIC"] = "YOUR_PUBLIC_API_KEY"
```

```{code-cell} ipython3
m = leafmap.Map(
    center=[-122.19861, 46.21168], zoom=13, pitch=60, bearing=150, style="3d-terrain"
)
m.add_layer_control(bg_layers=True)
m.to_html(
    "terrain.html",
    title="Awesome 3D Map",
    width="100%",
    height="100%",
    replace_key=True,
)
m
```

```{code-cell} ipython3
m = leafmap.Map(
    center=[-74.0066, 40.7135], zoom=16, pitch=45, bearing=-17, style="basic-v2"
)
m.add_basemap("Esri.WorldImagery", visible=False)
m.add_3d_buildings(min_zoom=15)
m.add_layer_control()
m.to_html(
    "buildings.html",
    title="Awesome 3D Map",
    width="100%",
    height="100%",
    replace_key=True,
)
m
```

## Exercises

### Exercise 1: Setting up MapLibre and Basic Map Creation

   - Initialize a map centered on a country of your choice with an appropriate zoom level and display it with the `dark-matter` basemap.
   - Change the basemap style to `liberty` and display it again.

```{code-cell} ipython3

```

### Exercise 2: Customizing the Map View

   - Create a 3D map of a city of your choice with an appropriate zoom level, pitch and bearing using the `liberty` basemap.
   - Experiment with MapTiler 3D basemap styles, such as `3d-satellite`, `3d-hybrid`, and `3d-topo`, to visualize a location of your choice in different ways. Please set your MapTiler API key as Colab secret and do NOT expose the API key in the notebook.

```{code-cell} ipython3

```

### Exercise 3: Adding Map Controls

   - Create a map centered on a city of your choice and add the following controls to the map:
     - **Geolocate** control positioned at the top left.
     - **Fullscreen** control at the top right.
     - **Draw** control for adding points, lines, and polygons, positioned at the top left.

```{code-cell} ipython3

```

### Exercise 4: Overlaying Data Layers

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

### Exercise 5: Working with 3D Buildings

   - Set up a 3D map centered on a city of your choice with an appropriate zoom level, pitch, and bearing.
   - Add 3D buildings to the map with extrusions based on their height attributes. Use a custom color gradient for the extrusion color.

```{code-cell} ipython3

```

### Exercise 6: Adding Map Elements
   - **Image and Text**: Add a logo image of your choice with appropriate text to the map.
   - **GIF**: Add an animated GIF of your choice to the map.

```{code-cell} ipython3

```

## Summary

In this lecture, we explored the functionality of the MapLibre library for creating and customizing interactive maps in Python. We covered how to build a map from scratch, add controls, and manage different basemaps. Additionally, we explored more complex visualizations, including 3D building and terrain views, layer customization, and data integration with GeoJSON and raster formats. By understanding and applying these techniques, students are now equipped to develop dynamic geospatial visualizations using MapLibre, enhancing both analytical and presentation capabilities in their GIS projects.
