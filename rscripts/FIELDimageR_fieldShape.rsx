##FIELDimageR=group
##num_rows=string 10
##num_cols=string 10
##input_for_grid=selection point_shapefile_layer;four_corner_point_coordinates 1
##point_shapefile_layer=optional vector
##first_point_at_left_superior_corner=optional point 
##second_point_at_right_superior_corner=optional point
##third_point_at_right_inferior_corner=optional point 
##fourth_point_at_left_inferior_corner=optional point 
##mosaic_layer=optional raster
##buffer=optional number
##x_plot_size=optional number 
##y_plot_size=optional number 
##fieldData=optional file
##fieldMap=optional file
##PlotID=optional Field fieldData
##output_shapefile=output vector




# Get input parameters from QGIS
library(sf)
library(terra)
library(dplyr)
library(lwgeom)

# Get input parameters from QGIS
num_rows <- as.numeric(num_rows)
num_cols <- as.numeric(num_cols)

if(input_for_grid==0){
points_layer<-st_as_sf(point_shapefile_layer)
}else if(input_for_grid==1){
points_layer <- c(first_point_at_left_superior_corner,second_point_at_right_superior_corner,third_point_at_right_inferior_corner,fourth_point_at_left_inferior_corner)
df <- data.frame(id = c(1, 2, 3, 4))
points_layer<-st_sf(df,geometry=points_layer)
}else{
print("Please select the input for grid generation")
}
print(points_layer)

# Load the raster layer
if(!is.null(mosaic_layer)){
  mosaic <- rast(mosaic_layer)
  points_layer<-st_transform(points_layer, st_crs(mosaic))
}
print(buffer)
# Set the number of rows and columns for the grid
if (length(points_layer$geometry) == 4) {
  
  grid <- st_make_grid(points_layer, n = c(num_cols, num_rows))
  
  point_shp <- st_cast(st_make_grid(points_layer, n = c(1, 1)), "POINT")
  
  if(!is.null(mosaic_layer)){
    sourcexy <- rev(point_shp[1:4])%>% st_transform(st_crs(mosaic)) 
    Targetxy <- points_layer%>% st_transform(st_crs(mosaic))
  }
   
  if(is.null(mosaic_layer)){
    sourcexy <- rev(point_shp[1:4])%>% st_transform(st_crs(points_layer)) 
    Targetxy <- points_layer%>% st_transform(st_crs(points_layer)) 
  }
  
  controlpoints <- as.data.frame(cbind(st_coordinates(sourcexy), st_coordinates(Targetxy)))
  
  linMod <- lm(formula = cbind(controlpoints[, 3], controlpoints[, 4]) ~ controlpoints[, 1] + controlpoints[, 2], data = controlpoints)
  
  parameters <- matrix(linMod$coefficients[2:3, ], ncol = 2)
  print(parameters)
  intercept <- matrix(linMod$coefficients[1, ], ncol = 2)
  print(intercept)
  geometry <- grid * parameters + intercept
  print(parameters)
  print(intercept)
  if(!is.null(mosaic_layer)){
    grid_shapefile <- st_sf(geometry, crs = st_crs(mosaic)) %>% mutate(ID = seq(1, length(geometry)))
  }
  if(is.null(mosaic_layer)){
    grid_shapefile <- st_sf(geometry,crs = st_crs(points_layer)) %>% mutate(ID = seq(1, length(geometry)))
  }
  print(grid_shapefile)
  rect_around_point <- function(x, xsize, ysize) {
    bbox <- st_bbox(x)
    bbox <- bbox + c(xsize / 2, ysize / 2, -xsize / 2, -ysize / 2)
    return(st_as_sfc(st_bbox(bbox)))
  }
  
  if (!is.null(x_plot_size) && !is.null(y_plot_size)) {
  if (st_is_longlat(grid_shapefile)) {
      grid_shapefile <- st_transform(grid_shapefile, crs = 3857)
      cen <- suppressWarnings(st_centroid(grid_shapefile))
      bbox_list <- lapply(st_geometry(cen), st_bbox)
      points_list <- lapply(bbox_list, st_as_sfc)
    
      rectangles <- lapply(points_list, function(pt) rect_around_point(pt, x_plot_size, y_plot_size))
    
      points <- rectangles[[1]]
      for (i in 2:length(rectangles)) {
      points <- c(points, rectangles[[i]])
      }
      st_crs(points) <- st_crs(cen)
      grid <- st_as_sf(points)
      grid<-st_transform(grid, st_crs('EPSG:4326'))
      b<-st_transform(grid_shapefile, crs = 4326)
      rot = function(x) matrix(c(cos(x), sin(x), -sin(x), cos(x)), 2, 2)
      extcoords1 <- st_coordinates(st_geometry(b))
      pair<-st_sfc(st_point(c(extcoords1[,1][1],extcoords1[,2][1])), st_point(c(extcoords1[,1][4],extcoords1[,2][4])), crs = 4326)
      rotRad<-as.numeric(st_geod_azimuth(pair))
      ga = st_geometry(grid)
      cga = st_centroid(ga)
      grid_shapefile = (ga-cga) * rot(rotRad)+cga
      if(!is.null(mosaic_layer)){
      st_crs(grid_shapefile) <- st_crs(mosaic)
      grid_shapefile<-st_as_sf(grid_shapefile)
      }
      if(is.null(mosaic_layer)){
      st_crs(grid_shapefile) <- st_crs(points_layer)
      grid_shapefile<-st_as_sf(grid_shapefile)
    }
    print(grid_shapefile)  
    }else
     {
      cen <- suppressWarnings(st_centroid(grid_shapefile))
    
      bbox_list <- lapply(st_geometry(cen), st_bbox)
      points_list <- lapply(bbox_list, st_as_sfc)
    
      rectangles <- lapply(points_list, function(pt) rect_around_point(pt, x_plot_size, y_plot_size))
    
      points <- rectangles[[1]]
      for (i in 2:length(rectangles)) {
        points <- c(points, rectangles[[i]])
      }
      st_crs(points) <- st_crs(cen)
      grid <- st_as_sf(points)
      if(!is.null(mosaic_layer)){
      st_crs(grid) <- st_crs(mosaic)
      }
      if(is.null(mosaic_layer)){
      st_crs(grid) <- st_crs(points_layer)
      }
      b<-st_transform(grid_shapefile, crs = 4326)
      rot = function(x) matrix(c(cos(x), sin(x), -sin(x), cos(x)), 2, 2)
      extcoords1 <- st_coordinates(st_geometry(b))
      pair<-st_sfc(st_point(c(extcoords1[,1][1],extcoords1[,2][1])), st_point(c(extcoords1[,1][4],extcoords1[,2][4])), crs = 4326)
      rotRad<-as.numeric(st_geod_azimuth(pair))
      ga = st_geometry(grid)
      cga = st_centroid(ga)
      grid_shapefile = (ga-cga) * rot(rotRad)+cga
      if(!is.null(mosaic_layer)){
      st_crs(grid_shapefile) <- st_crs(mosaic)
      grid_shapefile<-st_as_sf(grid_shapefile)
      }
      if(is.null(mosaic_layer)){
      st_crs(grid_shapefile) <- st_crs(points_layer)
      grid_shapefile<-st_as_sf(grid_shapefile)
     }
      print(grid_shapefile)  
}
}
  
  if (!is.null(buffer)) {
    if (st_is_longlat(grid_shapefile)) {
      grid_shapefile <- st_transform(grid_shapefile, 
                                     crs = 3857)
      grid_shapefile <- st_buffer(grid_shapefile, dist = buffer)
      if(!is.null(mosaic_layer)){
      grid_shapefile <- st_transform(grid_shapefile,st_crs(mosaic))
      }
    } else {
      grid_shapefile <- st_buffer(grid_shapefile, dist = buffer)
      if(!is.null(mosaic_layer)){
      grid_shapefile <- st_transform(grid_shapefile, 
                                     st_crs(mosaic))
      }
    }
  }
  
  if (file.exists(fieldMap)) {
    
    fieldMap<-read.csv(fieldMap,header = FALSE)
    
    id <- NULL
    for (i in dim(fieldMap)[1]:1) {
      id <- c(id, fieldMap[i, ])
    }
    grid_shapefile$PlotID <- as.character(id)
  }
  if (file.exists(fieldData)) {
    
    fieldData<-read.csv(fieldData,header = TRUE)
    
    if (is.null(fieldMap)) {
      cat("\033[31m", "Error: fieldMap is necessary", 
          "\033[0m", "\n")
    }
    fieldData <- as.data.frame(fieldData)
    fieldData$PlotID <- as.character(fieldData[, colnames(fieldData) %in% 
                                                 c(PlotID)])
    grid_shapefile <- merge(grid_shapefile, fieldData, by = "PlotID")
  }
} 
# Write the grid shapefile to disk
output_shapefile= grid_shapefile
