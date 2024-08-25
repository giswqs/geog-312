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

# Get Started

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/geospatial/get_started.ipynb)


## Environment Setup

To run the code examples in this book, you need to set up a Python environment with the necessary libraries installed. The easiest way to set up the environment is to use the conda package manager. If you don't have conda installed, you can download and install Miniconda from [here](https://docs.conda.io/en/latest/miniconda.html). After installing Miniconda, you can create a new conda environment and install the necessary libraries using the following commands:

```bash
conda create -n geo python=3.11
conda activate geo
conda install -n base mamba -c conda-forge
mamba install -c conda-forge geemap leafmap
```

## Test the Installation

You can test the installation by running the following code:

```{code-cell} ipython3
import leafmap
```

```{code-cell} ipython3
m = leafmap.Map()
m
```
