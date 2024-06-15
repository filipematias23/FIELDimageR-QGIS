##FIELDimageR=group
##grid_shapefile_layer=vector
##index_layer_1=raster
##index_layer_2=raster
##index_layer_3=optional raster
##index_layer_4=optional raster
##index_layer_5=optional raster
##DAP_sequence=string 10,20,30
##AUC_method=selection trapezoid;step;linear;spline trapezoid
##output_AUC=output vector

library(terra)
library(dplyr)
library(sf)
library(exactextractr)
library(DescTools)

# Veg.Indices:
mosaic1 <- rast(index_layer_1)
mosaic<-list(mosaic1,rast(index_layer_2))
if(!is.null(index_layer_3)){
  mosaic<-unlist(list(mosaic,rast(index_layer_3)))}
if(!is.null(index_layer_4)){
  mosaic<-unlist(list(mosaic,rast(index_layer_4)))}
if(!is.null(index_layer_5)){
  mosaic<-unlist(list(mosaic,rast(index_layer_5)))}

# DAP:
DAP<-as.character(do.call(c,strsplit(DAP_sequence,",")))
names(mosaic)<-DAP
print(DAP)

# Grid:
fieldShape <- st_as_sf(grid_shapefile_layer)
fieldShape <- st_transform(fieldShape,st_crs(mosaic1))

# Extract data:
plotInfo <- do.call(cbind,lapply(mosaic,function(x){as.data.frame(exact_extract(x, fieldShape, fun = 'mean'))}))
colnames(plotInfo)<-paste("Index",DAP,sep="_")

# Extracted Data:

if(AUC_method==0){
  fun="trapezoid"
}
if(AUC_method==1){
  fun="step"
}
if(AUC_method==2){
  fun="linear"
}
if(AUC_method==3){
  fun="spline"
}

print(fun)

AUC <- apply(plotInfo,1,function(x){
  AUC(x = as.numeric(DAP), 
      y = x,
      method = fun)
})

#OutPut:
output_AUC<-cbind(fieldShape,plotInfo,AUC)
output_AUC <- st_transform(output_AUC,st_crs(mosaic1))

#END
