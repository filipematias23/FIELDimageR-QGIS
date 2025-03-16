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
  index = c("BI", "BIM", "SCI", 
            "GLI", "HI", "NGRDI", 
            "SI", "VARI", "HUE", "BGI", 
            "PSRI", "NDVI", "GNDVI", 
            "RVI", "NDRE", "TVI", 
            "CVI", "CIG", "CIRE", "DVI", "EVI",
            "CI", "EGVI", "ERVI", 
            "GB", "GLAI", "GR", "MGVRI", "NB",
            "NG", "NGBDI", "NR", "RB", "RI", "S",
            "SAVI", "SHP", "GD", "VIG", "ARI", "VIRE",
            "TCARI", "ARVI", "BAI", "BWDRVI",
            "CCCI", "GARI", "GDVI", "GOSAVI", 
            "GRVI", "GSAVI", "IPVI", "MSR", 
            "NDWI", "NLI", "OSAVI", "PNDVI",
            "RDVI", "REDVI", "RESR",
            "TDVI", "VIN", "WDRVI", "WSI"),
  eq = c("sqrt((Red^2+Green^2+Blue^2)/3)", 
         "sqrt((Red*2+Green*2+Blue*2)/3)", 
         "(Red-Green)/(Red+Green)", 
         "(2*Green-Red-Blue)/(2*Green+Red+Blue)", 
         "(2*Red-Green-Blue)/(Green-Blue)", 
         "(Green-Red)/(Green+Red)", 
         "(Red-Blue)/(Red+Blue)", 
         "(Green-Red)/(Green+Red-Blue)", 
         "atan(2*(Blue-Green-Red)/30.5*(Green-Red))", 
         "Blue/Green", 
         "(Red-Green)/RE", 
         "(NIR-Red)/(NIR+Red)", 
         "(NIR-Green)/(NIR+Green)", 
         "NIR/Red", 
         "(NIR-RE)/(NIR+RE)", 
         "(0.5*(120*(NIR-Green)-200*(Red-Green)))", 
         "(NIR*Red)/(Green^2)", 
         "(NIR/Green)-1", 
         "(NIR/RE)-1", 
         "NIR-RE", 
         "2.5*(NIR-Red)/(NIR+6*Red-7.5*Blue+1)",
         "((Red - Blue) / Red)",
         "2*Green-Red-Blue",
         "((1.4*Red)- Green)",
         "Green / Blue",
         "(25 * (Green - Red) / (Green + Red - Blue) + 1.25)",
         "Green / Red",
         "(Green^2-Red^2)/(Green^2+Red^2)",
         "Blue / (Red + Green + Blue)",
         "Green / (Red + Green + Blue)",
         "(Green-Blue)/(Green+Blue)",
         "Red / (Red + Green + Blue)",
         "Red / Blue",
         "(Red^2 / (Blue * Green^3))",
         "((Red + Green + Blue) - 3 * Blue) / (Red + Green + Blue)",
         "(1 + 0.5)*(Green-Red)/(Green+Red+0.5)",
         "(2 * (Red - Green - Blue) / (Green - Blue))",
         "Green - (Red+Blue) / 2",
         "(Green-Red)/(Green+Red)",
         "(1 / Green) - (1 / RE)",
         "(RE-Red)/(RE+Red)",
         "3 * ((RE - Red) - 0.2 * (RE - Green) * (RE/Red))",
         "(NIR - (Red - 0.1*(Red-Blue))) / (NIR + (Red - 0.1*(Red-Blue)))",
         "1/((0.1 - Red)^2 + (0.06 - NIR)^2)",
         "(0.1*NIR-Blue)/(0.1*NIR+Blue)",
         "((NIR-Red)/(NIR+Red))/((NIR-Red)/(NIR+Red))",
         "(NIR - (1.7 * (Blue-Red))) / (NIR + (1.7 * (Blue-Red)))",
         "NIR-Green",
         "(NIR-Green)/(NIR+Green+0.16)",
         "NIR / Green",
         "((NIR-Green)/(NIR+Green+0.5))*(1+0.5)",
         "NIR / (NIR + Red)",
         "(NIR / Red - 1) / (sqrt(NIR / Red) + 1)",
         "(Green-NIR)/(Green+NIR)",
         "(NIR ^2 - Red) / (NIR ^2 + Red)",
         "(NIR-Red)/(NIR+Red+0.16)",
         "((NIR-(Green+Red+Blue))/(NIR+(Green+Red+Blue)))",
         "(NIR - Red) / (sqrt(NIR + Red))",
         "NIR-RE",
         "NIR/RE",
         "1.5 * ((NIR - Red) / (sqrt(NIR ^2 + Red + 0.5)))",
         "NIR/Red",
         "(0.2 * NIR - Red) / (0.2 * NIR + Red)",
         "5*(NIR - Red) / (NIR + Red) - (RE-NIR) / (RE+NIR)"
  ),
  band = c("C", "C", "C", 
           "C", "C", "C", 
           "C", "C", "C", "C", 
           "RE", "NIR", "NIR", 
           "NIR", "NIR", "NIR", 
           "NIR", "NIR", "NIR", "NIR", "NIR",
           "C", "C", "C", "C", "C", "C", "C",
           "C", "C", "C", "C", "C", "C", "C",
           "C", "C", "C", "C",
           "RE", "RE", "RE", 
           "NIR", "NIR", "NIR", "NIR", "NIR", "NIR", "NIR",
           "NIR", "NIR", "NIR", "NIR", "NIR", "NIR",
           "NIR", "NIR", "NIR", "NIR", "NIR", "NIR", "NIR", "NIR", "NIR")
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
