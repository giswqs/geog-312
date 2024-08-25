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

# WhiteboxTools

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/geospatial/whitebox.ipynb)

+++

## Installation

Uncomment and run the following cell to install necessary packages for this notebook, including leafmap, geopandas, localtileserver, rio-cogeo, pynhd, py3dep.

```{code-cell} ipython3
# %pip install "leafmap[raster]" geopandas
```

## Import libraries

```{code-cell} ipython3
import os
import leafmap
```

## Create interactive maps

Specify the map center, zoom level, and height.

```{code-cell} ipython3
m = leafmap.Map(center=[40, -100], zoom=4, height="600px")
m
```

## Add basemaps

Add OpenTopoMap, USGS 3DEP Elevation, and USGS Hydrography basemaps.

```{code-cell} ipython3
m = leafmap.Map()
m.add_basemap("OpenTopoMap")
m.add_basemap("USGS 3DEP Elevation")
m.add_basemap("USGS Hydrography")
m
```

Add NLCD land cover map and legend.

```{code-cell} ipython3
m = leafmap.Map(center=[40, -100], zoom=4)
m.add_basemap("HYBRID")
m.add_basemap("NLCD 2019 CONUS Land Cover")
m.add_legend(builtin_legend="NLCD", title="NLCD Land Cover Type")
m
```

Add WMS layers.

```{code-cell} ipython3
m = leafmap.Map(center=[40, -100], zoom=4)
m.add_basemap("Esri.WorldImagery")
url = "https://www.mrlc.gov/geoserver/mrlc_display/NLCD_2019_Land_Cover_L48/wms?"
m.add_wms_layer(
    url,
    layers="NLCD_2019_Land_Cover_L48",
    name="NLCD 2019 CONUS Land Cover",
    format="image/png",
    transparent=True,
)
m.add_legend(builtin_legend="NLCD", title="NLCD Land Cover Type")
m
```

## Get watershed data

Let's download watershed data for the Calapooia River basin in Oregon.

```{code-cell} ipython3
gdf = leafmap.get_nhd_basins(feature_ids=23763529, fsource="comid", simplified=False)
```

Plot the watershed boundary on the map.

```{code-cell} ipython3
m = leafmap.Map()
m.add_gdf(gdf, layer_name="Catchment", info_mode=None)
m
```

Save the watershed boundary to a GeoJSON or shapefile.

```{code-cell} ipython3
gdf.to_file("basin.geojson", driver="GeoJSON")
```

```{code-cell} ipython3
gdf.to_file("basin.shp")
```

## Download DEM

Download a digital elevation model (DEM) for the watershed from the USGS 3DEP Elevation service. Convert the DEM to a Cloud Optimized GeoTIFF (COG).

```{code-cell} ipython3
leafmap.get_3dep_dem(
    gdf, resolution=30, output="dem.tif", dst_crs="EPSG:3857", to_cog=True
)
```

Display the DEM on the map.

```{code-cell} ipython3
m.add_raster("dem.tif", palette="terrain", layer_name="DEM")
m
```

## Get DEM metadata

```{code-cell} ipython3
metadata = leafmap.image_metadata("dem.tif")
metadata
```

Get a summary statistics of the DEM.

```{code-cell} ipython3
metadata["bands"]
```

## Add colorbar

```{code-cell} ipython3
m.add_colormap(cmap="terrain", vmin="60", vmax=1500, label="Elevation (m)")
m
```

## Initialize WhiteboxTools

Initialize the WhiteboxTools class.

```{code-cell} ipython3
wbt = leafmap.WhiteboxTools()
```

Check the WhiteboxTools version.

```{code-cell} ipython3
wbt.version()
```

Display the WhiteboxTools interface.

```{code-cell} ipython3
leafmap.whiteboxgui()
```

## Set working directory

```{code-cell} ipython3
wbt.set_working_dir(os.getcwd())
wbt.verbose = False
```

## Smooth DEM

All WhiteboxTools functions will return 0 if they are successful, and 1 if they are not.

```{code-cell} ipython3
wbt.feature_preserving_smoothing("dem.tif", "smoothed.tif", filter=9)
```

Display the smoothed DEM and watershed boundary on the map.

```{code-cell} ipython3
m = leafmap.Map()
m.add_raster("smoothed.tif", palette="terrain", layer_name="Smoothed DEM")
m.add_geojson("basin.geojson", layer_name="Watershed", info_mode=None)
m
```

## Create hillshade

```{code-cell} ipython3
wbt.hillshade("smoothed.tif", "hillshade.tif", azimuth=315, altitude=35)
```

Overlay the hillshade on the smoothed DEM with transparency.

```{code-cell} ipython3
m.add_raster("hillshade.tif", layer_name="Hillshade")
m.layers[-1].opacity = 0.6
```

## Find no-flow cells

Find cells with undefined flow, i.e. no valid flow direction, based on the D8 flow direction algorithm

```{code-cell} ipython3
wbt.find_no_flow_cells("smoothed.tif", "noflow.tif")
```

Display the no-flow cells on the map.

```{code-cell} ipython3
m.add_raster("noflow.tif", layer_name="No Flow Cells")
m
```

## Fill depressions

```{code-cell} ipython3
wbt.fill_depressions("smoothed.tif", "filled.tif")
```

Alternatively, you can use depression breaching to fill the depressions.

```{code-cell} ipython3
wbt.breach_depressions("smoothed.tif", "breached.tif")
```

```{code-cell} ipython3
wbt.find_no_flow_cells("breached.tif", "noflow2.tif")
```

```{code-cell} ipython3
m.add_raster("noflow2.tif", layer_name="No Flow Cells after Breaching")
m
```

## Delineate flow direction

```{code-cell} ipython3
wbt.d8_pointer("breached.tif", "flow_direction.tif")
```

## Calculate flow accumulation

```{code-cell} ipython3
wbt.d8_flow_accumulation("breached.tif", "flow_accum.tif")
```

```{code-cell} ipython3
m.add_raster("flow_accum.tif", layer_name="Flow Accumulation")
m
```

## Extract streams

```{code-cell} ipython3
wbt.extract_streams("flow_accum.tif", "streams.tif", threshold=5000)
```

```{code-cell} ipython3
m.add_raster("streams.tif", layer_name="Streams")
```

## Calculate distance to outlet

```{code-cell} ipython3
wbt.distance_to_outlet(
    "flow_direction.tif", streams="streams.tif", output="distance_to_outlet.tif"
)
```

```{code-cell} ipython3
m.add_raster("distance_to_outlet.tif", layer_name="Distance to Outlet")
```

## Vectorize streams

```{code-cell} ipython3
wbt.raster_streams_to_vector(
    "streams.tif", d8_pntr="flow_direction.tif", output="streams.shp"
)
```

The raster_streams_to_vector tool has a bug. The output vector file is missing the coordinate system. Use leafmap.vector_set_crs() to set the coordinate system.

```{code-cell} ipython3
leafmap.vector_set_crs(source="streams.shp", output="streams.shp", crs="EPSG:3857")
```

```{code-cell} ipython3
m.add_shp(
    "streams.shp", layer_name="Streams Vector", style={"color": "#ff0000", "weight": 3}
)
m
```

## Delineate basins

```{code-cell} ipython3
wbt.basins("flow_direction.tif", "basins.tif")
```

```{code-cell} ipython3
m.add_raster("basins.tif", layer_name="Basins")
```

## Delineate the longest flow path

```{code-cell} ipython3
wbt.longest_flowpath(
    dem="breached.tif", basins="basins.tif", output="longest_flowpath.shp"
)
```

Select only the longest flow path.

```{code-cell} ipython3
leafmap.select_largest(
    "longest_flowpath.shp", column="LENGTH", output="longest_flowpath.shp"
)
```

```{code-cell} ipython3
m.add_shp(
    "longest_flowpath.shp",
    layer_name="Longest Flowpath",
    style={"color": "#ff0000", "weight": 3},
)
m
```

## Generate a pour point

```{code-cell} ipython3
if m.user_roi is not None:
    m.save_draw_features("pour_point.shp", crs="EPSG:3857")
else:
    coords = [-122.613559, 44.284383]
    leafmap.coords_to_vector(coords, output="pour_point.shp", crs="EPSG:3857")
```

## Snap pour point to stream

```{code-cell} ipython3
wbt.snap_pour_points(
    "pour_point.shp", "flow_accum.tif", "pour_point_snapped.shp", snap_dist=300
)
```

```{code-cell} ipython3
m.add_shp("pour_point_snapped.shp", layer_name="Pour Point")
```

## Delineate watershed

```{code-cell} ipython3
wbt.watershed("flow_direction.tif", "pour_point_snapped.shp", "watershed.tif")
```

```{code-cell} ipython3
m.add_raster("watershed.tif", layer_name="Watershed")
m
```

## Convert watershed raster to vector

```{code-cell} ipython3
wbt.raster_to_vector_polygons("watershed.tif", "watershed.shp")
```

```{code-cell} ipython3
m.add_shp(
    "watershed.shp",
    layer_name="Watershed Vector",
    style={"color": "#ffff00", "weight": 3},
)
```
