library(readr)
library(readxl)
library(psych)


csv_movement_folder_path <- folder <- "../res/position_data/" 
csv_persons_folder_path <- ("../res/person_data/minecraft_all_subjects.xlsx")
#lockBinding("csv_movement_folder_path", globalenv())
#lockBinding("csv_persons_folder_path", globalenv())



#Load datasets
persons <- read_excel(csv_persons_folder_path)

file_list <- list.files(path=csv_movement_folder_path, pattern="*.csv") 
# read in each .csv file in file_list and create a data frame with the same name as the .csv file
for (i in 1:length(file_list)){
  assign(file_list[i], read.csv(paste(csv_movement_folder_path, file_list[i], sep='')))
}
 




viewData <- function(){
  #View Dataset
  View(persons)
  
  #Data summary
  summary(persons)
  describe(persons)
  cor(persons)
}


filterData <- function(){
  
  #Preprocessing
  #TODO: Filter values or do NaN Processing
  
}




