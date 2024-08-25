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

# Vector Data Visualization

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/geospatial/vector_viz.ipynb)

## Installation

Uncomment the following line to install [leafmap](https://leafmap.org) if needed.

```{code-cell} ipython3
# %pip install "leafmap[vector]"
```

## Import libraries

```{code-cell} ipython3
import leafmap
```

## Visualize vector data

You can visualize vector data using the `add_vector` function. It supports common vector data formats, including GeoJSON, Shapefile, GeoPackage, and any other formats supported by [geopandas](https://geopandas.org).

```{code-cell} ipython3
m = leafmap.Map(center=[0, 0], zoom=2)
data = "https://open.gishub.org/data/vector/cables.geojson"
m.add_vector(data, layer_name="Cable lines", info_mode="on_hover")
m
```

![](https://i.imgur.com/NIcnLWs.png)

+++

You can style the vector with custom style callback functions.

```{code-cell} ipython3
m = leafmap.Map(center=[20, 0], zoom=2)
m.add_basemap("CartoDB.DarkMatter")
data = "https://open.gishub.org/data/vector/cables.geojson"
callback = lambda feat: {"color": feat["properties"]["color"], "weight": 1}
m.add_vector(data, layer_name="Cable lines", style_callback=callback)
m
```

![](https://i.imgur.com/mQnV53U.png)

+++

## Choropleth map

You can create a choropleth map using the `add_data` function. It supports GeoJSON, Shapefile, GeoPackage, and any other formats supported by [geopandas](https://geopandas.org).

```{code-cell} ipython3
m = leafmap.Map()
data = "https://raw.githubusercontent.com/opengeos/leafmap/master/docs/data/countries.geojson"
m.add_data(
    data, column="POP_EST", scheme="Quantiles", cmap="Blues", legend_title="Population"
)
m
```

![](https://i.imgur.com/4FV6f72.png)

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

![](https://i.imgur.com/KEY6zEj.png)

+++

## GeoParquet

Visualize GeoParquet data with leafmap and lonboard.

```{code-cell} ipython3
url = "https://open.gishub.org/data/duckdb/cities.parquet"
gdf = leafmap.read_parquet(url, return_type="gdf", src_crs="EPSG:4326")
gdf.head()
```

Visualize point data.

```{code-cell} ipython3
leafmap.view_vector(
    gdf,
    get_radius=20000,
    get_fill_color="blue",
    zoom_to_layer=False,
    map_args={"center": (40, -100), "zoom": 3, "height": 500},
)
```

![](https://i.imgur.com/BBsLjvx.png)

+++

Visualizing polygon data.

```{code-cell} ipython3
url = "https://data.source.coop/giswqs/nwi/wetlands/DC_Wetlands.parquet"
gdf = leafmap.read_parquet(
    url, return_type="gdf", src_crs="EPSG:5070", dst_crs="EPSG:4326"
)
gdf.head()
```

```{code-cell} ipython3
leafmap.view_vector(gdf, get_fill_color=[0, 0, 255, 128])
```

![vector](https://i.imgur.com/HRtpiVd.png)

+++

![legend](https://i.imgur.com/fxzHHFN.png)

## PMTiles

[PMTiles](https://github.com/protomaps/PMTiles) is a single-file archive format for tiled data. A PMTiles archive can be hosted on a commodity storage platform such as S3, and enables low-cost, zero-maintenance map applications that are "serverless" - free of a custom tile backend or third party provider.

+++

## Remote PMTiles

Leafmap can visualize PMTiles hosted locally or remotely.

+++

### Source Cooperative

Visualize the [Google-Microsoft Open Buildings data](https://beta.source.coop/repositories/vida/google-microsoft-open-buildings/description) hosted on Source Cooperative.

Check the metadata of the PMTiles.

```{code-cell} ipython3
url = "https://data.source.coop/vida/google-microsoft-open-buildings/pmtiles/go_ms_building_footprints.pmtiles"
metadata = leafmap.pmtiles_metadata(url)
print(f"layer names: {metadata['layer_names']}")
print(f"bounds: {metadata['bounds']}")
```

Visualize the PMTiles.

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

![](https://i.imgur.com/kT6ng6k.png)
