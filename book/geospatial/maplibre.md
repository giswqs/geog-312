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

This lecture introduces the [MapLibre](https://github.com/eodaGmbH/py-maplibregl) Python package, a flexible open-source mapping Python package that allows users to create interactive and customizable 3D and 2D maps in Python. By leveraging the MapLibre library, GIS developers can visualize geospatial data with a variety of customization options and mapping styles. The notebook demonstrates essential concepts like creating interactive maps, customizing basemaps, adding various data layers, and implementing map controls for enhanced functionality. Additionally, advanced features, such as 3D building visualization and layer control, provide students with practical tools for real-world geospatial data analysis and visualization.

## Learning Outcomes

By the end of this lecture, students will be able to:

1. Set up and install MapLibre for geospatial visualization in Python.
2. Create basic interactive maps and apply different basemap styles.
3. Customize map features, including markers, lines, polygons, and map controls.
4. Utilize advanced features such as 3D buildings and choropleth maps.
5. Integrate and manage multiple data layers, including GeoJSON, raster, and vector layers.
6. Export map visualizations as standalone HTML files for sharing and deployment.

## Useful Resources

- Notebooks: https://leafmap.org/maplibre/overview
- Videos: https://bit.ly/maplibre
- Demos: https://maps.gishub.org

## Installation

Uncomment the following line to install the required Python packages.

```{code-cell} ipython3
# %pip install -U "leafmap[maplibre]"
```

Import the maplibre mapping backend.

```{code-cell} ipython3
import leafmap.maplibregl as leafmap
```

## Create interactive maps

Let's create a simple interactive map using Leafmap.

```{code-cell} ipython3
m = leafmap.Map()
m
```

You can customize the map by specifying map center [lon, lat], zoom level, pitch, and bearing.

```{code-cell} ipython3
m = leafmap.Map(center=[-100, 40], zoom=3, pitch=0, bearing=0)
m
```

To customize the basemap, you can specify the `style` parameter. It can be an URL or a string, such as `dark-matter`, `positron`, `voyager`, `liberty`, `demotiles`.

```{code-cell} ipython3
m = leafmap.Map(style="positron")
m
```

To create a map with a background color, use `style="background-<COLOR>"`, such as `background-lightgray` and `background-green`.

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

```{code-cell} ipython3
m = leafmap.Map(style="liberty")
m
```

## Add map controls

The control to add to the map. Can be one of the following: `scale`, `fullscreen`, `geolocate`, `navigation`.

### Geolocate control

```{code-cell} ipython3
m = leafmap.Map()
m.add_control("geolocate", position="top-left")
m
```

### Fullscreen control

```{code-cell} ipython3
m = leafmap.Map(center=[11.255, 43.77], zoom=13, style="streets", controls={})
m.add_control("fullscreen", position="top-right")
m
```

### Navigation control

```{code-cell} ipython3
m = leafmap.Map(center=[11.255, 43.77], zoom=13, style="streets", controls={})
m.add_control("navigation", position="top-left")
m
```

### Draw control

Add the default draw control.

```{code-cell} ipython3
m = leafmap.Map(center=[-100, 40], zoom=3, style="positron")
m.add_draw_control(position="top-left")
m
```

Only activate a give set of control.

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

Load a GeoJSON FeatureCollection to the draw control.

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

Retrieve the draw features.

```{code-cell} ipython3
m.draw_features_selected
```

```{code-cell} ipython3
m.draw_feature_collection_all
```

```{code-cell} ipython3
m = leafmap.Map(center=[-122.65, 45.52], zoom=9, scroll_zoom=False, style="liberty")
m
```

## Add layers

### Add basemaps

You can add basemaps to the map using the `add_basemap` method.

```{code-cell} ipython3
m = leafmap.Map()
m.add_basemap("OpenTopoMap")
m
```

```{code-cell} ipython3
m.add_basemap("Esri.WorldImagery")
```

```{code-cell} ipython3
m = leafmap.Map()
m
```

To add basemaps interactively, use the `add_basemap` method without specifying the `basemap` parameter.

```{code-cell} ipython3
m.add_basemap()
```

### Add XYZ tile layer

You can add XYZ tile layers to the map using the `add_tile_layer` method.

```{code-cell} ipython3
m = leafmap.Map()
url = "https://basemap.nationalmap.gov/arcgis/rest/services/USGSTopo/MapServer/tile/{z}/{y}/{x}"
m.add_tile_layer(url, name="USGS TOpo", attribution="USGS", opacity=1.0, visible=True)
m
```

### Add WMS layer

You can add WMS layers to the map using the `add_wms_layer` method.

```{code-cell} ipython3
m = leafmap.Map(center=[-74.5447, 40.6892], zoom=8, style="streets")
url = "https://img.nj.gov/imagerywms/Natural2015"
layers = "Natural2015"
m.add_wms_layer(url, layers=layers, before_id="aeroway_fill")
m
```

```{code-cell} ipython3
m = leafmap.Map(center=[-100.307965, 46.98692], zoom=13, pitch=45, style="3d-hybrid")
url = "https://fwspublicservices.wim.usgs.gov/wetlandsmapservice/services/Wetlands/MapServer/WMSServer"
m.add_wms_layer(url, layers="1", name="NWI", opacity=0.6)
m.add_layer_control(bg_layers=True)
m.add_legend(builtin_legend="NWI", title="Wetland Type")
m
```

```{code-cell} ipython3
m = leafmap.Map(center=[-74.5447, 40.6892], zoom=8, style="streets")

source = {
    "type": "raster",
    "tiles": [
        "https://img.nj.gov/imagerywms/Natural2015?bbox={bbox-epsg-3857}&format=image/png&service=WMS&version=1.1.1&request=GetMap&srs=EPSG:3857&transparent=true&width=256&height=256&layers=Natural2015"
    ],
    "tileSize": 256,
}
layer = {
    "id": "wms-test-layer",
    "type": "raster",
    "source": "wms-test-source",
    "paint": {},
}
m.add_source("wms-test-source", source)
m.add_layer(layer, before_id="aeroway_fill")
m
```

### Add raster tile

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

### Add a vector tile source

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

## MapTiler
To run this notebook, you need to set up a MapTiler API key. You can get a free API key by signing up at [https://cloud.maptiler.com/](https://cloud.maptiler.com/).

```{code-cell} ipython3
# import os
# os.environ["MAPTILER_KEY"] = "YOUR_API_KEY"
```

You can use any named style from MapTiler by setting the style parameter to the name of the style.

![](https://i.imgur.com/dp2HxR2.png)

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

## 3D mapping

### 3D terrain

MapTiler provides a variety of basemaps and styles that can be used to create 3D maps. You can use any styles from the MapTiler basemap gallery and prefix the style name with `3d-`. For example, `3d-hybrid`, `3d-satellite`, or `3d-topo`. To use the hillshade only, you can use the `3d-hillshade` style.

```{code-cell} ipython3
m = leafmap.Map(style="3d-hybrid")
m.add_layer_control(bg_layers=True)
m
```

```{code-cell} ipython3
m = leafmap.Map(style="3d-satellite")
m.add_layer_control(bg_layers=True)
m
```

```{code-cell} ipython3
m = leafmap.Map(style="3d-topo", exaggeration=1.5, hillshade=False)
m.add_layer_control(bg_layers=True)
m
```

```{code-cell} ipython3
m = leafmap.Map(style="3d-ocean", exaggeration=1.5, hillshade=True)
m.add_layer_control(bg_layers=True)
m
```

```{code-cell} ipython3
m = leafmap.Map(
    center=[-122.19861, 46.21168], zoom=13, pitch=60, bearing=150, style="3d-terrain"
)
m.add_layer_control(bg_layers=True)
m
```

### 3D buildings

You can add 3D buildings to the map using the `add_3d_buildings` method.

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

```{code-cell} ipython3
m = leafmap.Map(
    center=[-74.01201, 40.70473], zoom=16, pitch=60, bearing=35, style="basic-v2"
)
m.add_basemap("Esri.WorldImagery", visible=False)
m.add_3d_buildings(min_zoom=15)
m.add_layer_control()
m
```

### 3D indoor mapping

Let's visualize indoor mapping data using the `add_geojson` method.

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

### 3D choropleth map

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

## Visualize vector data

Leafmap provides a variety of methods to visualize vector data on the map.

### Point data

```{code-cell} ipython3
m = leafmap.Map(center=[12.550343, 55.665957], zoom=8, style="positron")
m.add_marker(lng_lat=[12.550343, 55.665957])
m
```

```{code-cell} ipython3
m = leafmap.Map(center=[0, 0], zoom=2, style="streets")
m.add_marker(lng_lat=[0, 0], options={"draggable": True})
m
```

```{code-cell} ipython3
import requests
```

```{code-cell} ipython3
url = (
    "https://github.com/opengeos/datasets/releases/download/world/world_cities.geojson"
)
geojson = requests.get(url).json()
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

### Customize marker icon image

```{code-cell} ipython3
url = (
    "https://github.com/opengeos/datasets/releases/download/world/world_cities.geojson"
)
geojson = requests.get(url).json()
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

```{code-cell} ipython3
m = leafmap.Map(center=[0, 0], zoom=1, style="positron")
image = "https://maplibre.org/maplibre-gl-js/docs/assets/osgeo-logo.png"
m.add_image("custom-marker", image)
source = {
    "type": "geojson",
    "data": {
        "type": "FeatureCollection",
        "features": [
            {
                "type": "Feature",
                "geometry": {"type": "Point", "coordinates": [100.4933, 13.7551]},
                "properties": {"year": "2004"},
            },
            {
                "type": "Feature",
                "geometry": {"type": "Point", "coordinates": [6.6523, 46.5535]},
                "properties": {"year": "2006"},
            },
            {
                "type": "Feature",
                "geometry": {"type": "Point", "coordinates": [-123.3596, 48.4268]},
                "properties": {"year": "2007"},
            },
            {
                "type": "Feature",
                "geometry": {"type": "Point", "coordinates": [18.4264, -33.9224]},
                "properties": {"year": "2008"},
            },
            {
                "type": "Feature",
                "geometry": {"type": "Point", "coordinates": [151.195, -33.8552]},
                "properties": {"year": "2009"},
            },
            {
                "type": "Feature",
                "geometry": {"type": "Point", "coordinates": [2.1404, 41.3925]},
                "properties": {"year": "2010"},
            },
            {
                "type": "Feature",
                "geometry": {"type": "Point", "coordinates": [-104.8548, 39.7644]},
                "properties": {"year": "2011"},
            },
            {
                "type": "Feature",
                "geometry": {"type": "Point", "coordinates": [-1.1665, 52.9539]},
                "properties": {"year": "2013"},
            },
            {
                "type": "Feature",
                "geometry": {"type": "Point", "coordinates": [-122.6544, 45.5428]},
                "properties": {"year": "2014"},
            },
            {
                "type": "Feature",
                "geometry": {"type": "Point", "coordinates": [126.974, 37.5651]},
                "properties": {"year": "2015"},
            },
            {
                "type": "Feature",
                "geometry": {"type": "Point", "coordinates": [7.1112, 50.7255]},
                "properties": {"year": "2016"},
            },
            {
                "type": "Feature",
                "geometry": {"type": "Point", "coordinates": [-71.0314, 42.3539]},
                "properties": {"year": "2017"},
            },
            {
                "type": "Feature",
                "geometry": {"type": "Point", "coordinates": [39.2794, -6.8173]},
                "properties": {"year": "2018"},
            },
            {
                "type": "Feature",
                "geometry": {"type": "Point", "coordinates": [26.0961, 44.4379]},
                "properties": {"year": "2019"},
            },
            {
                "type": "Feature",
                "geometry": {"type": "Point", "coordinates": [-114.0879, 51.0279]},
                "properties": {"year": "2020"},
            },
        ],
    },
}

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

### Line data

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

### Polygon data

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

### Multiple geometries

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

### Marker cluster

Create a marker cluster layer.

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

### Local vector data

You can load local vector data interactively using the `open_geojson` method.

```{code-cell} ipython3
m = leafmap.Map(center=[-100, 40], zoom=3)
m
```

```{code-cell} ipython3
url = "https://github.com/opengeos/datasets/releases/download/us/us_states.geojson"
filepath = "data/us_states.geojson"
leafmap.download_file(url, filepath, quiet=True)
```

```{code-cell} ipython3
m.open_geojson()
```

### GeoPandas

```{code-cell} ipython3
import geopandas as gpd
```

```{code-cell} ipython3
m = leafmap.Map(center=[-100, 40], zoom=3, style="streets")
url = "https://github.com/opengeos/datasets/releases/download/us/us_states.geojson"
gdf = gpd.read_file(url)
paint = {
    "fill-color": "#3388ff",
    "fill-opacity": 0.8,
    "fill-outline-color": "#ffffff",
}
m.add_gdf(gdf, layer_type="fill", name="States", paint=paint)
m
```

### Change building color

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
m
```

```{code-cell} ipython3
m.add_call("zoomTo", 19, {"duration": 9000})
```

### Add a new layer below labels

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

### Heat map

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

### Visualize population density

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

## Visualize raster data

### Local raster data

You can load local raster data using the `add_raster` method.

```{code-cell} ipython3
url = "https://github.com/opengeos/datasets/releases/download/raster/landsat.tif"
filepath = "landsat.tif"
leafmap.download_file(url, filepath, quiet=True)
```

```{code-cell} ipython3
m = leafmap.Map(style="streets")
m.add_raster(filepath, indexes=[3, 2, 1], vmin=0, vmax=100, name="Landsat-321")
m.add_raster(filepath, indexes=[4, 3, 2], vmin=0, vmax=100, name="Landsat-432")
m
```

```{code-cell} ipython3
m.layer_interact()
```

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

You can load Cloud Optimized GeoTIFF (COG) data using the `add_cog_layer` method.

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
m
```

```{code-cell} ipython3
m.layer_interact()
```

### STAC layer

You can load SpatioTemporal Asset Catalog (STAC) data using the `add_stac_layer` method.

```{code-cell} ipython3
m = leafmap.Map(style="streets")
url = "https://canada-spot-ortho.s3.amazonaws.com/canada_spot_orthoimages/canada_spot5_orthoimages/S5_2007/S5_11055_6057_20070622/S5_11055_6057_20070622.json"
m.add_stac_layer(url, bands=["pan"], name="Panchromatic", vmin=0, vmax=150)
m.add_stac_layer(url, bands=["B4", "B3", "B2"], name="RGB", vmin=0, vmax=150)
m
```

```{code-cell} ipython3
m.layer_interact()
```

```{code-cell} ipython3
collection = "landsat-8-c2-l2"
item = "LC08_L2SP_047027_20201204_02_T1"
```

```{code-cell} ipython3
leafmap.stac_assets(collection=collection, item=item, titiler_endpoint="pc")
```

```{code-cell} ipython3
m = leafmap.Map(style="streets")
m.add_stac_layer(
    collection=collection,
    item=item,
    assets=["SR_B5", "SR_B4", "SR_B3"],
    name="Color infrared",
)
m
```

## Interact with the map

+++

### Display a non-interactive map

```{code-cell} ipython3
m = leafmap.Map(
    center=[-74.5, 40], zoom=9, interactive=False, style="streets", controls={}
)
m
```

### Disable scroll zoom

```{code-cell} ipython3
m = leafmap.Map(center=[-122.65, 45.52], zoom=9, scroll_zoom=False, style="liberty")
m
```

### Fit bounds

```{code-cell} ipython3
m = leafmap.Map(center=[-74.5, 40], zoom=9, style="streets")
m
```

Fit to Kenya.

```{code-cell} ipython3
bounds = [[32.958984, -5.353521], [43.50585, 5.615985]]
m.fit_bounds(bounds)
```

```{code-cell} ipython3
m = leafmap.Map(center=[-77.0214, 38.897], zoom=12, style="streets")

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

### Restrict map panning to an area

```{code-cell} ipython3
bounds = [
    [-74.04728500751165, 40.68392799015035],
    [-73.91058699000139, 40.87764500765852],
]
```

```{code-cell} ipython3
m = leafmap.Map(center=[-73.9978, 40.7209], zoom=13, max_bounds=bounds, style="streets")
m
```

### Fly to

```{code-cell} ipython3
m = leafmap.Map(center=[-2.242467, 53.478122], zoom=9, style="streets")
m
```

```{code-cell} ipython3
m.fly_to(lon=-73.983609, lat=40.754368, zoom=12)
```

```{code-cell} ipython3
m = leafmap.Map(center=[-74.5, 40], zoom=9, style="streets")
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

### Jump to a series of locations

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

### Get coordinates of the mouse pointer

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

## Customize layer styles

+++

### Change layer color

```{code-cell} ipython3
m = leafmap.Map(center=[12.338, 45.4385], zoom=17, style="streets")
m
```

```{code-cell} ipython3
m.style_layer_interact(id="water")
```

### Change case of labels

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

### Variable label placement

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

## Add custom components

You can add custom components to the map, including images, videos, text, color bar, and legend.

### Add image

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

```{code-cell} ipython3

```

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

m = leafmap.Map(center=[0, 0], zoom=1, style="streets")
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

```{code-cell} ipython3

```

### Add text

```{code-cell} ipython3
m = leafmap.Map(center=[-100, 40], zoom=3, style="streets")
text = "Hello World"
m.add_text(text, fontsize=20, position="bottom-right")
text2 = "Awesome Text!"
m.add_text(text2, fontsize=25, bg_color="rgba(255, 255, 255, 0.8)", position="top-left")
m
```

### Add GIF

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

### Add HTML

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

### Add colorbar

```{code-cell} ipython3
dem = "https://github.com/opengeos/datasets/releases/download/raster/srtm90.tif"
```

```{code-cell} ipython3
m = leafmap.Map(style="streets")
m.add_cog_layer(
    dem,
    name="DEM",
    colormap_name="terrain",
    rescale="0, 4000",
    fit_bounds=True,
    nodata=0,
)
m.add_colorbar(
    cmap="terrain", vmin=0, vmax=4000, label="Elevation (m)", position="bottom-right"
)
m
```

```{code-cell} ipython3
m = leafmap.Map(style="streets")
m.add_cog_layer(
    dem,
    name="DEM",
    colormap_name="terrain",
    rescale="0, 4000",
    nodata=0,
    fit_bounds=True,
)
m.add_colorbar(
    cmap="terrain",
    vmin=0,
    vmax=4000,
    label="Elevation (m)",
    position="bottom-right",
    transparent=True,
)
m
```

```{code-cell} ipython3
m = leafmap.Map(style="streets")
m.add_cog_layer(
    dem,
    name="DEM",
    colormap_name="terrain",
    rescale="0, 4000",
    nodata=0,
    fit_bounds=True,
)
m.add_colorbar(
    cmap="terrain",
    vmin=0,
    vmax=4000,
    label="Elevation (m)",
    position="bottom-right",
    width=0.2,
    height=3,
    orientation="vertical",
)
m
```

### Add legend

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

### Add video

The `urls` value is an array. For each URL in the array, a video element source will be created. To support the video across browsers, supply URLs in multiple formats.
The `coordinates` array contains [longitude, latitude] pairs for the video corners listed in clockwise order: top left, top right, bottom right, bottom left.

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

Leafmap supports the [PMTiles](https://protomaps.com/docs/pmtiles/) format for fast and efficient rendering of vector tiles.

### Protomaps sample data

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

### Overture data

You can also visualize Overture data. Inspired by [overture-maps](https://github.com/tebben/overture-maps).

+++

### Source Cooperative

Let's visualize the [Google-Microsoft Open Buildings - combined by VIDA](https://beta.source.coop/repositories/vida/google-microsoft-open-buildings/description).

```{code-cell} ipython3
url = "https://data.source.coop/vida/google-microsoft-open-buildings/pmtiles/go_ms_building_footprints.pmtiles"
metadata = leafmap.pmtiles_metadata(url)
print(f"layer names: {metadata['layer_names']}")
print(f"bounds: {metadata['bounds']}")
```

```{code-cell} ipython3
m = leafmap.Map(center=[0, 20], zoom=2, height="800px")
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

### 3D PMTiles

Visualize the global building data in 3D.

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

### 3D buildings

```{code-cell} ipython3
m = leafmap.Map(
    center=[-74.0095, 40.7046], zoom=16, pitch=60, bearing=-17, style="positron"
)
m.add_basemap("Esri.WorldImagery", visible=False)
m.add_overture_3d_buildings(release="2024-09-18", template="simple")
m.add_layer_control()
m
```

### 2D buildings

```{code-cell} ipython3
m = leafmap.Map(center=[-74.0095, 40.7046], zoom=16)
m.add_basemap("Esri.WorldImagery", visible=False)
m.add_overture_data(theme="buildings", opacity=0.8)
m.add_layer_control()
m
```

### Transportation

```{code-cell} ipython3
m = leafmap.Map(center=[-74.0095, 40.7046], zoom=16)
m.add_basemap("Esri.WorldImagery", visible=False)
m.add_overture_data(theme="transportation", opacity=0.8)
m.add_layer_control()
m
```

### Places

```{code-cell} ipython3
m = leafmap.Map(center=[-74.0095, 40.7046], zoom=16)
m.add_basemap("Esri.WorldImagery", visible=False)
m.add_overture_data(theme="places", opacity=0.8)
m.add_layer_control()
m
```

### Addresses

```{code-cell} ipython3
m = leafmap.Map(center=[-74.0095, 40.7046], zoom=16)
m.add_basemap("Esri.WorldImagery", visible=False)
m.add_overture_data(theme="addresses", opacity=0.8)
m.add_layer_control()
m
```

### Base

```{code-cell} ipython3
m = leafmap.Map(center=[-74.0095, 40.7046], zoom=16)
m.add_basemap("Esri.WorldImagery", visible=False)
m.add_overture_data(theme="base", opacity=0.8)
m.add_layer_control()
m
```

### Divisions

```{code-cell} ipython3
m = leafmap.Map()
m.add_basemap("Esri.WorldImagery", visible=False)
m.add_overture_data(theme="divisions", opacity=0.8)
m.add_layer_control()
m
```

## Deck.GL layers

Deck.GL layers can be added to the map using the `add_deck_layer` method.

### Single Deck.GL layer

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

### Multiple Deck.GL layers

```{code-cell} ipython3
import requests
```

```{code-cell} ipython3
data = requests.get(
    "https://d2ad6b4ur7yvpq.cloudfront.net/naturalearth-3.3.0/ne_10m_airports.geojson"
).json()
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

## Google Earth Engine

You can use the Earth Engine Python API to load and visualize Earth Engine data.

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

We can also overlay other data layers on top of Earth Engine data layers.

```{code-cell} ipython3
m = leafmap.Map(
    center=[-74.012998, 40.70414], zoom=15.6, pitch=60, bearing=30, style="3d-terrain"
)
m.add_ee_layer(asset_id="ESA/WorldCover/v200", opacity=0.5)
m.add_3d_buildings()
m.add_legend(builtin_legend="ESA_WorldCover", title="ESA Landcover")
m
```

If you have an Earth Engine, you can uncomment the first two code blocks to add any Earth Engine datasets.

```{code-cell} ipython3
# import ee
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

### Animate a line

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
m = leafmap.Map(center=[0, 0], zoom=0.5, style="streets")
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

### Animate map camera around a point

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

### Animate a point

```{code-cell} ipython3
for degree in range(0, 360, 1):
    m.rotate_to(degree, {"duration": 0})
    time.sleep(0.1)
```

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
m = leafmap.Map(center=[0, 0], zoom=2, style="streets")
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

### Animate a point along a route

```{code-cell} ipython3
m = leafmap.Map(center=[-100, 40], zoom=3, style="streets")
url = "https://github.com/opengeos/datasets/releases/download/us/arc_with_bearings.geojson"
geojson = requests.get(url).json()
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

### Update a feature in realtime

```{code-cell} ipython3
m = leafmap.Map(center=[-122.019807, 45.632433], zoom=14, pitch=60, style="3d-terrain")
m
```

```{code-cell} ipython3
import geopandas as gpd
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

To export the map as an HTML file, use the `to_html` method. To avoid exposing your private API key, you should create a public API key and restrict it to your website domain.

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

## Summary

In this lecture, we explored the functionality of the MapLibre library for creating and customizing interactive maps in Python. We covered how to build a map from scratch, add controls, and manage different basemaps. Additionally, we explored more complex visualizations, including 3D building and terrain views, layer customization, and data integration with GeoJSON and raster formats. By understanding and applying these techniques, students are now equipped to develop dynamic geospatial visualizations using MapLibre, enhancing both analytical and presentation capabilities in their GIS projects.
