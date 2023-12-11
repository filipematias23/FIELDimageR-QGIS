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
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_2.jpg">
</p>

<br />

[Menu](#menu)

<div id="p3" />

---------------------------------------------
### Building the plot shapefile

FIELDimageR-QGIS allows drawing the plot shape file using the function **fieldShape**. The function starts by creating a layer with four points at the field trial corners according to the steps highlighted below. The points sequence must be (1st point) left superior corner, (2nd point) right superior corner, (3rd point) right inferior corner, and (4th point) left inferior corner. The mosaic will be presented for visualization with the North part on the superior part (top) and the south in the inferior part (bottom). The number of columns and rows must be informed. At this point, the experimental borders can be eliminated (check the example):

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

After creating the **point_shape** layer dubleclick on fieldShape function and follow the steps to creat a basic grid_shapefile:

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

Important to make sure fieldMap is reflecting the real position of each plot in the field:

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_8.jpg">
</p>

<br />

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

[Menu](#menu)

<div id="p1" />

---------------------------------------------
### Installation

Start the pipeline by installing the software:








