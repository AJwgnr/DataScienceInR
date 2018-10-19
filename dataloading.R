library(readr)
library(readxl)
library(psych)

#Load datasets
minecraft_pos_log_VP41_Tag1 <- read_csv("res/minecraft_pos_log_VP41_Tag1.csv")
minecraft_all_subjects <- read_excel("res/minecraft_all_subjects.xlsx")

#View Datasets
View(minecraft_all_subjects)
View(minecraft_pos_log_VP41_Tag1)

#Preprocessing
#TODO: Filter values or do NaN Processing



#Data summary
summary(minecraft_all_subjects)
describe(minecraft_all_subjects)
cor(minecraft_all_subjects)
