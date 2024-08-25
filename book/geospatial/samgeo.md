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

# SAMGeo

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/giswqs/geog-312/blob/main/book/geospatial/samgeo.ipynb)

## Install dependencies

Uncomment and run the following cell to install the required dependencies.

```{code-cell} ipython3
# %pip install segment-geospatial groundingdino-py leafmap localtileserver
```

## Import libraries

```{code-cell} ipython3
import leafmap
from samgeo import SamGeo
from samgeo.text_sam import LangSAM
```

## Download sample data

### Create an interactive map

```{code-cell} ipython3
m = leafmap.Map(center=[40.427495, -86.913638], zoom=18, height=700)
m.add_basemap("SATELLITE")
m
```

Pan and zoom the map to select the area of interest. Use the draw tools to draw a polygon or rectangle on the map

```{code-cell} ipython3
if m.user_roi_bounds() is not None:
    bbox = m.user_roi_bounds()
else:
    bbox = [-86.9167, 40.4262, -86.9105, 40.4289]
```

### Download map tiles

Download maps tiles and mosaic them into a single GeoTIFF file

```{code-cell} ipython3
image = "image.tif"
```

Specify the basemap as the source.

```{code-cell} ipython3
leafmap.map_tiles_to_geotiff(
    output=image, bbox=bbox, zoom=18, source="Satellite", overwrite=True
)
```

You can also use your own image. Uncomment and run the following cell to use your own image.

```{code-cell} ipython3
# image = '/path/to/your/own/image.tif'
```

Display the downloaded image on the map.

```{code-cell} ipython3
m.layers[-1].visible = False  # turn off the basemap
m.add_raster(image, layer_name="Image")
m
```

![](https://i.imgur.com/YHwrpS2.png)

+++

## Automatic mask generation

### Initialize SAM class

```{code-cell} ipython3
sam = SamGeo(
    model_type="vit_h",
    sam_kwargs=None,
)
```

### Automatic mask generation

Segment the image and save the results to a GeoTIFF file. Set `unique=True` to assign a unique ID to each object.

```{code-cell} ipython3
sam.generate(image, output="masks.tif", foreground=True, unique=True)
```

```{code-cell} ipython3
sam.show_masks(cmap="binary_r")
```

![](https://i.imgur.com/kWqLVuL.png)

+++

Show the object annotations (objects with random color) on the map.

```{code-cell} ipython3
sam.show_anns(axis="off", alpha=1, output="annotations.tif")
```

![](https://i.imgur.com/J6Ie0Zj.png)

+++

Compare images with a slider.

```{code-cell} ipython3
leafmap.image_comparison(
    "image.tif",
    "annotations.tif",
    label1="Satellite Image",
    label2="Image Segmentation",
)
```

![](https://i.imgur.com/cm4QyaR.png)

+++

Add image to the map.

```{code-cell} ipython3
m.add_raster("annotations.tif", opacity=0.5, layer_name="Masks")
m
```

![](https://i.imgur.com/Y6EaGVN.png)

+++

Convert the object annotations to vector format, such as GeoPackage, Shapefile, or GeoJSON.

```{code-cell} ipython3
sam.raster_to_vector("masks.tif", "masks.shp")
```

```{code-cell} ipython3
m.add_vector("masks.shp", layer_name="Masks vector")
```

![](https://i.imgur.com/N0xVt9S.png)

+++

### Automatic mask generation options

There are several tunable parameters in automatic mask generation that control how densely points are sampled and what the thresholds are for removing low quality or duplicate masks. Additionally, generation can be automatically run on crops of the image to get improved performance on smaller objects, and post-processing can remove stray pixels and holes. Here is an example configuration that samples more masks:

```{code-cell} ipython3
sam_kwargs = {
    "points_per_side": 32,
    "pred_iou_thresh": 0.86,
    "stability_score_thresh": 0.92,
    "crop_n_layers": 1,
    "crop_n_points_downscale_factor": 2,
    "min_mask_region_area": 100,
}
```

```{code-cell} ipython3
sam = SamGeo(
    model_type="vit_h",
    sam_kwargs=sam_kwargs,
)
```

```{code-cell} ipython3
sam.generate(image, output="masks2.tif", foreground=True)
```

```{code-cell} ipython3
sam.show_masks(cmap="binary_r")
```

![](https://i.imgur.com/S2LYen8.png)

```{code-cell} ipython3
sam.show_anns(axis="off", opacity=1, output="annotations2.tif")
```

![](https://i.imgur.com/opEKsUu.png)

+++

Compare images with a slider.

```{code-cell} ipython3
leafmap.image_comparison(
    image,
    "annotations.tif",
    label1="Image",
    label2="Image Segmentation",
)
```

## Use points as input prompts

### Initialize SAM class

+++

Set `automatic=False` to disable the `SamAutomaticMaskGenerator` and enable the `SamPredictor`.

```{code-cell} ipython3
m = leafmap.Map(center=[40.427495, -86.913638], zoom=18, height=700)
image = "image.tif"
m.add_raster(image, layer_name="Image")
m
```

```{code-cell} ipython3
sam = SamGeo(
    model_type="vit_h",
    automatic=False,
    sam_kwargs=None,
)
```

Specify the image to segment.

```{code-cell} ipython3
sam.set_image(image)
```

### Image segmentation with input points

A single point can be used to segment an object. The point can be specified as a tuple of (x, y), such as (col, row) or (lon, lat). The points can also be specified as a file path to a vector dataset. For non (col, row) input points, specify the `point_crs` parameter, which will automatically transform the points to the image column and row coordinates.

Try a single point input:

```{code-cell} ipython3
point_coords = [[-86.913162, 40.427157]]
sam.predict(point_coords, point_labels=1, point_crs="EPSG:4326", output="mask1.tif")
m.add_raster("mask1.tif", layer_name="Mask1", nodata=0, cmap="Blues", opacity=1)
m
```

![](https://i.imgur.com/zUMLUsn.png)

+++

Try multiple points input:

```{code-cell} ipython3
point_coords = [
    [-86.913162, 40.427157],
    [-86.913425, 40.427157],
    [-86.91343, 40.427721],
    [-86.913012, 40.427741],
]
sam.predict(point_coords, point_labels=1, point_crs="EPSG:4326", output="mask2.tif")
m.add_raster("mask2.tif", layer_name="Mask2", nodata=0, cmap="Greens", opacity=1)
m
```

![](https://i.imgur.com/zUMLUsn.png)

+++

### Interactive segmentation

Display the interactive map and use the marker tool to draw points on the map. Then click on the `Segment` button to segment the objects. The results will be added to the map automatically. Click on the `Reset` button to clear the points and the results.

```{code-cell} ipython3
m = sam.show_map()
m
```

![](https://i.imgur.com/3W7JGqP.png)

+++

## Bounding box input prompts

+++

### Create an interactive map

```{code-cell} ipython3
m = leafmap.Map(center=[40.427495, -86.913638], zoom=18, height=700)
image = "image.tif"
m.add_raster(image, layer_name="Image")
m
```

```{code-cell} ipython3
sam = SamGeo(
    model_type="vit_h",
    automatic=False,
    sam_kwargs=None,
)
```

Specify the image to segment.

```{code-cell} ipython3
sam.set_image(image)
```

### Create bounding boxes

If no rectangles are drawn, the default bounding boxes will be used as follows:

```{code-cell} ipython3
if m.user_rois is not None:
    boxes = m.user_rois
else:
    boxes = [
        [-86.913654, 40.426967, -86.912774, 40.427881],
        [-86.914780, 40.426256, -86.913997, 40.426852],
        [-86.913632, 40.426215, -86.912581, 40.426820],
    ]
```

## Segment the image

Use the `predict()` method to segment the image with specified bounding boxes. The `boxes` parameter accepts a list of bounding box coordinates in the format of [[left, bottom, right, top], [left, bottom, right, top], ...], a GeoJSON dictionary, or a file path to a GeoJSON file.

```{code-cell} ipython3
sam.predict(boxes=boxes, point_crs="EPSG:4326", output="mask.tif", dtype="uint8")
```

## Display the result

Add the segmented image to the map.

```{code-cell} ipython3
m.add_raster("mask.tif", cmap="viridis", nodata=0, opacity=0.6, layer_name="Mask")
m
```

![](https://i.imgur.com/9y31xUH.png)

+++

## Text promots

### Initialize LangSAM class

The initialization of the LangSAM class might take a few minutes. The initialization downloads the model weights and sets up the model for inference.

```{code-cell} ipython3
m = leafmap.Map(center=[40.427495, -86.913638], zoom=18, height=700)
image = "image.tif"
m.add_raster(image, layer_name="Image")
m
```

```{code-cell} ipython3
sam = LangSAM()
```

### Specify text prompts

```{code-cell} ipython3
text_prompt = "tree"
```

### Segment the image

Part of the model prediction includes setting appropriate thresholds for object detection and text association with the detected objects. These threshold values range from 0 to 1 and are set while calling the predict method of the LangSAM class.

`box_threshold`: This value is used for object detection in the image. A higher value makes the model more selective, identifying only the most confident object instances, leading to fewer overall detections. A lower value, conversely, makes the model more tolerant, leading to increased detections, including potentially less confident ones.

`text_threshold`: This value is used to associate the detected objects with the provided text prompt. A higher value requires a stronger association between the object and the text prompt, leading to more precise but potentially fewer associations. A lower value allows for looser associations, which could increase the number of associations but also introduce less precise matches.

Remember to test different threshold values on your specific data. The optimal threshold can vary depending on the quality and nature of your images, as well as the specificity of your text prompts. Make sure to choose a balance that suits your requirements, whether that's precision or recall.

```{code-cell} ipython3
sam.predict(image, text_prompt, box_threshold=0.24, text_threshold=0.24)
```

### Visualize the results

Show the result with bounding boxes on the map.

```{code-cell} ipython3
sam.show_anns(
    cmap="Greens",
    box_color="red",
    title="Automatic Segmentation of Trees",
    blend=True,
)
```

![](https://i.imgur.com/qRcy16Z.png)

+++

Show the result without bounding boxes on the map.

```{code-cell} ipython3
sam.show_anns(
    cmap="Greens",
    add_boxes=False,
    alpha=0.5,
    title="Automatic Segmentation of Trees",
)
```

![](https://i.imgur.com/TvqGByH.png)

+++

Show the result as a grayscale image.

```{code-cell} ipython3
sam.show_anns(
    cmap="Greys_r",
    add_boxes=False,
    alpha=1,
    title="Automatic Segmentation of Trees",
    blend=False,
    output="trees.tif",
)
```

Convert the result to a vector format.

```{code-cell} ipython3
sam.raster_to_vector("trees.tif", "trees.shp")
```

Show the results on the interactive map.

```{code-cell} ipython3
m.add_raster("trees.tif", layer_name="Trees", palette="Greens", opacity=0.5, nodata=0)
style = {
    "color": "#3388ff",
    "weight": 2,
    "fillColor": "#7c4185",
    "fillOpacity": 0.5,
}
m.add_vector("trees.shp", layer_name="Vector", style=style)
m
```

![](https://i.imgur.com/WDQgECD.png)

+++

### Interactive segmentation

```{code-cell} ipython3
sam.show_map()
```

![](https://i.imgur.com/Zn7Dwty.png)
