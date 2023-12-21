##FIELDimageR=group
##grid_shapefile_layer=vector 
##mosaic_RemSoil=raster
##watershed_tolerance=optional number
##output_count_raster=output raster
##output_plotlevel_count=output vector
##output_objectlevel_count=output vector

library(EBImage)

library(terra)
library(sf)
library(dplyr)
print(watershed_tolerance)
print(grid_shapefile_layer)
mosaic<-rast(mosaic_RemSoil)
mosaic<-mosaic[[1]]

  # Define variables
  all_attri <- NULL
  rast_obj <- NULL
  if(!is.null(watershed_tolerance) && !is.null(grid_shapefile_layer)){
    fieldShape<-st_as_sf(grid_shapefile_layer)
    binay<-terra::ifel(mosaic,NA,1)
    img<-terra::as.array(t(as.matrix(binay, wide=TRUE)))
    img[is.na(img)] <- 0
    dis<-EBImage::distmap(img)
    seg<-EBImage::watershed(dis,watershed_tolerance)
    ebi<-terra::as.array(seg)
    rast_obj <- terra::rast(t(as.matrix(rast(ebi), wide=TRUE)))
    rast_obj[rast_obj== 0] <- NA
    crs(rast_obj)<-crs(mosaic)
    ext(rast_obj)<-ext(mosaic)
    poly <- as.polygons(rast_obj)
    perimeter<-perim(poly)
    area<-expanse(poly)
    width<-width(poly)
    attri<-st_as_sf(poly)
    xy<-terra::crds(vect(st_centroid(attri)))   
    attributes<-cbind(attri[,-1],area,perimeter,width,xy)
    print(attributes)
    att<-cbind(ID = 1:nrow(attri[,-1]),attri[,-1],area,perimeter,width,xy)
    print(att)
    c<-st_join(fieldShape, st_as_sf(attributes))
     print(c)
    all<- c%>% group_by(ID) %>% 
      summarize(count=n(),
              area_total =round(sum(area),3),
              area_mean =round(mean(area),3),
              area_var =round(var(area),3),
              area_sd =round(sd(area),3),
              perimeter_total =round(sum(perimeter),3),
              perimeter_mean =round(mean(perimeter),3),
              perimeter_var =round(var(perimeter),3),
              perimeter_sd =round(sd(perimeter),3),
              width_mean =round(mean(width),3),
              width_var =round(var(width),3),
              width_sd =round(sd(width),3))
    print(all)
    all_attri<-list(plot_level=all,
                    object_level=att)
    print(all_attri)
  }else if(is.null(watershed_tolerance) && !is.null(grid_shapefile_layer)){
    fieldShape<-st_as_sf(grid_shapefile_layer)    
    logi<-terra::ifel(mosaic,NA,1)
    rast_obj<- patches(logi, directions = 4)
    poly <- as.polygons(rast_obj)
    poly$ID <- seq.int(nrow(poly))
    perimeter<-perim(poly)
    area<-expanse(poly)
    width<-width(poly)
    attri<-st_as_sf(poly)
    attributes<-cbind(attri[,-1],area,perimeter,width)
    c<-st_join(fieldShape, st_as_sf(attributes))
    print(c)
    all<- c%>% group_by(ID.x) %>% 
      summarize(count=n(),
              area_total =round(sum(area),3),
              area_mean =round(mean(area),3),
              area_var =round(var(area),3),
              area_sd =round(sd(area),3),
              perimeter_total =round(sum(perimeter),3),
              perimeter_mean =round(mean(perimeter),3),
              perimeter_var =round(var(perimeter),3),
              perimeter_sd =round(sd(perimeter),3),
              width_mean =round(mean(width),3),
              width_var =round(var(width),3),
              width_sd =round(sd(width),3))
    print(all)
    all_attri<-list(plot_level=all,
                    object_level=attributes)
    print(all_attri)
  }
plot_level<-st_as_sf(all_attri[['plot_level']])
print(plot_level)
object_level<-st_as_sf(all_attri[['object_level']])
print(object_level)
output_count_raster <- rast_obj
output_plotlevel_count<-plot_level
output_objectlevel_count<-object_level
