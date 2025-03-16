##FIELDimageR=group
##Load_rasters=multiple raster
##Output_raster=output raster

library(terra)

# Stack the rasters
rasters <- lapply(Load_rasters, rast)

Output_raster <- do.call(c, rasters)
  
