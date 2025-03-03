##FIELDimageR=group
##mosaic_remSoil_layer=raster
##grid_shapefile_layer=vector polygon
##field=optional Field grid_shapefile_layer Plot
##output_fieldArea=output vector

# Get input parameters from QGIS

library(terra)
library(dplyr)
library(exactextractr)
mosaic <- rast(mosaic_remSoil_layer)
fieldShape<-st_as_sf(grid_shapefile_layer)
fieldShape <- fieldShape %>% dplyr::select(-fid)
 

field <- field

print(field)
if (is.null(field)) {

  terra_vect <- vect(grid_shapefile_layer)

  terra_rast <- rasterize(terra_vect, mosaic, field = "PlotID")

  total_pixelcount <- exactextractr::exact_extract(terra_rast, fieldShape, fun = "count",force_df = TRUE)

  area_pixel <- exactextractr::exact_extract(mosaic[[1]], fieldShape, fun = "count",force_df = TRUE)

} else {

  terra_vect <- vect(grid_shapefile_layer)

  terra_rast <- rasterize(terra_vect, mosaic, field = field)

  total_pixelcount <- exactextractr::exact_extract(terra_rast, fieldShape, fun = "count",force_df = TRUE)

  area_pixel <- exactextractr::exact_extract(mosaic[[1]], fieldShape, fun = "count",force_df = TRUE)

}

area_percentage <- round(area_pixel/ total_pixelcount * 100,3)
names(area_percentage)<-"AreaPercentage"
names(area_pixel)<-"PixelCount"
area_percentage <- cbind(fieldShape, AreaPixel=area_pixel, area_percentage)
# Write the raster to disk
output_fieldArea<- area_percentage
