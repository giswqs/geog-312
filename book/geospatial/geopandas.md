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

# GeoPandas

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/geospatial/geopandas.ipynb)

## Introduction

[GeoPandas](https://geopandas.org) is an open-source project that makes working with geospatial data in Python easier. It extends the datatypes used by pandas to allow spatial operations on geometric types. GeoPandas combines the capabilities of pandas and Shapely, providing geospatial operations in a pandas-like interface.

+++

## Installing and Importing GeoPandas

```{code-cell} ipython3
# %pip install geopandas
```

Once installed, you can import it like this:

```{code-cell} ipython3
import geopandas as gpd
from shapely.geometry import Point, Polygon
```

## Creating GeoDataFrames

A GeoDataFrame is a tabular data structure that contains a 'geometry' column, which holds the geometric shapes. You can create a GeoDataFrame from a list of geometries or from a pandas DataFrame.

```{code-cell} ipython3
# Creating a GeoDataFrame from scratch
import pandas as pd

data = {
    "City": ["Tokyo", "New York", "London", "Paris"],
    "Latitude": [35.6895, 40.7128, 51.5074, 48.8566],
    "Longitude": [139.6917, -74.0060, -0.1278, 2.3522],
}

df = pd.DataFrame(data)
gdf = gpd.GeoDataFrame(df, geometry=gpd.points_from_xy(df.Longitude, df.Latitude))
print(gdf)
```

## Reading and Writing Geospatial Data

GeoPandas makes it easy to read and write geospatial data formats like Shapefiles, GeoJSON, and others. Let's read a shapefile and write the GeoDataFrame to a GeoJSON file.

```{code-cell} ipython3
# Reading a shapefile
try:
    world = gpd.read_file(gpd.datasets.get_path("naturalearth_lowres"))
    print(world.head())
except Exception as e:
    print(f"An error occurred: {e}")

# Writing the GeoDataFrame to a GeoJSON file
output_file = "world.geojson"
try:
    world.to_file(output_file, driver="GeoJSON")
    print(f"GeoDataFrame has been written to {output_file}")
except Exception as e:
    print(f"An error occurred while writing to {output_file}: {e}")
```

## Spatial Operations

GeoPandas provides a range of spatial operations, such as buffering, intersections, and spatial joins. Let's explore some of these operations.

```{code-cell} ipython3
# Example of buffering (creating a buffer zone around points)
gdf["buffer"] = gdf.buffer(1)  # Buffer of 1 degree
print(gdf[["City", "buffer"]])
```

```{code-cell} ipython3
# Example of spatial join (finding points within a polygon)
paris = gdf[gdf["City"] == "Paris"]
polygon = Polygon([(2, 48), (2.5, 48), (2.5, 49), (2, 49)])
polygon_gdf = gpd.GeoDataFrame([1], geometry=[polygon], crs=gdf.crs)
joined = gpd.sjoin(gdf, polygon_gdf, predicate="within")
print(joined)
```

## Plotting Geospatial Data

GeoPandas integrates well with Matplotlib, allowing you to easily plot geospatial data. Let's plot the world map with the locations of the cities from our GeoDataFrame.

```{code-cell} ipython3
import matplotlib.pyplot as plt

# Plotting the world map and the cities
world.plot()
gdf.plot(ax=plt.gca(), color="red")
plt.show()
```

```{code-cell} ipython3
gdf.crs = "EPSG:4326"
gdf.explore()
```

## Exercises

1. Create a GeoDataFrame containing a list of countries and their capital cities. Add a geometry column with the locations of the capitals.
2. Load a shapefile of your choice, filter the data to only include a specific region or country, and save the filtered GeoDataFrame to a new file.
3. Perform a spatial join between two GeoDataFrames: one containing polygons (e.g., country borders) and one containing points (e.g., cities). Find out which points fall within which polygons.
4. Plot a map showing the distribution of a particular attribute (e.g., population) across different regions.

```{code-cell} ipython3
# Type your code here
```

## Conclusion

GeoPandas is a powerful tool for geospatial data analysis in Python. It combines the capabilities of pandas with the geometric operations of Shapely, allowing for efficient and intuitive geospatial data manipulation. By practicing with these exercises, you can gain a solid understanding of how to work with geospatial data using GeoPandas.
