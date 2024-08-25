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

# Leafmap

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/geospatial/leafmap.ipynb)

+++

## Install leafmap

```{code-cell} ipython3
# %pip install leafmap
```

## Import libraries

```{code-cell} ipython3
import leafmap
```

## Create an interactive map

```{code-cell} ipython3
m = leafmap.Map(center=(40, -100), zoom=4)
m
```

## Customize map height

```{code-cell} ipython3
m = leafmap.Map(height="400px")
m
```

## Set control visibility

```{code-cell} ipython3
m = leafmap.Map(
    draw_control=False,
    measure_control=False,
    fullscreen_control=False,
    attribution_control=True,
)
m
```

## Change basemaps

```{code-cell} ipython3
m = leafmap.Map()
m.add_basemap("OpenTopoMap")
m
```

## Add XYZ tile layer

```{code-cell} ipython3
m = leafmap.Map()
m.add_tile_layer(
    url="https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}",
    name="Google Satellite",
    attribution="Google",
)
m
```

## Add WMS tile layer

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

## Add legend

```{code-cell} ipython3
m = leafmap.Map(center=[40, -100], zoom=4)
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

## Add colorbar

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
