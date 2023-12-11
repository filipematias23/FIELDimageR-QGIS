##FIELDimageR=group
##mosaic_layer=raster
##bands=string Red,Green,Blue
##index=string HUE,BI,GLI,NGRDI
##output_index=output raster

# Get input parameters from QGIS
library(terra)
library(dplyr)

# Load the raster layer
mosaic <- rast(mosaic_layer)
num.band <- nlyr(mosaic)
bands <- strsplit(bands, ",")[[1]]
names(mosaic) <- bands

# Extract individual bands
if(num.band ==3){
B <- mosaic['Blue']
G <- mosaic['Green']
R <- mosaic['Red']
}else if(num.band ==4){
B <- mosaic['Blue']
G <- mosaic['Green']
R <- mosaic['Red']
RE<-mosaic['RE']
}else{
B <- mosaic['Blue']
G <- mosaic['Green']
R <- mosaic['Red']
RE<-mosaic['RE']
NIR1<-mosaic['NIR']
}
if (num.band < 3) {
  stop("At least 3 bands (RGB) are necessary to calculate indices")
}

# Define the indices directly in the script
Ind <- data.frame(
  index = c("BI", "BIM", "SCI", "GLI", "HI", "NGRDI", "SI", "VARI", "HUE", "BGI", 
            "PSRI", "NDVI", "GNDVI", "RVI", "NDRE", "TVI", "CVI", "CIG", "CIRE", "DVI", "EVI"),
  eq = c("sqrt((R^2+G^2+B^2)/3)", "sqrt((R*2+G*2+B*2)/3)", "(R-G)/(R+G)", "(2*G-R-B)/(2*G+R+B)", 
         "(2*R-G-B)/(G-B)", "(G-R)/(G+R)", "(R-B)/(R+B)", "(G-R)/(G+R-B)", "atan(2*(B-G-R)/30.5*(G-R))", "B/G", 
         "(R-G)/(RE)", "(NIR1-R)/(NIR1+R)", "(NIR1-G)/(NIR1+G)", "NIR1/R", "(NIR1-RE)/(NIR1+RE)", 
         "(0.5*(120*(NIR1-G)-200*(R-G)))", "(NIR1*R)/(G^2)", "(NIR1/G)-1", "(NIR1/RE)-1", "NIR1-RE", 
         "2.5*(NIR1-R)/(NIR1+6*R-7.5*B+1)"),
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
  new_layer <- eval(parse(text = as.character(Ind$eq[Ind$index == selected_indices[i]])))
  new_layers[[selected_indices[i]]] <- new_layer
}
mosaic<-rast(new_layers)
# Write the raster to disk
output_index <- mosaic