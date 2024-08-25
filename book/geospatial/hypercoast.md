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

# HyperCoast

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/geospatial/hypercoast.ipynb)

## Environment setup

Uncomment and run the following cell to install the required packages.

```{code-cell} ipython3
# %pip install "hypercoast[extra]"
```

Import library.

```{code-cell} ipython3
import hypercoast
```

To download and access the data, you will need to create an Earthdata login. You can register for an account at [urs.earthdata.nasa.gov](https://urs.earthdata.nasa.gov). Once you have an account, run the following cell and enter your NASA Earthdata login credentials.

```{code-cell} ipython3
hypercoast.nasa_earth_login()
```

## Search for EMIT data

Search for EMIT data programmatically. Specify the bounding box and time range of interest. Set `count=-1` to return all results or set `count=10` to return the first 10 results.

```{code-cell} ipython3
results, gdf = hypercoast.search_emit(
    bbox=(-83, 25, -81, 28),
    temporal=("2024-04-01", "2024-05-16"),
    count=10,  # use -1 to return all datasets
    return_gdf=True,
)
```

Plot the footprints of the returned datasets on a map.

```{code-cell} ipython3
gdf.explore()
```

Uncomment the following cell to download the first dataset from the search results. Note that the download may take some time.

```{code-cell} ipython3
# hypercoast.download_emit(results[:1], out_dir="data")
```

Search for EMIT data interactively. Specify pan and zoom to the area of interest. Specify the time range of interest from the search dialog, then click on the Search button.

```{code-cell} ipython3
m = hypercoast.Map(center=[30.0262, -90.1345], zoom=8)
m.search_emit()
m
```

Uncomment the following cell to display the GeoDataFrame of the search results.

```{code-cell} ipython3
# m._NASA_DATA_GDF.head()
```

Similarly, you can download the first dataset from the search results by uncommenting the following cell.

```{code-cell} ipython3
# hypercoast.download_emit(results[:1], out_dir="data")
```

## Download a sample EMIT dataset

Let's download a sample EMIT dataset for the demonstration.

```{code-cell} ipython3
url = "https://github.com/opengeos/datasets/releases/download/hypercoast/EMIT_L2A_RFL_001_20240404T161230_2409511_009.nc"
filepath = "../examples/data/EMIT_L2A_RFL_001_20240404T161230_2409511_009.nc"
hypercoast.download_file(url, filepath, quiet=True)
```

## Read EMIT data

Read the downloaded EMIT data and process it as an `xarray.Dataset`. Note that the dataset has 285 bands.

```{code-cell} ipython3
dataset = hypercoast.read_emit(filepath)
# dataset
```

![](https://i.imgur.com/qn0B4fb.png)

+++

## Visualize EMIT data

Visualize the EMIT data on an interactive map. You can change the band combination and extract spectral profiles interactively. You can also export the spectral profiles as a CSV file.

```{code-cell} ipython3
m = hypercoast.Map()
m.add_basemap("SATELLITE")
m.add_emit(dataset, wavelengths=[1000, 600, 500], vmin=0, vmax=0.3, layer_name="EMIT")
m.add("spectral")
m
```

![](https://i.imgur.com/6pceRUz.gif)

+++

## Create an image cube

First, select a subset of the data to avoid nodata areas.

```{code-cell} ipython3
ds = dataset.sel(longitude=slice(-90.1482, -89.7321), latitude=slice(30.0225, 29.7451))
```

Visualize the EMIT data in 3D with an RGB image overlaid on top of the 3D plot.

```{code-cell} ipython3
p = hypercoast.image_cube(
    ds,
    variable="reflectance",
    cmap="jet",
    clim=(0, 0.4),
    rgb_wavelengths=[1000, 700, 500],
    rgb_gamma=2,
    title="EMIT Reflectance",
)
```

Uncomment the following cell to create an image cube. Note that this function does not work in the Google Colab environment.

```{code-cell} ipython3
# p.show()
```

![](https://i.imgur.com/CvE9PN9.gif)

+++

## Interactive slicing

First, select a subset of the data for demonstration purposes.

```{code-cell} ipython3
ds = dataset.sel(longitude=slice(-90.05, -89.99), latitude=slice(30.00, 29.93))
```

Drag the plane up and down to slice the data in 3D.

```{code-cell} ipython3
p = hypercoast.image_cube(
    ds,
    variable="reflectance",
    cmap="jet",
    clim=(0, 0.5),
    rgb_wavelengths=[1000, 700, 500],
    rgb_gamma=2,
    title="EMIT Reflectance",
    widget="plane",
)
p.add_text("Band slicing", position="upper_right", font_size=14)
```

Uncomment the following cell to display the interactive slicing widget. Note that this function does not work in the Google Colab environment.

```{code-cell} ipython3
# p.show()
```

![](https://i.imgur.com/msK1liO.gif)

+++

## Interactive thresholding

Drag the threshold slider to threshold the data in 3D.

```{code-cell} ipython3
p = hypercoast.image_cube(
    ds,
    variable="reflectance",
    cmap="jet",
    clim=(0, 0.5),
    rgb_wavelengths=[1000, 700, 500],
    rgb_gamma=2,
    title="EMIT Reflectance",
    widget="threshold",
)
p.add_text("Thresholding", position="upper_right", font_size=14)
```

Uncomment the following cell to display the thresholded data. Note that this function does not work in the Google Colab environment.

```{code-cell} ipython3
# p.show()
```

![](https://i.imgur.com/TPd20Tn.gif)
