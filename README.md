## [FIELDimageR-QGIS](https://github.com/filipematias23/FIELDimageR-QGIS): A Tool to Analyze Images From Agricultural Field Trials in [QGIS](https://qgis.org/en/site/).

> This tutorial is a compilation of functions made on [R](https://www.r-project.org/) by [Popat Pawar](https://www.linkedin.com/in/dr-popat-pawar-204bb136/) and [Filipe Matias](https://www.linkedin.com/in/filipe-matias-27bab5199/) to analyze orthomosaic images from research fields using [QGIS](https://qgis.org/en/site/). The tutorial teaches how to build a plot shapefile to extract information for each plot, enabling the evaluation of different reflectance values at various wavelengths, vegetation indices, canopy percentage, counting plants (stand count), and plant height. It also guides in removing soil and segmenting orthomosaics to create masks. 

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_logo.jpg" width="70%" height="70%">
</p>

<div id="menu" />

---------------------------------------------
## Resources
  
[Step 1. Installation](#instal)
     
[Step 2. Loading mosaics and visualizing](#p2)

[Step 3. Building the plot shapefile](#p3)

[Step 4. Editing the plot shapefile](#p4)

[Step 5. Building vegetation indices](#p5)

[Step 6. Removing the soil effect based on image segmentation](#p6)

[Step 7. Extracting data from field images and visualization](#p7)

[Step 8. Estimating plant height and biomass](#p8)

[Step 9. Estimating object area percentage (e.g. canopy and LAI)](#p9) 

[Step 10. Counting the number of objects and taking measurements (e.g. stand count, plants, etc.)](#p10)

[Step 11. Saving output files](#p11)

[Step 12. Cropping individual plots and saving](#p12)

[Step 13. Image segmentation based on Kmeans (Unsupervised)](#p13)

[Step 14. Image segmentation based on machine learning models as Random Forest (Supervised)](#p14)

[Contact](#contact)

<div id="instal" />

---------------------------------------------
### Installation

> Start the pipeline by installing the software:

1. [R](https://www.r-project.org/) 
2. [QGIS](https://qgis.org/en/site/).

<br />

> Make sure to open the **Processing Toolbox** visualization in **QGIS**:

* (1) View 
* (2) Panels 
* (3) Processing Toolbox 
* (4) Check if the rocessing Toolbox is showing in the right

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_1.jpg">
</p>

<br />

> The nest step is installing **Processing R Provider** plugin in **QGIS** following the steps:

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

> Downloading **FIELDimageR-QGIS** functions and saving on your **rscripts** QGIS folder:

<br />

**Install - Option 01:**

<br />

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

**Install - Option 02:**

<br />

> Another easier option is adding the downloaded **FIELDimageR-QGIS > rscripts** folder as an additional **rscripts** at QGIS by following the steps below: 

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_35.jpg">
</p>

<br />

[Menu](#menu)

<div id="p2" />

---------------------------------------------
### Loading mosaics and visualizing

> There are many ways to create or start a **New Project** in QGIS. The image below highlights some examples:

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_29a.jpg">
</p>

<br />

> Uploading files (e.g., raster, table, shapefiles, etc.) to QGIS is very simple:

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_30.jpg">
</p>

<br />

[Menu](#menu)

<div id="p3" />

---------------------------------------------
### Building the plot shapefile

> FIELDimageR-QGIS allows drawing the plot shape file using the function **fieldShape**. The function starts by creating a layer with four points at the field trial corners according to the steps highlighted below. The points sequence must be (1st point) left superior corner, (2nd point) right superior corner, (3rd point) right inferior corner, and (4th point) left inferior corner. At this point, the experimental borders can be eliminated (check the example). The mosaic will be presented for visualization with the North part on the superior part (top) and the south in the inferior part (bottom).

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

> After creating the **point_shape** layer dubleclick on **`fieldShape`** function at the **Processing Toolbox > R > FIELDimageR > fieldShape** and follow the steps below to creat a basic *grid_shapefile*. For instance, the number of columns and rows must be informed:

Attention: The plots are identified in ascending order from left to right and bottom to top being evenly spaced and distributed inside the selected area independent of alleys.

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_6.jpg">
</p>

<br />

> One matrix can be used to identify the plots position according to the image above. The user can creat a matrix (manually built) informing plots ID. For instance, the new column PlotID will be the new identification. You can download an external table with field data example here: [fieldData.csv](https://drive.google.com/file/d/1elAOEg-tw_zMQuPnZT5MTwWmrpB-sYSv/view?usp=sharing) and a fieldMap matrix with plots ID example here: [fieldMap.csv](https://drive.google.com/file/d/1lFqZFmaXqzk3UqoN5VH_lOLRilzB6K_d/view?usp=sharing)

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_7.jpg">
</p>

<br />

> Check below some examples of **`fieldData.csv`** and **`fieldMap.csv`**. Important to make sure that fieldMap is reflecting the real position of each plot in the field:

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_8.jpg">
</p>

<br />

> After creating the grid_shapefile right click and **Open Attribute Table** to check if the plots are correctly positioned:

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_11.jpg">
</p>

<br />

> Users can use a specific plot size to build the grid shape file by informing X and Y plot length in the parameter x_plot_size and y_plot_size. It´s very important to highlight the applied values are connected with the mosaic resolution and unit. For example, x_plot_size=0.6 means 0.6m and x_plot_size=5 means 5m or (60cm by 400cm) in the example below

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_9.jpg">
</p>

<br />

> Coloring and visualizing **grid_fieldshape** based on traits imported from **fieldData.csv**:

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

<div id="p4" />

---------------------------------------------
### Editing the plot shapefile

> QGIS has great tools to edit shapefiles and plots. For instance, the user needs first to activete the **Advanced Digitizing Toolbar**.

* Activate it at **View > Toolbars > Advanced Digitizing Toolbar**

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_27.jpg">
</p>

<br />

* Editing plots is very simple and intuitive:

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_28.jpg">
</p>

<br />

[Menu](#menu)

<div id="p5" />

---------------------------------------------
### Building vegetation indices

> A general number of indices are implemented in *FIELDimageR-QGIS* using the function **`fieldIndex`**.  

<br />

<p align="center">
  <img src="https://raw.githubusercontent.com/filipematias23/images/master/readme/F6ind3.jpeg">
</p>

<br />

> Calculating vegetation indices is very simple. Users must provide the sequence of bands/wavelength avaliable in the raster. As an example, the layers must be writed 'Red,Blue,Green' for RGB. Attention: it must be 'Red' and NOT 'red'; 'Blue' and NOT 'blue'; 'Green' and NOT 'green'.

* Attention: You need to save the output_index in a folder (Do not forget to save it otherwise the function doesn´t work) !!!

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_14.jpg">
</p>

<br />

> To better visualize specific vegetation index you can coloring it by doing a duble click at **Indices layer** and folowing the steps below:

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_15.jpg">
</p>

<br />

> Multispectral images also can be used. For instance, it is important to write the right order of layers, for example **Blue,Green,Red,RE,NIR**. It must be write 'RE' and NOT 'RedEdge'. You can download one example of **Multispectral** here: [**EX1_5Band.tif**](https://drive.google.com/open?id=1vYb3l41yHgzBiscXm_va8HInQsJR1d5Y)

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_16.jpg">
</p>

<br />

[Menu](#menu)

<div id="p6" />

---------------------------------------------
### Removing the soil effect based on image segmentation

> The traditional way to remove soil effect by image segmentation called *Thresholding Method* was implemented in the function **`fieldMask`**:

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_21.jpg">
</p>

<br />

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_22.jpg">
</p>

<br />

> Checking the quality of image segmentation to make sure the soil was removed:

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_23.jpg">
</p>

<br />

[Menu](#menu)

<div id="p7" />

---------------------------------------------
### Extracting data from field images

> The function * exact_extract* from **[exactextractr](https://github.com/isciences/exactextractr)** was adapted for agricultural field experiments through function **`fieldInfo`**, where users can extract the mean, max, min, and sum per plot:

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_17.jpg">
</p>

<br />

> Checking the **Attribute Table** to make sure data were extracted per plot:

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_18.jpg">
</p>

<br />

> Visualizing extracted data and coloring plots according to the average value by doing a duble click at **output shapefile info** and folowing the steps below:

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_33.jpg">
</p>

<br />

[Menu](#menu)

<div id="p8" />

---------------------------------------------
### Estimating plant height and biomass

> The plant height can be estimated by calculating the Canopy Height Model (CHM) and biomass by calculating Canopy Volume Model (CVM). This model uses the difference between the Digital Surface Model (DSM) from the soil base (before there is any sproute, [Download EX_DSM0.tif](https://drive.google.com/open?id=1lrq-5T6x_GrbkCtpDSDiX1ldvSwEBFX-)) and the DSM file from the vegetative growth (once plants are grown, [Download EX_DSM1.tif](https://drive.google.com/open?id=1q_H4Ef1f1yQJOPtkVMJfcb2SvHcxJ3ya)). To calculate CHM and CVM we used the function **`fieldHeight`**, where CVM=cellSize(CHM)*CHM. 

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_19.jpg" width="70%" height="70%">
</p>

<br />

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_20.jpg">
</p>

<br />

> To better visualize the Canopy-Height-Model (CHM) and Canopy-Volume-Model (CVM) you can coloring it by doing a duble click at **output CHM** or **output CVM** and folowing the steps below:

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_34.jpg">
</p>

<br />

[Menu](#menu)

<div id="p9" />

---------------------------------------------
### Estimating object area percentage (e.g. canopy and LAI)

> FIELDimageR-QGIS can be used to evaluate the canopy percentage per plot or LAI (Leaf Area Index). The mask output from **`fieldMask`** and the grig_fieldshape output from **`fieldShape`** must be used. Function to use: **`fieldArea`**.

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_24.jpg">
</p>

<br />

> To better visualize AreaPercentage or Canopy you can coloring it by doing a duble click at **output fieldArea** and folowing the steps below:

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_26.jpg">
</p>

<br />

> Checking if the values make sense: 

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_25.jpg">
</p>

<br />

[Menu](#menu)

<div id="p10" />

---------------------------------------------
#### Counting the number of objects and taking measurements (e.g. stand count, plants, etc.)

> *FIELDimageR-QGIS* can be used to evaluate stand count during early stages. A good weed control practice should be performed to avoid misidentification inside the plot.  The *mask* output from **`fieldMask`** and the *fieldshape* output from **`fieldShape`** must be used. Function to use: **`fieldCount`**.

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_38a.jpg">
</p>

<br />

This function generates:
 * New shapeFile with objects in the **PLOT** (data per plot in the grid: area, perimeter, count, and mean_width).
 * New shapeFile of single **OBJECTS** (data per object: area, perimeter, width, x and y position).

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_38b.jpg">
</p>

<br />

[Menu](#menu)

<div id="p11" />

---------------------------------------------
### Saving output files

> Saving projects is very easy in QGIS. The format is **`Project.qgz`**:

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_31.jpg">
</p>

<br />

> Shapefiles (e.g., grids, points, polygons, etc.) and images can be saved by selecting the layer and clicking on **Export**. Make sure to select the right **Format**, for example the **`ESRI Shapelife`** for grids_fieldshape. Also, the right **CRS**, for our example is **`EPSG:32616 - WGS 84`**:

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_32.jpg">
</p>

<br />

[Menu](#menu)

<div id="p12" />

---------------------------------------------
### Cropping individual plots and saving

> Many times when developing algorithms it is necessary to crop the mosaic using the plot fieldShape as a reference and sort/store cropped plot images on specific folders. For instance, the function **`fieldCropGrid`** allows cropping plots and identification by 'plotID'. The user also can save each plot according to a 'classifier' logic (Attention: a column in the 'fieldShape' with the desired classification must be informed). In the example below, each plot in the **'EX1_RGB'** mosaic is being cropped according to the **'grid_shape'** shapefile, identified by the information in the **'plot'** column, and stored/saved in specific folders with different levels of **Maturity** as **'classifier'**.

<br />

**Attention:** There is **NO** output returned to QGIS. All cropped plots will be saved in the **output_directory**.

<br />

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_36.jpg">
</p>

<br />

> Checking cropped plots **.jpg** classified in each Maturity level folder: 

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_37a.jpg" width="70%" height="70%">
</p>

<br />

[Menu](#menu)

<div id="p13" />

---------------------------------------------
### Image segmentation based on K-means (unsupervised)

> **FIELDimageR-QGIS** introduce the function **`fieldKmeans`** that uses the K-means unsupervised method for image segmentation. This function clusters pixels on the number of clusters decided by the user. Each cluster can be associated with plants, soil, shadows, etc.

<br />

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_39.jpg">
</p>

<br />

> **Attention:** Each image/mosaic will have different cluster numbers representing plants or soil. In this example, cluster_01 is plants and cluster_02 is soil.

<br />

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_40.jpg" width="70%" height="70%">
</p>

<br />

[Menu](#menu)

<div id="p14" />

---------------------------------------------
### Image segmentation based on machine learning models as Random Forest (Supervised)

> **FIELDimageR-QGIS** has one function called **`fieldSegment`** that uses samples of images and machine learning algorithms for pixel classification (Supervised method). There are two models included Random Forest (default) and cart. Initially, users need to create training samples by creating a **Polygon Layer** (example below) or **Point Layer** to digitize spatial object (e.g. soil, plant, shadow etc.). For instance, users need to utilize the draw polygon or draw rectangle tool. 

<br />

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_41.jpg">
</p>

<br />

> Selected training samples by creating polygons representing CLASS="soil" and CLASS="plant":

<br />

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_42.jpg">
</p>

<br />

> Checking **Attribute Table** IDs and CLASS columns according to the selected training samples:

<br />

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_43.jpg">
</p>

<br />

> After creating the training dataset, the function is very simple and intuitive to use:

<br />

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_44.jpg">
</p>

<br />

> Checking segmentation results based on the selected training samples:

<br />

<p align="center">
  <img src="https://github.com/filipematias23/images_FQ/blob/main/readme/qgis_45.jpg" width="70%" height="70%">
</p>

<br />

[Menu](#menu)

<div id="contact" />

---------------------------------------------
### More information about **FIELDimageR**:

* [FIELDimageR R package](https://github.com/OpenDroneMap/FIELDimageR)
* [FIELDimageR.Extra R package](https://github.com/filipematias23/FIELDimageR.Extra)

<br />

### Google Groups Forum

> This discussion group provides an online source of information about the FIELDimageR package. Report a bug and ask a question at: 
* https://groups.google.com/forum/#!forum/fieldimager 
* https://community.opendronemap.org/t/about-the-fieldimager-category/4130

<br />

### Developers
> **Help improve FIELDimageR-QGIS pipeline**. The easiest way to modify the package is by cloning the repository and making changes using [R projects](https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects).

> If you have questions, join the forum group at https://groups.google.com/forum/#!forum/fieldimager

>Try to keep commits clean and simple

>Submit a **_pull request_** with detailed changes and test results.

**Let's  work together and help more people (students, professors, farmers, etc) to have access to this knowledge. Thus, anyone anywhere can learn how to apply remote sensing in agriculture.** 

<br />

### Licenses

> The R/FIELDimageR package as a whole is distributed under [GPL-3 (GNU General Public License version 3)](https://www.gnu.org/licenses/gpl-3.0.en.html).

<br />

### Citation

* *Pawar P & Matias FI.* FIELDimageR-QGIS (2024). (submitted) 

* *Pawar P. & Matias FI.* FIELDimageR.Extra: Advancing user experience and computational efficiency for analysis of orthomosaic from agricultural field trials. **The Plant Phenome J.** 2023; [https://doi.org/10.1002/ppj2.20083](https://doi.org/10.1002/ppj2.20083)

* *Matias FI, Caraza-Harter MV, Endelman JB.* FIELDimageR: An R package to analyze orthomosaic images from agricultural field trials. **The Plant Phenome J.** 2020; [https://doi.org/10.1002/ppj2.20005](https://doi.org/10.1002/ppj2.20005)

<br />

### Author

> Popat Pawar
* [GitHub](https://github.com/pspawar71)
* [LinkedIn](https://www.linkedin.com/in/dr-popat-pawar-204bb136/)
* E-mail: pspawar71@gmail.com
  
> Filipe Matias
* [GitHub](https://github.com/filipematias23)
* [LinkedIn](https://www.linkedin.com/in/filipe-matias-27bab5199/)
* E-mail: filipematias23@gmail.com

<br />

### Acknowledgments

> * [OpenDroneMap](https://www.opendronemap.org/)
> * [Phenome-Force Channel](https://youtube.com/@phenomeforce6569)
> * [r-spatial community](https://github.com/r-spatial)

<br />

[Menu](#menu)

<br />




