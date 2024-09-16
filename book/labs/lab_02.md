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

# Lab 2

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/labs/lab_02.ipynb)

This notebook contains exercises based on the lectures on [**String Operations**](https://geog-312.gishub.org/book/python/04_string_operations.html) and [**Looping and Control Statements**](https://geog-312.gishub.org/book/python/05_looping.html). These exercises will help reinforce the concepts of string manipulation, loops, and conditionals in geospatial contexts.

+++

## Exercise 1: Manipulating Geographic Location Strings

- Create a string that represents the name of a geographic feature (e.g., `"Amazon River"`).
- Convert the string to lowercase and then to uppercase.
- Concatenate the string with the name of the country (e.g., `"Brazil"`) to create a full location name.
- Repeat the string three times, separating each repetition with a dash (`-`).

```{code-cell} ipython3

```

## Exercise 2: Extracting and Formatting Coordinates

- Given a string with the format `"latitude, longitude"` (e.g., `"40.7128N, 74.0060W"`), extract the numeric values of latitude and longitude.
- Convert these values to floats and remove the directional indicators (`N`, `S`, `E`, `W`).
- Format the coordinates into a `POINT` WKT string (e.g., `"POINT(-74.0060 40.7128)"`).

```{code-cell} ipython3

```

## Exercise 3: Building Dynamic SQL Queries

- Given a table name and a condition, dynamically build an SQL query string.
- Example: If `table_name = "cities"` and `condition = "population > 1000000"`, the query should be `"SELECT * FROM cities WHERE population > 1000000;"`.
- Add additional conditions dynamically, like `AND` clauses.

```{code-cell} ipython3

```

## Exercise 4: String Normalization and Cleaning

- Given a list of city names with inconsistent formatting (e.g., `[" new york ", "Los ANGELES", "   CHICAGO"]`), normalize the names by:
  - Stripping any leading or trailing whitespace.
  - Converting them to title case (e.g., `"New York"`, `"Los Angeles"`, `"Chicago"`).
- Ensure that the output is a clean list of city names.

```{code-cell} ipython3

```

## Exercise 5: Parsing and Extracting Address Information

- Given a string in the format `"Street, City, Country"` (e.g., `"123 Main St, Springfield, USA"`), write a function that parses the string into a dictionary with keys `street`, `city`, and `country`.
- The function should return a dictionary like `{"street": "123 Main St", "city": "Springfield", "country": "USA"}`.

```{code-cell} ipython3

```

## Exercise 6: Using For Loops to Process Coordinate Lists

- Create a list of tuples representing coordinates (latitude, longitude).
- Write a `for` loop that prints each coordinate and indicates whether it is in the Northern or Southern Hemisphere based on the latitude.

```{code-cell} ipython3

```

## Exercise 7: While Loops for Iterative Processing

- Create a list of coordinates (latitude, longitude).
- Write a `while` loop that continues to print each coordinate until it encounters a coordinate with a negative latitude.
- Stop the loop once this condition is met.

```{code-cell} ipython3

```

## Exercise 8: Conditional Logic in Loops

- Create a list of coordinates and use a `for` loop to iterate over them.
- Use an `if-elif-else` statement inside the loop to classify each coordinate based on its longitude:
  - Print `"Eastern Hemisphere"` if the longitude is greater than 0.
  - Print `"Western Hemisphere"` if the longitude is less than 0.

```{code-cell} ipython3

```

## Exercise 9: Filtering Data with Combined Loops and Conditionals

- Given a list of coordinates, filter out and store only those located in the Southern Hemisphere (latitude < 0).
- Count the number of coordinates that meet this condition and print the result.

```{code-cell} ipython3

```

## Exercise 10: Generating and Analyzing Random Coordinates

- Write a program that generates random coordinates (latitude and longitude between -180 and 180 degrees).
- Use a `while` loop to keep generating coordinates until a pair with both latitude and longitude greater than 50 is generated.
- Print each generated coordinate and the final coordinate that meets the condition.

```{code-cell} ipython3

```
