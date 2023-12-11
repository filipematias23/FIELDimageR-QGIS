##FIELDimageR=group
##mosaic_remSoil_layer=raster
##grid_shapefile_layer=vector polygon
##field=optional Field grid_shapefile_layer Plot
##output_fieldArea=output vector

# Get input parameters from QGIS
library(terra)
library(dplyr)
mosaic <- rast(mosaic_remSoil_layer)
terra_vect <-vect(grid_shapefile_layer)
fieldShape<-st_as_sf(grid_shapefile_layer)
print(field)
 if (any(field %in% colnames(fieldShape))) {
    # Load the raster layer
    terra_rast <- rasterize(terra_vect, mosaic, field = field)
    total_pixelcount <- zonal(terra_rast, terra_rast, fun = "notNA", weighted = TRUE)
    area_pixel <- zonal(mosaic[[1]], terra_rast, fun = "notNA", weighted = TRUE)
    area_percentage <- round(area_pixel[2] / total_pixelcount[2] * 100,3)
    names(area_percentage)<-"AreaPercentage"
  } else {
    terra_rast <- rasterize(terra_vect, mosaic, field = "ID")
    total_pixelcount <- zonal(terra_rast, terra_rast, fun = "notNA", weighted = TRUE)
    area_pixel <- zonal(mosaic[[1]], terra_rast, fun = "notNA", weighted = TRUE)
    area_percentage <- round(area_pixel[2] / total_pixelcount[2] * 100,3)
    names(area_percentage)<-"AreaPercentage"
  }
area_percentage<-cbind(fieldShape,AreaPixel=area_pixel[,2],area_percentage)
# Write the raster to disk
output_fieldArea<- area_percentage