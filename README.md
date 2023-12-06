## [FIELDimageR-QGIS](https://github.com/OpenDroneMap/FIELDimageR): A Tool to Analyze Images From Agricultural Field Trials in [QGIS](https://qgis.org/en/site/).

> This package is a compilation of functions made on [R](https://www.r-project.org/) by [Popat Pawar](https://www.linkedin.com/in/dr-popat-pawar-204bb136/) and [Filipe Matias](https://www.linkedin.com/in/filipe-matias-27bab5199/) to analyze orthomosaic images from research fields. To prepare the image it first allows to crop the image, remove soil and weeds and rotate the image. The package also builds a plot shapefile in order to extract information for each plot to evaluate different wavelengths, vegetation indices, stand count, canopy percentage, and plant height.

<p align="center">
  <img src="https://raw.githubusercontent.com/filipematias23/images/master/readme/qgis_logo.jpg" width="70%" height="70%">
</p>

<div id="menu" />

---------------------------------------------
## Resources
  
[Installation](#instal)

[1. First steps](#p1)

[Contact](#p21)

<div id="instal" />

---------------------------------------------
### Installation

Start the pipeline by installing the software:

1. [R](https://www.r-project.org/) 
2. [QGIS](https://qgis.org/en/site/).

<br />

The nest step is opening the **Processing Toolbox** visualization in **QGIS** following the steps:

* (1) View 
* (2) Panels 
* (3) Processing Toolbox 
* (4) Check if the rocessing Toolbox is showing in the right

<p align="center">
  <img src="https://raw.githubusercontent.com/filipematias23/images/master/readme/qgis_1.jpg">
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
  <img src="https://raw.githubusercontent.com/filipematias23/images/master/readme/qgis_2.jpg">
</p>

<br />


[Menu](#menu)

<div id="p1" />
