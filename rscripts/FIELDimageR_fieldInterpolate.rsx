##FIELDimageR=group
##mosaic_layer=raster
##points_shapefile=vector
##output_interpolate=output raster

# Get input parameters from QGIS
library(terra)
library(dplyr)
library(fields) 

# Load the raster layer
mosaic <- rast(mosaic_layer)

# Load the shapefile layer
fieldShape <- st_as_sf(points_shapefile)
fieldShape <- st_transform(fieldShape,st_crs(mosaic))

#Interpolate
extra<-extract(mosaic,fieldShape, xy=TRUE)
xy<-extra[,c(3,4)]
v<-as.numeric(extra[,2])
tps <- Tps(xy, v)
p <- rast(mosaic)
p <- interpolate(p, tps)
p <- mask(p, mosaic)

# Write the raster to disk
output_interpolate <- p
