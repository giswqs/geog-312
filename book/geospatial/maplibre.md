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

The notebook demonstrates how to create 3D maps using the [MapLibre](https://github.com/eodaGmbH/py-maplibregl) Python package. The examples shown in this notebook are based on the [MapLibre documentation](https://eodagmbh.github.io/py-maplibregl/examples/vancouver_blocks/).

## Learning Objectives

TBA.

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

## Set up API Key

To run this notebook, you need to set up a MapTiler API key. You can get a free API key by signing up at [https://cloud.maptiler.com/](https://cloud.maptiler.com/).

```{code-cell} ipython3
# import os
# os.environ["MAPTILER_KEY"] = "YOUR_API_KEY"
```

## Create interactive maps

### Create a simple map

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

### Add map controls

The control to add to the map. Can be one of the following: `scale`, `fullscreen`, `geolocate`, `navigation`.

```{code-cell} ipython3
m = leafmap.Map()
m.add_control("geolocate", position="top-left")
m
```

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

### MapTiler styles

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

### Live feature update

#### Animate a point along a route

```{code-cell} ipython3
import time
```

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

#### Update a feature in realtime

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

## Visualize raster data

### Local raster data

You can load local raster data using the `add_raster` method.

```{code-cell} ipython3
url = "https://github.com/opengeos/datasets/releases/download/raster/landsat.tif"
filepath = "landsat.tif"
leafmap.download_file(url, filepath)
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
leafmap.download_file(url, filepath)
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
m = leafmap.Map()
url = "https://canada-spot-ortho.s3.amazonaws.com/canada_spot_orthoimages/canada_spot5_orthoimages/S5_2007/S5_11055_6057_20070622/S5_11055_6057_20070622.json"
m.add_stac_layer(url, bands=["B4", "B3", "B2"], name="SPOT", vmin=0, vmax=150, nodata=0)
m
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

```{code-cell} ipython3

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
