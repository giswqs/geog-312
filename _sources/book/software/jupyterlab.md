# JupyterLab

JupyterLab is a web-based interactive development environment for Jupyter notebooks, code, and data. JupyterLab is flexible: configure and arrange the user interface to support a wide range of workflows in data science, scientific computing, and machine learning. JupyterLab is extensible and modular: write plugins that add new components and integrate with existing ones.

## Installation

To install JupyterLab, you can use the following commands:

```bash
pip install jupyterlab
```

## Usage

To start JupyterLab, you can use the following command:

```bash
jupyter lab
```

To create a new Jupyter notebook, click on the **+** icon in the file browser and select the desired kernel.

![](https://book.geemap.org/_images/ch01_jupyterlab.jpg)

## Keyboard shortcuts

Jupyter notebook has two modes: **Edit mode** and **Command mode**. The Edit mode allows you to type into the cells like a normal text editor. The Command mode allows you to edit the notebook as a whole, but not type into individual cells. Jupyter notebook has many keyboard shortcuts {cite}`Yordanov2017-hl`. Here are some commonly used shortcuts. Note that the shortcuts are for Windows and Linux users. For Mac users, replace `Ctrl` with `Command`.

Shortcuts in both modes:

- `Shift + Enter`: run the current cell, select below
- `Ctrl + Enter`: run selected cells
- `Alt + Enter`: run the current cell, insert below
- `Ctrl + S`: save and checkpoint

While in command mode (press `Esc` to activate):

- `A`: insert cell above
- `B`: insert cell below
- `X`: cut selected cells
- `C`: copy selected cells
- `V`: paste cells below
- `Y`: change the cell type to Code
- `M`: change the cell type to Markdown
- `P`: open the command palette

While in edit mode (press `Enter` to activate):

- `Esc`: activate the command mode
- `Tab`: code completion or indent
- `Shift + Tab`: show tooltip
