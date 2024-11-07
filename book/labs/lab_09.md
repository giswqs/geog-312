---
jupytext:
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.16.4
kernelspec:
  display_name: geo
  language: python
  name: python3
---

# Lab 9

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/labs/lab_09.ipynb)

## Overview

This lab introduces Google Earth Engine (GEE) for accessing and analyzing geospatial data in Python. You will explore diverse data types, including DEM, satellite imagery, and land cover datasets. You’ll gain experience creating cloud-free composites, visualizing temporal changes, and generating animations for time-series data.


## Objectives

By completing this lab, you will be able to:

1. Access and visualize Digital Elevation Model (DEM) data for a specific region.
2. Generate cloud-free composites from Sentinel-2 or Landsat imagery for a specified year.
3. Visualize National Agricultural Imagery Program (NAIP) data for U.S. counties.
4. Display watershed boundaries using Earth Engine styling.
5. Visualize land cover changes over time using split-panel maps.
6. Create a time-lapse animation for land cover changes over time in a region of your choice.

+++

## Exercise 1: Visualizing DEM Data

Find a DEM dataset in the [Earth Engine Data Catalog](https://developers.google.com/earth-engine/datasets) and clip it to a specific area (e.g., your country, state, or city). Display it with an appropriate color palette. For example, the sample map below shows the DEM of the state of Colorado.

![](https://i.imgur.com/OLeSt7n.png)

```{code-cell} ipython3

```

## Exercise 2: Cloud-Free Composite with Sentinel-2 or Landsat

Use Sentinel-2 or Landsat-9 data to create a cloud-free composite for a specific year in a region of your choice.

Use [Sentinel-2](https://developers.google.com/earth-engine/datasets/catalog/COPERNICUS_S2_SR_HARMONIZED) or [Landsat-9 data](https://developers.google.com/earth-engine/datasets/catalog/landsat-9) data to create a cloud-free composite for a specific year in a region of your choice. Display the imagery on the map with a proper band combination. For example, the sample map below shows a cloud-free false-color composite of Sentinel-2 imagery of the year 2021 for the state of Colorado.

![](https://i.imgur.com/xkxpkS1.png)

```{code-cell} ipython3

```

## Exercise 3: Visualizing NAIP Imagery

Use [NAIP](https://developers.google.com/earth-engine/datasets/catalog/USDA_NAIP_DOQQ) imagery to create a cloud-free imagery for a U.S. county of your choice. For example, the sample map below shows a cloud-free true-color composite of NAIP imagery for Knox County, Tennessee. Keep in mind that there might be some counties with the same name in different states, so make sure to select the correct county for the selected state.

![](https://i.imgur.com/iZSGqGS.png)

```{code-cell} ipython3

```

## Exercise 4: Visualizing Watershed Boundaries

Visualize the [USGS Watershed Boundary Dataset](https://developers.google.com/earth-engine/datasets/catalog/USGS_WBD_2017_HUC04) with outline color only, no fill color.

![](https://i.imgur.com/PLlNFq3.png)

```{code-cell} ipython3

```

## Exercise 5: Visualizing Land Cover Change

Use the [USGS National Land Cover Database](https://developers.google.com/earth-engine/datasets/catalog/USGS_NLCD_RELEASES_2019_REL_NLCD) and [US Census States](https://developers.google.com/earth-engine/datasets/catalog/TIGER_2018_States) to create a split-panel map for visualizing land cover change (2001-2019) for a US state of your choice. Make sure you add the NLCD legend to the map.

![](https://i.imgur.com/Au7Q5Ln.png)

```{code-cell} ipython3

```

## Exercise 6: Creating a Landsat Timelapse Animation

Generate a timelapse animation using Landsat data to show changes over time for a selected region.

![Spain](https://github.com/user-attachments/assets/f12839c0-1c30-404d-b0ab-0fa12ce12d24)

```{code-cell} ipython3

```
