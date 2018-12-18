#Import needed Libraries
library(dtplyr)
library(readxl)
library(data.table)
library(stringr)
library(ggplot2)


#Source the 
source("src/functions/data/dataloading.R")
source("src/functions/data/datapreprocessing.R")
#source("src/functions/preprocessing/traj2graph.R")
#source("src/functions/preprocessing/trajectoryToGraphes.R")
source("src/functions/visualization/datavisualization.R")


#Raw datasets loaded from the csv
persons = loadPersonsDataset()
roomsWorldOne = loadRoomsDefinitionWorldOne()
#roomsWorldTwo = loadRoomsDefinitionWorldTwo()
trajectorie = loadTrajectorieDataset()
singleTRajectorie = loadTrajectorieByPersonIDAndDay(2,2)


#TODO plot information about the dataset
createSimpleDataOverview(persons)


# Preprocessed person dataset (Describe Preprocessing here!!!)
preprocessed_persons = preprocessedPersonData(persons)
createSimpleDataOverview(preprocessed_persons)

#TODO plot information about the preprocessed dataset
#createSimpleDataOverview(preprocessed_persons)



#TODO: Build Features from Treajectories











