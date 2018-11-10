library(readr)
library(readxl)
library(psych)

#Load datasets
minecraft_all_subjects <- read_excel("./res/person_data/minecraft_all_subjects.xlsx")

folder <- "./res/position_data/"      
# path to folder that holds multiple .csv files

file_list <- list.files(path=folder, pattern="*.csv") 
# create list of all .csv files in folder

# read in each .csv file in file_list and create a data frame with the same name as the .csv file
for (i in 1:length(file_list)){
  
  assign(file_list[i], 
         
         read.csv(paste(folder, file_list[i], sep=''))
         
  )}

#View Datasets
View(minecraft_all_subjects)
View(minecraft_pos_log_VP41_Tag1)

#Preprocessing
#TODO: Filter values or do NaN Processing



#Data summary
summary(minecraft_all_subjects)
describe(minecraft_all_subjects)
cor(minecraft_all_subjects)

