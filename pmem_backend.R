#Importing libraries
#.libPaths(c("./library",.libPaths()))
setwd("srv/shiny-server")
library(readr)
library(dplyr)
current_path <- normalizePath(file.path(".", ""))
print(current_path)
if(file.exists("/srv/shiny-server/Data/11-may-2023-11:46AM_testdata.csv")){
df_f2f<-read.csv("/srv/shiny-server/Data/11-may-2023-11:46AM_testdata.csv")
}else {
  print("waiting for the data")
}


 
var.character<-c("Dst.IP","Src.IP","Flow.ID","Src.Port")
df_f2f<-select(df_f2f,-all_of(var.character))
combined_dataset<-df_f2f
table(combined_dataset$Label)
write.csv(combined_dataset, file ="./Data/f2f_testingfile_11_may.csv", row.names=FALSE)
table(combined_dataset$Protocol)
##############################################################
shh <- suppressPackageStartupMessages 
shh(library("dplyr")) 
shh(library("tidyverse")) 
shh(library("mlr3")) 
shh(library("mlr3viz")) #te permite dibujar la task
shh(library("mlr3verse")) 
shh(library("mlr3tuning")) 
shh(library("mlr3learners")) 
shh(library("mlr3fselect")) 

df <- read_csv("./Data/f2f_testingfile_11_may.csv")
df["Label"] <- lapply(df["Label"], as.factor) #conversión de character a factor
nm_cols <- unlist(lapply(df, is.integer))
df[nm_cols] <- lapply(df[nm_cols], as.numeric) #conversión los datos integer & double a numeric

#Data mining
# Eliminar NAs. Seleccionar las filas que contienen todos los datos.
completos<-complete.cases(df)
# Nos quedamos con las filas que contienen todos los datos
df<-df[completos,]
# Extraer las variables de tipo caracter de el fichero de datos
var.character<-c("Timestamp","Label")
# c(84,7,4,2,1)
datosNum<-select(df,-all_of(var.character))
#Aplicamos la función try_convert para mantener los datos originales si los valores no pueden ser trasladados a numérico
try_convert <- function(x, classname) {
  tmp <- x
  tryCatch({
    suppressWarnings(class(tmp) <- classname)
    tmp
  }
  )
}
#A continuación realizamos el cambio a numérico
datosNum<-setNames(data.frame(lapply(datosNum,try_convert,"numeric")),colnames(datosNum))
datos<-datosNum
## it is a common need to only perform some processes on numerics
## initialize empty vectors first, then fill
nums<-vector(); nums_x<-vector()
## we will need to refresh the vars from time to time
## so we make it a function to avoid copy/paste
reset_numeric_vector<-function(df){
  nums<<-which(unlist(lapply(df, is.numeric)))
  nums_x<<-nums[1:(length(nums)-1)]
  #return(paste("nums and nums_x have been reset"))
}
reset_numeric_vector(datos)
## We now scale the numerics that were not transformed, and therefore not scaled yet
# we initialize and empty vector then fill it shortly
not_scaled<-vector()
## we only need to scale the numerics that go below 0 or above 1
for (ns in nums_x){
  if (summary(datos[,ns])[1]<0 | summary(datos[,ns])[6]>1){
    not_scaled<-c(not_scaled,ns)
  }
}
## we scale the remaining numerics (we had only treated the vars
## that had been transformed)
for (ns in not_scaled){
  datos[,ns]<-scales::rescale(datos[,ns],to=c(0,1))
}
combined<-cbind(datos,df[80])
write.csv(combined, file ="./Data/f2f_test_11_may_scalled.csv", row.names=FALSE)
################################################################################################
## Section 3: Model Testing.  

confTrain<-table(Predicted=svm.predtrain,Reference=predLabels)
print("confTrain") 
print(confTrain)

