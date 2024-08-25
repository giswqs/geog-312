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

# MapLibre

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/geospatial/maplibre.ipynb)

The notebook demonstrates how to create 3D maps using the [MapLibre](https://github.com/eodaGmbH/py-maplibregl) Python package. The examples shown in this notebook are based on the [MapLibre documentation](https://eodagmbh.github.io/py-maplibregl/examples/vancouver_blocks/).

## Installation

Uncomment the following line to install [leafmap](https://leafmap.org) if needed.

```{code-cell} ipython3
# %pip install "leafmap[maplibre]"
```

## Import libraries

```{code-cell} ipython3
import leafmap.maplibregl as leafmap
```

## Create maps

Create an interactive map by specifying map center [lon, lat], zoom level, pitch, and bearing.

```{code-cell} ipython3
m = leafmap.Map(center=[-100, 40], zoom=3, pitch=0, bearing=0)
m
```

![](https://i.imgur.com/8ITaEZa.png)

+++

To customize the basemap, you can specify the `style` parameter. It can be an URL or a string, such as `dark-matter`, `positron`, `voyager`, `demotiles`.

```{code-cell} ipython3
m = leafmap.Map(style="positron")
m
```

![](https://i.imgur.com/9fImW21.png)

+++

To create a map with a background color, use `style="background-<COLOR>"`, such as `background-lightgray` and `background-green`.

```{code-cell} ipython3
m = leafmap.Map(style="background-lightgray")
m
```

![](https://i.imgur.com/xFeDTkE.png)

+++

Alternatively, you can provide a URL to a vector style.

```{code-cell} ipython3
style = "https://demotiles.maplibre.org/style.json"
m = leafmap.Map(style=style)
m
```

![](https://i.imgur.com/yaZYrr1.png)

+++

## Add controls

The control to add to the map. Can be one of the following: `scale`, `fullscreen`, `geolocate`, `navigation`.

```{code-cell} ipython3
m = leafmap.Map()
m.add_control("geolocate", position="top-left")
m
```

![](https://i.imgur.com/7LS5WAk.png)

+++

## Add basemaps

```{code-cell} ipython3
m = leafmap.Map()
m
```

```{code-cell} ipython3
m.add_basemap()
```

```{code-cell} ipython3
m = leafmap.Map()
m.add_basemap("OpenTopoMap")
m
```

![](https://i.imgur.com/MRRw1MW.png)

```{code-cell} ipython3
m.add_basemap("Esri.WorldImagery")
```

## XYZ tile layer

```{code-cell} ipython3
m = leafmap.Map()
url = "https://tile.openstreetmap.org/{z}/{x}/{y}.png"
m.add_tile_layer(
    url, name="OpenStreetMap", attribution="OpenStreetMap", opacity=1.0, visible=True
)
m
```

![](https://i.imgur.com/V9wmsjl.png)

+++

## WMS layer

```{code-cell} ipython3
m = leafmap.Map(center=[-100, 40], zoom=3)
m.add_basemap("Esri.WorldImagery")
url = "https://www.mrlc.gov/geoserver/mrlc_display/NLCD_2021_Land_Cover_L48/wms"
layers = "NLCD_2021_Land_Cover_L48"
m.add_wms_layer(url, layers=layers, name="NLCD", opacity=0.8)
m
```

![](https://i.imgur.com/xcZ4VKv.png)

+++

## COG layer

```{code-cell} ipython3
m = leafmap.Map()
url = (
    "https://github.com/opengeos/datasets/releases/download/raster/Libya-2023-07-01.tif"
)
m.add_cog_layer(url, name="COG", attribution="Maxar", fit_bounds=True)
m
```

![](https://i.imgur.com/ApGhjDp.png)

+++

## STAC layer

```{code-cell} ipython3
m = leafmap.Map()
url = "https://canada-spot-ortho.s3.amazonaws.com/canada_spot_orthoimages/canada_spot5_orthoimages/S5_2007/S5_11055_6057_20070622/S5_11055_6057_20070622.json"
m.add_stac_layer(url, bands=["B4", "B3", "B2"], name="SPOT", vmin=0, vmax=150)
m
```

![](https://i.imgur.com/RJAhsV5.png)

+++

## Local raster

```{code-cell} ipython3
url = "https://github.com/opengeos/datasets/releases/download/raster/srtm90.tif"
filepath = "srtm90.tif"
leafmap.download_file(url, filepath)
```

```{code-cell} ipython3
m = leafmap.Map()
m.add_raster(filepath, colormap="terrain", name="DEM")
m
```

![](https://i.imgur.com/pMcuQAp.png)

+++

## Vancouver Property Value

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

![](https://i.imgur.com/IZXfgSz.gif)

+++

## Earthquake Clusters

```{code-cell} ipython3
m = leafmap.Map(style="positron")

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

![](https://i.imgur.com/vge4jF4.png)

+++

## Airport Markers

```{code-cell} ipython3
from maplibre.controls import Marker, MarkerOptions, Popup, PopupOptions
import pandas as pd
```

```{code-cell} ipython3
m = leafmap.Map(style="positron")

url = "https://github.com/visgl/deck.gl-data/raw/master/examples/line/airports.json"
data = leafmap.pandas_to_geojson(
    url, "coordinates", properties=["type", "name", "abbrev"]
)

m.add_geojson(
    data,
    name="Airports",
    layer_type="circle",
    paint={
        "circle-color": [
            "match",
            ["get", "type"],
            "mid",
            "darkred",
            "major",
            "darkgreen",
            "darkblue",
        ],
        "circle_radius": 10,
        "circle-opacity": 0.3,
    },
)


def get_color(airport_type: str) -> str:
    color = "darkblue"
    if airport_type == "mid":
        color = "darkred"
    elif airport_type == "major":
        color = "darkgreen"

    return color


airports_data = pd.read_json(url)
popup_options = PopupOptions(close_button=False)

for _, r in airports_data.iterrows():
    m.add_marker(
        lng_lat=r["coordinates"],
        options=MarkerOptions(color=get_color(r["type"])),
        popup=Popup(
            text=r["name"],
            options=popup_options,
        ),
    )

m
```

![](https://i.imgur.com/q7nN1PW.png)

+++

## 3D Indoor Mapping

```{code-cell} ipython3
m = leafmap.Map(
    center=(-87.61694, 41.86625), zoom=17, pitch=40, bearing=20, style="positron"
)
m.add_basemap("OpenStreetMap.Mapnik")
data = "https://maplibre.org/maplibre-gl-js/docs/assets/indoor-3d-map.geojson"
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
m
```

![](https://i.imgur.com/dteQlQC.png)

+++

## Custom Basemap

```{code-cell} ipython3
import leafmap.maplibregl as leafmap
from maplibre.basemaps import construct_basemap_style
from maplibre import Layer, LayerType, Map, MapOptions
from maplibre.sources import GeoJSONSource


bg_layer = Layer(
    type=LayerType.BACKGROUND,
    id="background",
    source=None,
    paint={"background-color": "darkblue", "background-opacity": 0.8},
)

countries_source = GeoJSONSource(
    data="https://d2ad6b4ur7yvpq.cloudfront.net/naturalearth-3.3.0/ne_110m_admin_0_countries.geojson"
)

lines_layer = Layer(
    type=LayerType.LINE,
    source="countries",
    paint={"line-color": "white", "line-width": 1.5},
)

polygons_layer = Layer(
    type=LayerType.FILL,
    source="countries",
    paint={"fill-color": "darkred", "fill-opacity": 0.8},
)

custom_basemap = construct_basemap_style(
    layers=[bg_layer, polygons_layer, lines_layer],
    sources={"countries": countries_source},
)


m = leafmap.Map(style=custom_basemap)
data = "https://docs.mapbox.com/mapbox-gl-js/assets/earthquakes.geojson"
m.add_geojson(
    data,
    layer_type="circle",
    name="earthquakes",
    paint={"circle-color": "yellow", "circle-radius": 5},
)
m.add_popup("earthquakes", "mag")
m
```

![](https://i.imgur.com/Bn9Kwje.png)

+++

## H3 Grid UK Road Safety

```{code-cell} ipython3
import pandas as pd
import h3
```

```{code-cell} ipython3
RESOLUTION = 7
COLORS = (
    "lightblue",
    "turquoise",
    "lightgreen",
    "yellow",
    "orange",
    "darkred",
)

road_safety = pd.read_csv(
    "https://raw.githubusercontent.com/visgl/deck.gl-data/master/examples/3d-heatmap/heatmap-data.csv"
).dropna()


def create_h3_grid(res=RESOLUTION) -> dict:
    road_safety["h3"] = road_safety.apply(
        lambda x: h3.geo_to_h3(x["lat"], x["lng"], resolution=res), axis=1
    )
    df = road_safety.groupby("h3").h3.agg("count").to_frame("count").reset_index()
    df["hexagon"] = df.apply(
        lambda x: [h3.h3_to_geo_boundary(x["h3"], geo_json=True)], axis=1
    )
    df["color"] = pd.cut(
        df["count"],
        bins=len(COLORS),
        labels=COLORS,
    )
    return leafmap.pandas_to_geojson(
        df, "hexagon", geometry_type="Polygon", properties=["count", "color"]
    )


m = leafmap.Map(
    center=(-1.415727, 52.232395),
    zoom=7,
    pitch=40,
    bearing=-27,
)
data = create_h3_grid()
m.add_geojson(
    data,
    layer_type="fill-extrusion",
    paint={
        "fill-extrusion-color": ["get", "color"],
        "fill-extrusion-opacity": 0.7,
        "fill-extrusion-height": ["*", 100, ["get", "count"]],
    },
)
m
```

![](https://i.imgur.com/DYWmj5y.png)

+++

## Deck.GL Layer

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

![](https://i.imgur.com/xBVdT2u.png)

+++

## Multiple Deck.GL Layers

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

![](https://i.imgur.com/eFc4IbZ.png)
