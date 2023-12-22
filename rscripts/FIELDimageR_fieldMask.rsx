##FIELDimageR=group
##mosaic_layer=raster
##index_layer=raster
##mask_layer_name=string HUE
##mask_crop_values=number 0
##crop_above=boolean TRUE
##output_mask=output raster
##output_mosaic=output raster

# Get input parameters from QGIS
library(terra)

# Load the raster layer
mosaic <- rast(mosaic_layer)
index<-rast(index_layer)
indice<-mask_layer_name
print(indice)
nBand <- nlyr(index)
if(nBand==1){
  names(index[[1]])<-as.character(indice)
}
if (any(!indice%in%names(index))) {
  stop("Selected indices are not available in FIELDimageR")
}
if(crop_above){
mask <- ifel(index[[indice]]> mask_crop_values,NA,1)
}
if(!crop_above){
mask <- ifel(index[[indice]]> mask_crop_values,1,NA)
}
names(mask)<-'mask'
mosaic<- terra::mask(mosaic,mask)
# Write the raster to disk
output_mask <- mask
output_mosaic<-mosaic
