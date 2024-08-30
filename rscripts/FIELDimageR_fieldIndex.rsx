##FIELDimageR=group
##mosaic_layer=raster
##bands=string Red,Green,Blue
##index=string HUE,BI,GLI,NGRDI
##My_index=optional string (Red-Blue)/Green,Red/Green
##output_index=output raster

# Get input parameters from QGIS
library(terra)
library(dplyr)

# Load the raster layer
mosaic <- rast(mosaic_layer)
num.band <- nlyr(mosaic)
print(bands)
bands <- strsplit(bands, ",")[[1]]
if(length(bands)<num.band){bands<-c(bands,paste("Extra_",seq(1:(num.band-length(bands))),sep=""))}
names(mosaic) <- bands

# Extract individual bands
if(any(names(mosaic)=="Blue")){
  mosaic[["Blue"]] <- mosaic[["Blue"]]
}
if(any(names(mosaic)=="Red")){
   mosaic[["Red"]] <- mosaic[["Red"]]
}
if(any(names(mosaic)=="Green")){
  mosaic[["Green"]] <- mosaic[['Green']]
}
if(any(names(mosaic)=="RE")){
  mosaic[["RE"]] <- mosaic[["RE"]]
}
if(any(names(mosaic)=="NIR")){
  mosaic[["NIR"]]<- mosaic[["NIR"]]
}
if (num.band < 3) {
  stop("At least 3 bands (RGB) are necessary to calculate indices")
}

# Define the indices directly in the script
Ind <- data.frame(
  index = c("BI", "BIM", "SCI", "GLI", "HI", "NGRDI", "SI", "VARI", "HUE", "BGI", 
            "PSRI", "NDVI", "GNDVI", "RVI", "NDRE", "TVI", "CVI", "CIG", "CIRE", "DVI", "EVI"),
  eq = c("sqrt((Red^2+Green^2+Blue^2)/3)", "sqrt((Red*2+Green*2+Blue*2)/3)", "(Red-Green)/(Red+Green)", "(2*Green-Red-Blue)/(2*Green+Red+Blue)", 
         "(2*Red-Green-Blue)/(Green-Blue)", "(Green-Red)/(Green+Red)", "(Red-Blue)/(Red+Blue)", "(Green-Red)/(Green+Red-Blue)", "atan(2*(Blue-Green-Red)/30.5*(Green-Red))", "Blue/Green", 
         "(Red-Green)/(RE)", "(NIR-Red)/(NIR+Red)", "(NIR-Green)/(NIR+Green)", "NIR/Red", "(NIR-RE)/(NIR+RE)", 
         "(0.5*(120*(NIR-Green)-200*(Red-Green)))", "(NIR*Red)/(Green^2)", "(NIR/Green)-1", "(NIR/RE)-1", "NIR-RE", 
         "2.5*(NIR-Red)/(NIR+6*Red-7.5*Blue+1)"),
  band = c("C", "C", "C", "C", "C", "C", "C", "C", "C", "C", "RE", "NIR", "NIR", "NIR", "NIR", "NIR", 
           "NIR", "NIR", "NIR", "NIR", "NIR")
)

# Add the defined indices to the index dropdown
IRGB<- as.character(Ind$index)

index <- strsplit(gsub("\\s", "", index), ",")[[1]]
selected_indices <- index
available_indices <- IRGB

print("Available Indices:")
print(available_indices)
print("Selected Indices:")
print(selected_indices)

if (any(!selected_indices %in% available_indices)) {
  stop("Selected indices are not available in FIELDimageR")
}
# Check if NIR or RE is required for calculation
NIR.RE <- as.character(Ind$index[Ind$band %in% c("RE", "NIR")])
if (any(NIR.RE %in% index) && all(bands %in% 'NIR')) {
  stop(paste("Index: ", NIR.RE[NIR.RE %in% index], " needs NIR/RE band to be calculated", sep = ""))
}
# Calculate selected indices
new_layers <- list()

for (i in 1:length(selected_indices)) {
  fun <- function(Red,Green,Blue,RE,NIR){eval(parse(text = as.character(Ind$eq[Ind$index == selected_indices[i]])))}
  new_layer<-lapp(mosaic,fun,usenames=TRUE)
  new_layers[[as.character(selected_indices[i])]] <- new_layer
}

indices <- rast(new_layers)

My_index <- strsplit(gsub("\\s", "", My_index), ",")[[1]]
print(My_index)

my_layers <- list()
if (length(My_index) > 0) {
  for (i in 1:length(My_index)) {
    fun1 <- function(Red, Green,Blue,RE,NIR){eval(parse(text = as.character(My_index[i])))}
    my_layer <- lapp(mosaic,fun1,usenames=TRUE)
    my_layers[[My_index[i]]] <- my_layer
  }
  myindex <- rast(my_layers)
  names(myindex) <- paste0("Myindex_", 1:length(My_index))
  mosaic <- c(indices, myindex)
} else {
  mosaic <- indices
}


# Write the raster to disk
output_index <- mosaic
