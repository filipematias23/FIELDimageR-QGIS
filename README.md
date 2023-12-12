## [FIELDimageR-QGIS](https://github.com/OpenDroneMap/FIELDimageR): A Tool to Analyze Images From Agricultural Field Trials in [QGIS](https://qgis.org/en/site/).

> This package is a compilation of functions made on [R](https://www.r-project.org/) by [Popat Pawar](https://www.linkedin.com/in/dr-popat-pawar-204bb136/) and [Filipe Matias](https://www.linkedin.com/in/filipe-matias-27bab5199/) to analyze orthomosaic images from research fields. To prepare the image it first allows to crop the image, remove soil and weeds and rotate the image. The package also builds a plot shapefile in order to extract information for each plot to evaluate different wavelengths, vegetation indices, stand count, canopy percentage, and plant height.

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_logo.jpg" width="60%" height="60%">
</p>

<div id="menu" />

---------------------------------------------
## Resources
  
[Installation](#instal)

[Step 1. How to start?](#p1)
     
[Step 2. Loading mosaics and visualizing](#p2)

[Step 3. Building the plot shapefile](#p3)

[Step 4. Editing the plot shapefile](#p4)

[Step 5. Building vegetation indices](#p5)

[Step 6. Image segmentation based on unsupervised (K-means) and supervised (Random Forest) methods to remove the soil effect](#p5a)

[Step 7. Extracting data from field images](#p6)

[Step 8. Vizualizing extracted data](#p7)

[Step 9. Saving output files and opening them in the QGIS](#p8) 

[Step 10. Cropping individual plots and saving](#p9)

[Contact](#p21)

<div id="instal" />

---------------------------------------------
### Installation

Start the pipeline by installing the software:

1. [R](https://www.r-project.org/) 
2. [QGIS](https://qgis.org/en/site/).

<br />

Make sure to open the **Processing Toolbox** visualization in **QGIS**:

* (1) View 
* (2) Panels 
* (3) Processing Toolbox 
* (4) Check if the rocessing Toolbox is showing in the right

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_1.jpg">
</p>

<br />

The nest step is installing **Processing R Provider** plugin in **QGIS** following the steps:

* (1) Plugins 
* (2) Manage and Install Plugins 
* (3) All 
* (4) Search for "Processing R Provider" 
* (5) Install Plugin
* (6) Check for R at the Processing Toolbox

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_2.jpg">
</p>

<br />

Downloading **FIELDimageR-QGIS** functions and saving on your **rscripts** QGIS folder:

* (1) Link: [https://github.com/filipematias23/FIELDimageR-QGIS](https://github.com/filipematias23/FIELDimageR-QGIS)
* (2) Press **Code** 
* (3) Download ZIP
* (4) Unzip and save the functions from **rscripts** to your **QGIS rscrits** 
* (5) If you don´t know how to open **QGIS rscrits** just go to QGIS > Processing Toolbox > Options (wrench icon)
* (6) On **Providers** Click on **R**
* (7) Copy the path at **R scripts folder** and open it on your explorer 
* (8) Now past the copied FIELDimageR functions downloaded on **rscripts** folder from the GitHub Tutorial.

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_12a.jpg">
</p>

<br />

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_12.jpg">
</p>

<br />

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_13.jpg">
</p>

<br />

[Menu](#menu)

<div id="p3" />

---------------------------------------------
### Building the plot shapefile

FIELDimageR-QGIS allows drawing the plot shape file using the function **fieldShape**. The function starts by creating a layer with four points at the field trial corners according to the steps highlighted below. The points sequence must be (1st point) left superior corner, (2nd point) right superior corner, (3rd point) right inferior corner, and (4th point) left inferior corner. At this point, the experimental borders can be eliminated (check the example). The mosaic will be presented for visualization with the North part on the superior part (top) and the south in the inferior part (bottom).

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_3.jpg">
</p>

<br />

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_4.jpg">
</p>

<br />

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_5.jpg">
</p>

<br />

After creating the **point_shape** layer dubleclick on **`fieldShape`** function at the **Processing Toolbox > R > FIELDimageR > fieldShape** and follow the steps below to creat a basic *grid_shapefile*. For instance, the number of columns and rows must be informed:

> Attention: The plots are identified in ascending order from left to right and bottom to top being evenly spaced and distributed inside the selected area independent of alleys.

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_6.jpg">
</p>

<br />

One matrix can be used to identify the plots position according to the image above. The user can creat a matrix (manually built) informing plots ID. For instance, the new column PlotID will be the new identification. You can download an external table with field data example here: [fieldData.csv](https://drive.google.com/file/d/1elAOEg-tw_zMQuPnZT5MTwWmrpB-sYSv/view?usp=sharing) and a fieldMap matrix with plots ID example here: [fieldMap.csv](https://drive.google.com/file/d/1lFqZFmaXqzk3UqoN5VH_lOLRilzB6K_d/view?usp=sharing)

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_7.jpg">
</p>

<br />

Check below some examples of **`fieldData.csv`** and **`fieldMap.csv`**. Important to make sure that fieldMap is reflecting the real position of each plot in the field:

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_8.jpg">
</p>

<br />

After creating the grid_shapefile right click and **Open Attribute Table** to check if the plots are correctly positioned:

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_11.jpg">
</p>

<br />

Users can use a specific plot size to build the grid shape file by informing X and Y plot length in the parameter x_plot_size and y_plot_size. It´s very important to highlight the applied values are connected with the mosaic resolution and unit. For example, x_plot_size=0.6 means 0.6m and x_plot_size=5 means 5m or (60cm by 400cm) in the example below

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_9.jpg">
</p>

<br />

Coloring and visualizing **grid_fieldshape** based on traits imported from **fieldData.csv**:

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_10.jpg">
</p>

<br />

> **Attention:** There is another great *software/tutorial* provided by [Diego Gris](https://www.linkedin.com/in/diego-gris/) called **`draw-plots-qgis`** with some other ways to biuld *grig_shapefiles*, check it at: [https://github.com/diegojgris/draw-plots-qgis](https://github.com/diegojgris/draw-plots-qgis)

* Option-01: Draw_plots_from_Excel
* Option-02: Draw_plots_from_clicks
* Option-03: Draw_plots_from_points
* Option-04: Draw_plots_from_polygons

<br />

[Menu](#menu)

<div id="p5" />

---------------------------------------------
### Building vegetation indices

A general number of indices are implemented in *FIELDimageR-QGIS* using the function **`fieldIndex`**. Also, you can build your own index using the parameter `myIndex`. 

<br />

<p align="center">
  <img src="https://raw.githubusercontent.com/filipematias23/images/master/readme/F6ind3.jpeg">
</p>

<br />

Calculating vegetation indices is very simple. Users must provide the sequence of bands/wavelength avaliable in the raster. As an example, the layers must be writed 'Red,Blue,Green' for RGB. Attention: it must be 'Red' and NOT 'red'; 'Blue' and NOT 'blue'; 'Green' and NOT 'green'.

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_14.jpg">
</p>

<br />

To better visualize specific vegetation index you can coloring it by doing a duble click at **Index layer** and folow the steps below:

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_15.jpg">
</p>

<br />

Multispectral images also can be used. For instance, it is important to write the right order of layers, for example **Blue,Green,Red,RE,NIR**. It must be write 'RE' and NOT 'RedEdge'. You can download one example of **Multispectral** here: [**EX1_5Band.tif**](https://drive.google.com/open?id=1vYb3l41yHgzBiscXm_va8HInQsJR1d5Y)

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_16.jpg">
</p>

<br />


