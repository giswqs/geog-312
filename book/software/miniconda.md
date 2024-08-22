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

# Miniconda

[Miniconda](https://docs.anaconda.com/miniconda) is a free minimal installer for conda. It is a small, bootstrap version of Anaconda that includes only conda, Python, the packages they depend on, and a small number of other useful packages, including pip, zlib, and a few others.

## Installation

To install Miniconda, download the installer from the [Miniconda website](https://docs.anaconda.com/miniconda) and run the installer. The installer will ask you to accept the license agreement, choose the installation directory, and add the conda path to your shell profile.

## Usage

After installing Miniconda, you can open the **Anaconda Prompt** or **Terminal** to create a new environment and install packages using the following commands:

```bash
conda create -n geo python=3.11
conda activate geo
conda install -n base mamba -c conda-forge
mamba install -c conda-forge geemap leafmap
```
