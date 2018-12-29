# Libraries
source('src/MineR/include.R')

#Source the 
source("src/functions/data/dataloading.R")
source("src/functions/data/datapreprocessing.R")
source("src/functions/transformation/traj2graph.R")
#source("src/functions/preprocessing/trajectoryToGraphes.R")
source("src/functions/visualization/datavisualization.R")


#Raw datasets loaded from the csv
persons = loadPersonsDataset()
roomsWorldOne <- loadRoomsDefinitionWorld(1)
roomsWorldTwo <- loadRoomsDefinitionWorld(2)
trajectorieDayOne <- loadTrajectoryByDay(1)
trajectorieDayTwo <- loadTrajectoryByDay(2)
##singleTRajectorie = loadTrajectorieByPersonIDAndDay(2,2)

#graph <- computeRoomGraphByDay(1,persons,trajectorie,roomsWorldOne,roomsWorldTwo)


#TODO plot information about the dataset
#createSimpleDataOverview(persons)
# Preprocessed person dataset (Describe Preprocessing here!!!)
#preprocessed_persons = preprocessedPersonData(persons)
#createSimpleDataOverview(preprocessed_persons)
#TODO plot information about the preprocessed dataset
#createSimpleDataOverview(preprocessed_persons)
#TODO: Build Features from Treajectories











