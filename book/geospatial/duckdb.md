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

# DuckDB

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/geospatial/duckdb.ipynb)

## Introduction

This notebook shows how to import data into a DuckDB database. It uses the `duckdb` Python package to connect to a DuckDB database and import data from various formats, including CSV, JSON, DataFrame, parquet, GeoJSON, Shapefile, GeoParquet, and more.

## Datasets

The following datasets are used in this notebook. You don't need to download them, they can be accessed directly from the notebook.

- [cities.csv](https://open.gishub.org/data/duckdb/cities.csv)
- [countries.csv](https://open.gishub.org/data/duckdb/countries.csv)

## Installation

Uncomment the following cell to install the required packages if needed.

```{code-cell} ipython3
# %pip install duckdb leafmap
```

## Library Import

```{code-cell} ipython3
import duckdb
import leafmap
import pandas as pd
```

## Installing Extensions

DuckDB’s Python API provides functions for installing and loading extensions, which perform the equivalent operations to running the `INSTALL` and `LOAD` SQL commands, respectively. An example that installs and loads the [httpfs extension](https://duckdb.org/docs/extensions/httpfs) looks like follows:

```{code-cell} ipython3
con = duckdb.connect()
```

```{code-cell} ipython3
con.install_extension("httpfs")
con.load_extension("httpfs")
```

```{code-cell} ipython3
con.install_extension("spatial")
con.load_extension("spatial")
```

## Downloading Sample Data

```{code-cell} ipython3
url = "https://open.gishub.org/data/duckdb/cities.zip"
leafmap.download_file(url, unzip=True)
```

## CSV Files

CSV files can be read using the `read_csv` function, called either from within Python or directly from within SQL. By default, the `read_csv` function attempts to auto-detect the CSV settings by sampling from the provided file.

```{code-cell} ipython3
# read from a file using fully auto-detected settings
con.read_csv("cities.csv")
```

```{code-cell} ipython3
# specify options on how the CSV is formatted internally
con.read_csv("cities.csv", header=True, sep=",")
```

```{code-cell} ipython3
# use the (experimental) parallel CSV reader
con.read_csv("cities.csv", parallel=True)
```

```{code-cell} ipython3
# directly read a CSV file from within SQL
con.sql("SELECT * FROM 'cities.csv'")
```

```{code-cell} ipython3
# call read_csv from within SQL
con.sql("SELECT * FROM read_csv_auto('cities.csv')")
```

## JSON Files

JSON files can be read using the `read_json` function, called either from within Python or directly from within SQL. By default, the `read_json` function will automatically detect if a file contains newline-delimited JSON or regular JSON, and will detect the schema of the objects stored within the JSON file.

```{code-cell} ipython3
# read from a single JSON file
con.read_json("cities.json")
```

```{code-cell} ipython3
# directly read a JSON file from within SQL
con.sql("SELECT * FROM 'cities.json'")
```

```{code-cell} ipython3
# call read_json from within SQL
con.sql("SELECT * FROM read_json_auto('cities.json')")
```

## DataFrames

DuckDB is automatically able to query a Pandas DataFrame.

```{code-cell} ipython3
df = pd.read_csv("cities.csv")
df
```

```{code-cell} ipython3
con.sql("SELECT * FROM df").fetchall()
```

## Parquet Files

Parquet files can be read using the `read_parquet` function, called either from within Python or directly from within SQL.

```{code-cell} ipython3
# read from a single Parquet file
con.read_parquet("cities.parquet")
```

```{code-cell} ipython3
# directly read a Parquet file from within SQL
con.sql("SELECT * FROM 'cities.parquet'")
```

```{code-cell} ipython3
# call read_parquet from within SQL
con.sql("SELECT * FROM read_parquet('cities.parquet')")
```

## GeoJSON Files

```{code-cell} ipython3
con.sql("SELECT * FROM ST_Drivers()")
```

```{code-cell} ipython3
con.sql("SELECT * FROM ST_Read('cities.geojson')")
```

```{code-cell} ipython3
con.sql("FROM ST_Read('cities.geojson')")
```

```{code-cell} ipython3
con.sql("CREATE TABLE cities AS SELECT * FROM ST_Read('cities.geojson')")
```

```{code-cell} ipython3
con.table("cities")
```

```{code-cell} ipython3
con.sql("SELECT * FROM cities")
```

## Shapefiles

```{code-cell} ipython3
con.sql("SELECT * FROM ST_Read('cities.shp')")
```

```{code-cell} ipython3
con.sql("FROM ST_Read('cities.shp')")
```

```{code-cell} ipython3
con.sql(
    """
        CREATE TABLE IF NOT EXISTS cities2 AS
        SELECT * FROM ST_Read('cities.shp')
        """
)
```

```{code-cell} ipython3
con.table("cities2")
```

```{code-cell} ipython3
con.sql("SELECT * FROM cities2")
```

## GeoParquet Files

```{code-cell} ipython3
con.sql("SELECT * FROM 'cities.parquet'")
```

```{code-cell} ipython3
con.sql(
    """
CREATE TABLE IF NOT EXISTS cities3 AS
SELECT * EXCLUDE geometry, ST_GeomFromWKB(geometry)
AS geometry FROM 'cities.parquet'
"""
)
```

```{code-cell} ipython3
con.table("cities3")
```

```{code-cell} ipython3
con.sql(
    """
CREATE TABLE IF NOT EXISTS country AS
SELECT * EXCLUDE geometry, ST_GeomFromWKB(geometry) FROM
        's3://us-west-2.opendata.source.coop/google-research-open-buildings/v2/geoparquet-admin1/country=SSD/*.parquet'
"""
)
```

```{code-cell} ipython3
con.table("country")
```

```{code-cell} ipython3
con.sql("SELECT COUNT(*) FROM country")
```

## References

- [DuckDB Data Ingestion](https://duckdb.org/docs/api/python/data_ingestion)
