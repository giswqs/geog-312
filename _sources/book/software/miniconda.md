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

After installing Miniconda, you can open the **Anaconda Prompt** or **Terminal** to create a new environment and install packages required for this course using the following commands:

```bash
conda create -n geo python=3.11
conda activate geo
conda install -n base mamba -c conda-forge
mamba install -c conda-forge geemap leafmap
```

## Accessing Conda in Windows Terminal

If you did not add Conda to your PATH during installation, you can do it manually:

1. **Open the Start Menu** and search for "Environment Variables."
2. **Click on "Edit the system environment variables."**
3. In the System Properties window, click on **"Environment Variables."**
4. Under "System Variables," find the **`Path`** variable and select it.
5. Click **"Edit"** and then **"New."**
6. Add the following paths to the list:
   - `C:\Users\<YourUsername>\miniconda3\Scripts`
7. Click **"OK"** to close all windows.

![image](https://github.com/user-attachments/assets/427ea290-8ea8-42a5-b070-854696f71fc5)

## Common Commands

Here are some common commands to manage environments and packages using conda:

### Creating and Managing Environments

- **Create a new environment:**

  ```bash
  conda create -n myenv python=3.11
  ```

  Replace `myenv` with your desired environment name and `python=3.11` with the version of Python you need.

- **Activate an environment:**

  ```bash
  conda activate myenv
  ```

- **Deactivate the current environment:**

  ```bash
  conda deactivate
  ```

- **List all environments:**

  ```bash
  conda env list
  ```

- **Remove an environment:**
  ```bash
  conda remove -n myenv --all
  ```

### Installing and Managing Packages

- **Install a package in the current environment:**

  ```bash
  conda install numpy
  ```

- **Install a package in a specific environment:**

  ```bash
  conda install -n myenv pandas
  ```

- **Install packages from the conda-forge channel:**

  ```bash
  conda install -c conda-forge geopandas
  ```

- **Install multiple packages at once:**

  ```bash
  conda install scipy matplotlib seaborn
  ```

- **Update all packages in an environment:**

  ```bash
  conda update --all
  ```

- **Search for a package:**

  ```bash
  conda search scikit-learn
  ```

- **List all installed packages in the current environment:**

  ```bash
  conda list
  ```

- **Remove a package:**
  ```bash
  conda remove numpy
  ```

### Using Mamba (Faster Package Management)

After installing Mamba, you can use it for faster package management:

- **Install mamba in the base environment:**

  ```bash
  conda install -n base mamba -c conda-forge
  ```

- **Install packages using mamba:**
  ```bash
  mamba install -c conda-forge geemap leafmap
  ```

These commands should help you effectively manage your Python environments and packages using Miniconda.
