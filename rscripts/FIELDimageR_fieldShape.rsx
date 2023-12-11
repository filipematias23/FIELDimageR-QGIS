##FIELDimageR=group
##num_rows=number 10
##num_cols=number 10
##points_layer=vector point 
##mosaic_layer=raster
##buffer=optional number
##x_plot_size=optional number 
##y_plot_size=optional number 
##fieldData=optional file
##fieldMap=optional file
##PlotID=optional Field fieldData
##output_shapefile=output vector

# Get input parameters from QGIS
num_rows <- as.numeric(num_rows)
num_cols <- as.numeric(num_cols)

library(sf)
library(terra)
library(dplyr)

# Convert points_layer to sf format
points_layer <- st_as_sf(points_layer)

# Load the raster layer
mosaic <- rast(mosaic_layer)

# Set the number of rows and columns for the grid
if (length(points_layer$geometry) == 4) {
  
  grid <- st_make_grid(points_layer, n = c(num_cols, num_rows))
  
  point_shp <- st_cast(st_make_grid(points_layer, n = c(1, 1)), "POINT")
  
  sourcexy <- rev(point_shp[1:4]) %>% st_transform(st_crs(mosaic))
  Targetxy <- points_layer %>% st_transform(st_crs(mosaic))
  
  controlpoints <- as.data.frame(cbind(st_coordinates(sourcexy), st_coordinates(Targetxy)))
  
  linMod <- lm(formula = cbind(controlpoints[, 3], controlpoints[, 4]) ~ controlpoints[, 1] + controlpoints[, 2], data = controlpoints)
  
  parameters <- matrix(linMod$coefficients[2:3, ], ncol = 2)
  intercept <- matrix(linMod$coefficients[1, ], ncol = 2)
  
  geometry <- grid * parameters + intercept
  
  grid_shapefile <- st_sf(geometry, crs = st_crs(mosaic)) %>% mutate(ID = seq(1, length(geometry)))
  
  rect_around_point <- function(x, xsize, ysize) {
    bbox <- st_bbox(x)
    bbox <- bbox + c(xsize / 2, ysize / 2, -xsize / 2, -ysize / 2)
    return(st_as_sfc(st_bbox(bbox)))
  }
  
  if (!is.null(x_plot_size) && !is.null(y_plot_size)) {
    if (st_is_longlat(grid_shapefile)) {
      grid_shapefile <- st_transform(grid_shapefile, crs = 3857)
    }
    
    cen <- suppressWarnings(st_centroid(grid_shapefile))
    
    bbox_list <- lapply(st_geometry(cen), st_bbox)
    points_list <- lapply(bbox_list, st_as_sfc)
    
    rectangles <- lapply(points_list, function(pt) rect_around_point(pt, x_plot_size, y_plot_size))
    
    points <- rectangles[[1]]
    for (i in 2:length(rectangles)) {
      points <- c(points, rectangles[[i]])
    }
    
    st_crs(points) <- st_crs(cen)
    grid_shapefile <- st_as_sf(points)
    grid_shapefile <- st_transform(grid_shapefile, st_crs(mosaic))
  }
  
  if (!is.null(buffer)) {
      if (st_is_longlat(grid_shapefile)) {
        grid_shapefile <- st_transform(grid_shapefile, 
                                       crs = 3857)
        grid_shapefile <- st_buffer(grid_shapefile, dist = buffer)
        grid_shapefile <- st_transform(grid_shapefile, 
                                       st_crs(mosaic))
      } else {
        grid_shapefile <- st_buffer(grid_shapefile, dist = buffer)
        grid_shapefile <- st_transform(grid_shapefile, 
                                       st_crs(mosaic))
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
