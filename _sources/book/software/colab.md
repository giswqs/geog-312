# Google Colab

[Google Colab](https://colab.research.google.com/) is a free cloud service that supports free GPU and TPU. It is a Jupyter notebook environment that requires no setup to use. It allows you to write and execute Python code in the browser and save your code in Google Drive. It also provides a way to share your code with others.

## Tips and Tricks

1. **Scratchpad Notebook:** <https://colab.research.google.com/notebooks/empty.ipynb>
2. **Open Notebooks from GitHub:** simply replace `github.com` with `githubtocolab.com`. It will redirect you to a Colab notebook.
3. **Open in Colab Chrome extension:** Install this [Open in Colab](https://chrome.google.com/webstore/detail/open-in-colab/iogfkhleblhcpcekbiedikdehleodpjo) extension to open any GitHub notebook in Colab with a single click.
4. **Timing Execution of Cell:** hover over the cell run icon and you will get an estimate of the execution time taken
5. **Run part of a cell:** Click `Runtime -> Run Selection` button or using the keyboard shortcut `Ctrl + Shift + Enter`
6. **Most commonly used shortcuts:**

   - Run cell (`Ctrl + Enter`)
   - Run cell and add new cell below (`Alt + Enter`)
   - Run cell and goto the next cell below (`Shift + Enter`)
   - Comment current line (`Ctrl + /`)

7. **Jupyter Notebook Keyboard Shortcuts:** Click Tools -&gt; Keyboard shortcuts or Just add `Ctrl + M` before whatever keyboard shortcut you were using in Jupyter. For example

   - add a cell above (`Ctrl + M + A`)
   - Add a cell below (`Ctrl + M + B`)
   - Change cell to code (`Ctrl + M + Y`)
   - Change cell to markdown (`Ctrl + M + M`)

8. **Jump to Class definition:** press `Ctrl` and then clicking a class name
9. **Run bash commands:**

   - Download dataset from the web with `!wget <ENTER URL>`
   - Install libraries with `!pip install <LIBRARY>`
   - Clone a git repository with `!git clone <REPOSITORY URL>`
   - Change directory with `!cd`

10. **Mount your Google Drive to Colab:**

```python
from google.colab import drive
drive.mount('/content/gdrive')
```

10. To upload a file (or several) from your computer, run:

```python
from google.colab import files
files.upload()
```

11. To download a file, run:

```python
from google.colab import files
files.download('path/to/your/file')
```

12. **“Open in Colab” Badge:** You can add a `Open in Colab` badge to a markdown file or jupyter notebooks using the following markdown code:

    [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/notebooks/basic_features_overview.ipynb)

    ```text
    [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/notebooks/basic_features_overview.ipynb)
    ```

**References:**

- [Google Colab Tips for Power Users](https://amitness.com/2020/06/google-colaboratory-tips/)
- [10 tricks for a better Google Colab experience](https://towardsdatascience.com/10-tips-for-a-better-google-colab-experience-33f8fe721b82)
