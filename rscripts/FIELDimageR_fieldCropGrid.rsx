##FIELDimageR=group
##mosaic_layer=raster
##grid_shapefile_layer=vector
##plotID=optional Field grid_shapefile_layer
##classifier=optional Field grid_shapefile_layer
##format=optional string .jpg
##output_dir=folder 


# Get input parameters from QGIS
library(terra)
library(dplyr)
library(sf)
library(jpeg)

# Load the raster layer
mosaic <- rast(mosaic_layer)

print(plotID)
print(output_dir)
# Load the shaoefile layer
fieldShape <- st_as_sf(grid_shapefile_layer)
fieldShape <- st_transform(fieldShape,st_crs(mosaic))

format = as.character(format) 

  print("Cropping plots ...")
  crop_list <- list()
  stars_object <- mosaic

nBand <- nlyr(mosaic)

 for (i in 1:nrow(fieldShape)) {
    grid_polygon <- fieldShape[i, ]
    if (any(plotID %in% colnames(grid_shapefile_layer)) && any(classifier%in% colnames(grid_shapefile_layer))) {
      plot_name <- grid_polygon[[plotID]]
      classifier_name <- grid_polygon[[classifier]]
      if (!(nchar(trimws(plot_name)) == 0) && !nchar(trimws(classifier_name)) == 0) {
        file_name <- paste0(plot_name, format)
      }
      else if (!(nchar(trimws(plot_name)) == 0)) {
        file_name <- paste0(plot_name, format)
      }
      else {
        file_name <- paste0("ID_", i, format)
      }
      classifier_dir <- file.path(output_dir, classifier_name)
      dir.create(classifier_dir, showWarnings = FALSE)
      file_path <- file.path(classifier_dir, file_name)
    }
    else if (nchar(trimws(plotID)) == 0 && nchar(trimws(classifier)) == 0 && nchar(trimws(format)) == 0) {
      file_name <- paste0("ID_", i, ".tif")
      file_path <- file.path(output_dir, file_name)
    }
    else {
      file_name <- paste0("ID_", i, format)
      file_path <- file.path(output_dir, file_name)
    }
    if (nchar(trimws(format)) == 0 && nchar(trimws(plotID)) == 0 && nchar(trimws(classifier)) == 0) {
      grid_polygon <- st_transform(grid_polygon, crs = st_crs(stars_object))
      plot_raster <-terra::crop(stars_object, grid_polygon,mask=TRUE)
      terra::writeRaster(plot_raster, file_path)
    }
    else if (format == ".jpg") {
      grid_polygon <- st_transform(grid_polygon, crs = st_crs(stars_object))
      plot_raster <- terra::crop(stars_object, grid_polygon,mask=TRUE)
      if (nBand > 2) {
        if (as.numeric(minmax(plot_raster[[1]])[[2]] > 
                       1)) {
          red <- plot_raster[[1]]/255
          green <- plot_raster[[2]]/255
          blue <- plot_raster[[3]]/255
          plot_raster <- c(red, green, blue)
        }
        else {
          red <- plot_raster[[1]]
          green <- plot_raster[[2]]
          blue <- plot_raster[[3]]
          plot_raster <- c(red, green, blue)
        }
        if (nBand == 1) {
          if (as.numeric(minmax(plot_raster)[[2]] > 1)) {
            band_1 <- plot_raster[[1]]/255
          }
          plot_raster <- band_1
        }
        plot_raster_j <- raster::as.array(plot_raster)
        jpeg::writeJPEG(plot_raster_j, target = file_path)
      }
    }
    else {
      grid_polygon <- st_transform(grid_polygon, crs = st_crs(stars_object))
      plot_raster <- terra::crop(stars_object, grid_polygon,mask=TRUE)
      terra::writeRaster(plot_raster, file_path)
    }
    
  }

  print("End!")
