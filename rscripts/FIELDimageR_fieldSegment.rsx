##FIELDimageR=group
##mosaic_layer=raster
##training_dataset=vector
##sample_points=number 200
##algorithm=selection randomForest;cart randomForest
##seed=number 5
##output_segment=output raster

# Get input parameters from QGIS
library(terra)
library(dplyr)
library(rpart)
library(randomForest)
library(sf)

mosaic<-rast(mosaic_layer)

if(st_crs(training_dataset)!= st_crs(mosaic)){
training_dataset=training_dataset%>%st_transform(st_crs(mosaic))
}
colnames(training_dataset)<-tolower(colnames(training_dataset))

if((unique(as.character(st_geometry_type(training_dataset)))=='POLYGON')||(unique(as.character(st_geometry_type(training_dataset)))=='MULTIPOLYGON')){
trainDataset<-spatSample(vect(st_as_sf(training_dataset)), sample_points, method="random")
}else{
trainDataset<-st_as_sf(training_dataset)
}
trainDataset
extr_train <- terra::extract(mosaic, trainDataset)
extr_train$class <- trainDataset$class

train <- extr_train %>%
  group_by(class) %>%
  sample_frac(0.7, replace = FALSE)

test <- setdiff(extr_train, train)

train <- data.frame(train)
train$class <- as.factor(train$class)

test <- data.frame(test)
test$class <- as.factor(test$class)

train <- na.omit(train)
test <- na.omit(test)

x <- train[, 2:(ncol(train) - 1),drop=FALSE]
y <- train$class

set.seed(seed)

if (algorithm==0) {
   sup_model <- randomForest(formula=y~., data=x)
} else if (algorithm==1) {
  sup_model <- rpart(y~., x, method = 'class', minsplit = 5)
}

sup_model
pred <- terra::predict(sup_model, test,na.rm=TRUE)
rastPred <- terra::predict(mosaic, sup_model,na.rm=TRUE)
pred
output_segment=rastPred

