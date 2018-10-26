library(readr)
library(readxl)
library(psych)

#Load datasets
dataDescriptionPath <- "res/minecraft_all_subjects.xlsx"
movementPath <- "res/minecraft_pos_log_VP41_Tag1.csv"
minecraft_pos_log_VP41_Tag1 <- read_csv(movementPath)
minecraft_all_subjects <- read_excel(dataDescriptionPath)

#View Datasets
View(minecraft_all_subjects)
View(minecraft_pos_log_VP41_Tag1)

#Preprocessing
#TODO: Filter values or do NaN Processing



#Data summary
summary(minecraft_all_subjects)
describe(minecraft_all_subjects)
cor(minecraft_all_subjects)


