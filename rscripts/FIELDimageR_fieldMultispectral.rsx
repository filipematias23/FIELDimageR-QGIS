##FIELDimageR=group
##mosaic_Red=raster
##mosaic_Green=raster
##mosaic_Blue=optional raster
##mosaic_RedEdge=optional raster
##mosaic_NIR=raster
##layer_names=string Red,Green,Blue,RE,NIR
##Multispectral=output raster

# Get input parameters from QGIS
library(terra)
library(dplyr)

# Load the raster layer
Red<-rast(mosaic_Red)
Green<-rast(mosaic_Green)
mosaic <- append(Red, Green)

if(!is.null(mosaic_Blue)){
  Blue<-rast(mosaic_Blue)
  mosaic <- append(mosaic, Blue)
}
if(!is.null(mosaic_RedEdge)){
  RedEdge<-rast(mosaic_RedEdge)
  mosaic <- append(mosaic, RedEdge)
}
NIR<-rast(mosaic_NIR)
mosaic <- append(mosaic, NIR)

names(mosaic)<-as.character(do.call(c,strsplit(layer_names,",")))


# Write the raster to disk
Multispectral <- mosaic

#END