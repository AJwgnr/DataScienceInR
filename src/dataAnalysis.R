# Check/Install the needed Libraries
source('src/MineR/include.R')

# Source the needed functions
source("src/functions/data/dataloading.R")
source("src/functions/data/datapreprocessing.R")
source("src/functions/transformation/traj2graph.R")
source("src/functions/visualization/datavisualization.R")


#Raw datasets loaded from the csv
persons = loadPersonsDataset()
#trajectorie <- loadCompleteTrajectorieDataset()
roomsWorldOne <- loadRoomsDefinitionWorld(1)
roomsWorldTwo <- loadRoomsDefinitionWorld(2)
trajectorieDayOne <- loadTrajectoryByDay(1)
trajectorieDayTwo <- loadTrajectoryByDay(2)
##singleTRajectorie = loadTrajectorieByPersonIDAndDay(2,2)

#roomGraphDayOne <- computeRoomGraphDayOne(persons,trajectorieDayOne,roomsWorldOne,roomsWorldTwo)
#Funktioniert nocht nictht!
#roomGraphDayTwo <- computeRoomGraphDayTwo(persons,trajectorieDayTwo,roomsWorldOne,roomsWorldTwo)

# Beispiel für die Generierung eines Boxplots mit Anzeige der Datenpunkte
#plot_ly(y = roomGraphDayOne[[14]]$TimeSpent, type = "box", boxpoints = "all", jitter = 0.3,
#        pointpos = -1.8) 



for (trajectory in trajectorieDayOne){
  trajec <- trajectory
  trajec$vectorX <- (trajec$x[-1] - trajec$x)
  trajec$vectorY <- (trajec$y[-1] - trajec$y)
  trajec$vectorZ <- (trajec$z[-1] - trajec$z)
  
  trajec$vectorX[nrow(trajec)] <- 0
  trajec$vectorY[nrow(trajec)] <- 0
  trajec$vectorZ[nrow(trajec)] <- 0
  
  trajectorieDayOne[trajectory] <- trajec
}





# adhdChildren <- persons[persons$ADHD_Subtype>0]
# healthyChildren <- persons[persons$ADHD_Subtype==0]
# 
# 
# # Extract persons with respect 
# # Persons that have only seen the same world twice
# sameWorld <- persons[persons$Novelty == 1]
# sameWorldADHD <- sameWorld[sameWorld$ADHD_Subtype > 0 ] 
# sameWorldHealthy <- sameWorld[sameWorld$ADHD_Subtype == 0 ] 
# 
# # Persons that have seen a new world
# newWorld <- persons[persons$Novelty == 2]
# newWorldADHD <- newWorld[newWorld$ADHD_Subtype > 0]
# newWorldHealthy <- newWorld[newWorld$ADHD_Subtype == 0]
# 
# # Persons that have seen a partial new world (different color)
# partialNewWorld <- persons[persons$Novelty == 3]
# partialNewWorldADHD <- partialNewWorld[partialNewWorld$ADHD_Subtype > 0]
# partialNewWorldHealthy <- partialNewWorld[partialNewWorld$ADHD_Subtype == 0]
# 
# 
# 
# # General comparison of memorized words with respect to ADHD and the control kids
# plot_ly(y=adhdChildren$TP_DirectRecall, name ='ADHD TP_Direct', type = 'box', boxpoints='all', jitter = 0.3, pointpos = -1.8)%>%
#   add_trace(y=healthyChildren$TP_DirectRecall  , name = 'Healthy TP_Direct ' )%>%
#   add_trace(y=adhdChildren$TP_DelayedRecall, name ='ADHD TP_Delayed')%>%
#   add_trace(y=healthyChildren$TP_DelayedRecall, name ='Healthy TP_Delayed')
# 
# 
# plot_ly(y =sameWorldADHD$TP_DirectRecall, name = ' SameWorld TP_Direct (ADHD)' , type = "box", boxpoints = "all", jitter = 0.3,
#         pointpos = -1.8) %>%
#   add_trace(y = sameWorldADHD$TP_DelayedRecall, name = ' SameWorld TP_Delayed (ADHD)')%>%
#   add_trace(y = newWorldADHD$TP_DirectRecall, name = ' NewWorld TP_Direct (ADHD)')%>%
#   add_trace(y = newWorldADHD$TP_DelayedRecall, name = ' NewWorld TP_Delayed (ADHD)')%>%
#   add_trace(y = sameWorldHealthy$TP_DirectRecall, name = ' SameWorld TP_Direct (Healthy)')%>%
#   add_trace(y = sameWorldHealthy$TP_DelayedRecall, name = ' SameWorld TP_Delayed (Healthy)')%>%
#   add_trace(y = newWorldHealthy$TP_DirectRecall, name = ' NewWorld TP_Direct (Healthy)')%>%
#   add_trace(y = newWorldHealthy$TP_DelayedRecall, name = ' NewWorld TP_Delayed (Healthy)')%>%
#   
#   add_trace(y = sameWorld$TP_DirectRecall, name = ' SameWorld TP_Direct (Overall)')%>%
#   add_trace(y = sameWorld$TP_DelayedRecall, name = ' SameWorld TP_Delayed (Overall)')%>%
#   add_trace(y = newWorld$TP_DirectRecall, name = ' NewWorld TP_Direct (Overall)')%>%
#   add_trace(y = newWorld$TP_DelayedRecall, name = ' NewWorld TP_Delayed (Overall)')
# 
# 
#   # Der plot macht eher wenig Sinn ->also da müssen wir nochmal die Bedeutung der Daten anschauen
#   plot_ly(y =sameWorldADHD$FP_DirectRecall, name = ' SameWorld FP_DirectRecall (ADHD)' , type = "box", boxpoints = "all", jitter = 0.3,
#           pointpos = -1.8) %>%
#   add_trace(y = sameWorldADHD$FP_DelayedRecall, name = ' SameWorld FP_DelayedRecall (ADHD)')%>%
#   add_trace(y = newWorldADHD$FP_DirectRecall, name = ' NewWorld FP_DirectRecall (ADHD)')%>%
#   add_trace(y = newWorldADHD$FP_DelayedRecall, name = ' NewWorld FP_DelayedRecall (ADHD)')%>%
#   add_trace(y = sameWorldHealthy$FP_DirectRecall, name = ' SameWorld FP_DirectRecall (Healthy)')%>%
#   add_trace(y = sameWorldHealthy$FP_DelayedRecall, name = ' SameWorld FP_DelayedRecall (Healthy)')%>%
#   add_trace(y = newWorldHealthy$FP_DirectRecall, name = ' NewWorld FP_DirectRecall (Healthy)')%>%
#   add_trace(y = newWorldHealthy$FP_DelayedRecall, name = ' NewWorld FP_DelayedRecall (Healthy)')%>%
#   
#   add_trace(y = sameWorld$FP_DirectRecall, name = ' SameWorld FP_DirectRecall (Overall)')%>%
#   add_trace(y = sameWorld$FP_DelayedRecall, name = ' SameWorld FP_DelayedRecall (Overall)')%>%
#   add_trace(y = newWorld$FP_DirectRecall, name = ' NewWorld FP_DirectRecall (Overall)')%>%
#   add_trace(y = newWorld$FP_DelayedRecall, name = ' NewWorld FP_DelayedRecall (Overall)')

  

#TODO plot information about the dataset
#createSimpleDataOverview(persons)
# Preprocessed person dataset (Describe Preprocessing here!!!)
#preprocessed_persons = preprocessedPersonData(persons)
#createSimpleDataOverview(preprocessed_persons)
#TODO plot information about the preprocessed dataset
#createSimpleDataOverview(preprocessed_persons)
#TODO: Build Features from Treajectories











