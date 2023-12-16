##FIELDimageR=group
##mosaic_layer=raster
##clusters=number 2
##iteration=number 500
##algorithm=selection Lloyd;Hartigan-Wong;Forgy;MacQueen Lloyd
##seed=number 25
##output_kmean=output raster

# Get input parameters from QGIS
library(terra)
library(dplyr)

mosaic<-rast(mosaic_layer)
if(algorithm==0){
  algorithm='Lloyd'
}else if(algorithm==1){
  algorithm='Hartigan-Wong'
}else if(algorithm==2){
  algorithm='Forgy'
}else{
  algorithm='MacQueen'
}
print(algorithm)
if (nlyr(mosaic) > 2) {
  mosaic<-na.omit(mosaic)
  ortho <- as.data.frame(mosaic[[1]], cell = TRUE)
  set.seed(seed)
  kmncluster <- kmeans(ortho[, -1],
                       centers = clusters,
                       iter.max = iteration,
                       nstart = 5,
                       algorithm = algorithm)
  kmean_cluster <- rast(mosaic, nlyr = 1)
  kmean_cluster[ortho$cell] <- kmncluster$cluster[ortho$cell]
} else if (nlyr(mosaic) == 1) {
  mosaic<-na.omit(mosaic)
  ortho <- as.data.frame(mosaic, cell = TRUE)
  set.seed(seed)
  kmncluster <- kmeans(ortho[, -1],
                       centers = clusters,
                       iter.max = iteration,
                       nstart = 5,
                       algorithm = algorithm)
  kmean_cluster <- rast(mosaic, nlyr = 1)
  kmean_cluster[ortho$cell] <- kmncluster$cluster[ortho$cell]
}

output_kmean=kmean_cluster