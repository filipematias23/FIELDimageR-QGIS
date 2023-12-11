##FIELDimageR=group
##DSM_bef=raster
##DSM_aft=raster
##output_CHM=output raster
##output_CVM=output raster

# Get input parameters from QGIS
library(terra)
library(dplyr)
dsm_before <- rast(DSM_bef)
dsm_after<-rast(DSM_aft)
 if (!inherits(dsm_before,"SpatRaster") || !nlyr(dsm_before) == 1 || terra::is.bool(dsm_before) || is.list(dsm_before)) {
    stop("Error: Invalid 'dsm_before' raster object.")
  }
  if (!inherits(dsm_after,"SpatRaster") || !nlyr(dsm_after) == 1 || terra::is.bool(dsm_after) || is.list(dsm_after)) {
    stop("Error: Invalid 'dsm_after' raster object.")
  }
  dsm.c <- resample(dsm_before, dsm_after)
  height <- dsm_after-dsm.c
  names(height)<-"height"
  volume<-terra::cellSize(height)*height
  names(volume)<-"volume"
# Write the raster to disk
output_CHM<- height
output_CVM<-volume