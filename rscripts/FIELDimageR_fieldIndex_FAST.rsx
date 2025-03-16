##FIELDimageR=group
##mosaic_layer=raster
##bands=string Red,Green,Blue
##index=string HUE,VARI,GLI,NGRDI
##My_index=optional string (Red-Blue)/Green,Red/Green
##n_cores=string 4
##output_directory=folder

library(terra)
library(gdalraster)
library(dplyr)
library(parallel)

# Load the raster layer
mosaic <- rast(mosaic_layer)
stacked_file <-sources(mosaic)
print(stacked_file)
bands <- strsplit(bands, ",")[[1]]
num.band<-as.numeric(nlyr(mosaic))
# Define the user input sequence
user_input_sequence <- bands
print(user_input_sequence)
cores <- as.numeric(n_cores)
available_cores <- detectCores()

if (cores > available_cores) {
  stop(paste("Error: Requested", cores, "cores, but only", available_cores, "are available."))
}
# Check if the number of bands matches the length of the user-defined bands
if (length(user_input_sequence) != num.band) {
  stop("Error: The number of bands in the raster does not match the length of the provided band list.")
}

# Continue with the rest of the code if the check passes
print("The number of bands is valid.")
# Define the indices to calculate
selected_indices<-strsplit(gsub("\\s", "", index), ",")[[1]]
print(selected_indices)
# Define the indices calculation functions
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

index <- strsplit(gsub("\\s", "", index), ",")[[1]]
if ( nzchar(My_index)){ 
  # Split My_index into separate components
  My_index_split <- strsplit(gsub("\\s", "", My_index), ",")[[1]]
  
  # Loop through the split indices and create the corresponding equations
  for (i in 1:length(My_index_split)) {
    # Parse the equation text corresponding to the index
    eq_new <- paste0("(", My_index_split[i], ")")  # Adding parenthesis to form valid equations
    eq <- eq_new  # Assign the new equation
    
    # Generate index name as MyIndex_1, MyIndex_2, etc.
    index_name <- paste0("MyIndex_", i)
    
    # Add to the Ind dataframe with the updated index name
    Ind <- rbind(Ind, data.frame(index = index_name, eq = eq, band = "MyInd"))  # Assuming band is "NIR" for simplicity
  }
  
  # Update the index vector with the new names
  index <- c(index, paste0("MyIndex_", seq_along(My_index_split)))
  selected_indices<-index
}
# Process the selected indices
IRGB <- as.character(Ind$index)

available_indices <- IRGB

print("Available Indices:")
print(available_indices)
print("Selected Indices:")
print(selected_indices)

if (any(!selected_indices %in% available_indices)) {
  stop("Selected indices are not available in FIELDimageR")
}

# Check for NIR or RE dependency
NIR.RE <- as.character(Ind$index[Ind$band %in% c("RE", "NIR")])
if (any(NIR.RE %in% index) && all(bands %in% 'NIR')) {
  stop(paste("Index: ", NIR.RE[NIR.RE %in% index], " needs NIR/RE band to be calculated", sep = ""))
}

band_mapping <- setNames(seq_along(user_input_sequence), user_input_sequence)

# Define the path for the temporary directory (using the default temp directory)
output_directory <- output_directory
# Function to calculate multiple indices
calculate_multiple_indices <- function(indices, user_input_sequence, stacked_file) {
  # Validate user input sequence
  if (length(user_input_sequence) < 1) {
    stop("User input sequence must have at least one band.")
  }
  
  # Generate band mapping dynamically based on user input
  band_mapping <- setNames(seq_along(user_input_sequence), user_input_sequence)
  
  # Initialize an empty character vector to store the output file paths
  output_files <- character(0)
  
  # Create the progress bar
  pb <- txtProgressBar(min = 0, max = length(indices), style = 3)
  
  # Set up parallel processing
  cores <- cores
  cl <- makeCluster(cores)
  
  # Load required packages on cluster nodes
  clusterEvalQ(cl, {
    library(gdalraster)
    library(terra)
  })
  
  clusterExport(cl, c("band_mapping", "stacked_file", "calc", "Ind","output_directory"))
  
  # Define the calc_raster function that takes all necessary arguments
  calc_raster <- function(index_name, band_mapping, stacked_file) {
    # Validate the selected index
    if (!(index_name %in% Ind$index)) {
      warning(paste("Invalid index skipped:", index_name))
      return(NULL)
    }
    
    selected_index <- Ind[Ind$index == index_name, ]
    expr <- selected_index$eq
    
    # Extract band names used in the expression
    vars_in_expr <- unique(unlist(regmatches(expr, gregexpr(paste(names(band_mapping), collapse = "|"), expr))))
    
    # Check that all bands in the expression are in the user-defined sequence
    if (!all(vars_in_expr %in% names(band_mapping))) {
      warning(paste("Expression for", index_name, "contains bands not found in the user input sequence. Skipping..."))
      return(NULL)
    }
    
    # Create rasterfiles, bands, and variable names for the calc function
    rasterfiles <- rep(stacked_file, length(vars_in_expr))
    bands <- unlist(band_mapping[vars_in_expr])
    var_names <- vars_in_expr
    
    # Create a temporary file with your desired name and extension (without random string)
    output_file <- file.path(output_directory, paste0(index_name, ".tif"))
    
    
    # Run the calc function with error handling
    tryCatch({
      calc(
        expr = expr,
        rasterfiles = rasterfiles,
        bands = bands,
        var.names = var_names,
        dstfile = output_file,
        fmt = "GTiff",
        dtName = "Float32",
        options = c("COMPRESS=LZW"),
        nodata_value = -9999,
        write_mode = "overwrite",
        setRasterNodataValue = TRUE,
        quiet = FALSE
      )
      return(output_file)
    }, error = function(e) {
      warning(paste("Error processing index:", index_name, "-", e$message))
      return(NULL)
    })
  }
  
  # Calculate indices in parallel, passing all necessary data
  output_files <- parLapply(cl, indices, function(index) {
    calc_raster(index, band_mapping, stacked_file)
  })
  
  # Stop the cluster
  stopCluster(cl)
  
  # Update the progress bar and print messages
  for (i in seq_along(indices)) {
    setTxtProgressBar(pb, i)
    if (!is.null(output_files[[i]])) {
      message(indices[i], " index saved to temporary file: ", output_files[[i]])
    }
  }
  
  # Close the progress bar
  close(pb)
  # Remove NULL entries and unlist
  output_files <- unlist(output_files[!sapply(output_files, is.null)]) 
  # Return the list of output file paths
  return(output_files)
}

# Call the function
output_files <- calculate_multiple_indices(selected_indices, user_input_sequence, stacked_file)

