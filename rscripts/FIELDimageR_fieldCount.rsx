##FIELDimageR=group
##mask_layer=raster
##grid_shapefile_layer=vector 
##output_patches=output raster
##output_count_plot=output vector polygon
##output_count_object=output vector polygon

library(imager)
library(terra)
library(sf)
library(dplyr)
img<-rast(mask_layer)
all_attri <- NULL
rast_obj <- NULL
rast_obj <- patches(img, directions = 4)
poly <- as.polygons(rast_obj)
poly$ID <- seq.int(nrow(poly))
perimeter <- perim(poly)
area <- expanse(poly)
width <- width(poly)
attri <- st_as_sf(poly)
attributes <- cbind(attri[,-1], area, perimeter, width)
all_attri <- st_as_sf(attributes)
output_count_object <- all_attri
output_patches <- rast_obj
fieldShape<-st_as_sf(grid_shapefile_layer)
  all_attri <- NULL
  rast_obj <- NULL
  rast_obj <- patches(img, directions = 4)
  poly <- as.polygons(rast_obj)
  perimeter<-perim(poly)
  area<-expanse(poly)
  width<-width(poly)
  attri<-st_as_sf(poly)
  attributes<-cbind(attri[,-1],area,perimeter,width)
  c<-st_join(fieldShape, st_as_sf(attributes))
  all_attri<- c%>% group_by(ID) %>% 
    summarize(area =round(sum(area),3),
              perimeter=round(sum(perimeter),3),count=n(),mean_width=round(mean(width),3))
output_count_plot <- all_attri
