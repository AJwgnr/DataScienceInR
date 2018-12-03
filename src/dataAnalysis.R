#Import needed Libraries


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


#TODO plot information about the dataset
createSimpleDataOverview()



# Preprocessed person dataset (Describe Preprocessing here!!!)
preprocessed_persons = preprocessedPersonData(persons)
#TODO plot information about the preprocessed dataset
createSimpleDataOverview()



#TODO: Build Features from Treajectories











