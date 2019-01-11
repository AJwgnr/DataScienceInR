# Check/Install the needed Libraries
source('include.R')

# Source the needed functions
source("../../src/functions/data/dataloading.R")
source("../../src/functions/data/datapreprocessing.R")
source("../../src/functions/transformation/traj2graph.R")
source("../../src/functions/visualization/datavisualization.R")

  # Load all stored person data
  personsDataTable <- loadPersonsDataset()
  
  # Load trajectorie data for day one and day two into a key value like list
  trajectoryDataDayOne = loadTrajectoryByDay(1)
  trajectoryDataDayTwo = loadTrajectoryByDay(2)
  
  # Load room coordinates of the virtual worlds
  roomCoordinatesVR1.0 = loadRoomsDefinitionWorld(1)
  roomCoordinatesVR2.0 = loadRoomsDefinitionWorld(2)
  
  # Precomputes the visited rooms and also the spent time for each day for each trajectorie using a csv. file where the "rooms" of the worlds are provided
  # Creates a histogram of the visited rooms/with spent time for each day for each trajectorie
  roomGraphDataDayOne = loadRoomGraphByDay(1,personsDataTable,trajectoryDataDayOne,roomCoordinatesVR1.0,roomCoordinatesVR2.0)
  roomGraphDataDayTwo = loadRoomGraphByDay(2,personsDataTable,trajectoryDataDayTwo,roomCoordinatesVR1.0,roomCoordinatesVR2.0)
  roomHistDayOne = loadRoomHistByDay(1,personsDataTable,roomGraphDataDayOne,roomCoordinatesVR1.0,roomCoordinatesVR2.0)
  roomHistDayTwo = loadRoomHistByDay(2,personsDataTable,roomGraphDataDayTwo,roomCoordinatesVR1.0,roomCoordinatesVR2.0)
  

  
  #listWorldMansion <-  
  #listWorldPirateBay <- 
  #listWorldMansionColored <- 





'
for(vp in persons$VP){
  trajec <- trajectorieDayOne[[vp]]
  trajec$vectorX <- (trajec$x[-1] - trajec$x)
  trajec$vectorY <- (trajec$y[-1] - trajec$y)
  trajec$vectorZ <- (trajec$z[-1] - trajec$z)
  
  trajec$vectorX[nrow(trajec)] <- 0
  trajec$vectorY[nrow(trajec)] <- 0
  trajec$vectorZ[nrow(trajec)] <- 0
  
  trajec$vectorX1 <- (trajec$vectorX[-1])
  trajec$vectorY1 <- (trajec$vectorY[-1])
  trajec$vectorZ1 <- (trajec$vectorZ[-1])
  
  trajec$angle <- ((dot(c(trajec$vectorX,trajec$vectory,trajec$vectorz),c(trajec$vectorX1,trajec$vectorX2,trajec$vectorX3)))/((Norm(c(trajec$vectorX,trajec$vectory,trajec$vectorz)))*(Norm(c(trajec$vectorX1,trajec$vectory1,trajec$vectorz1)))))
  
  trajectorieDayOne[[vp]] <- trajec

}'






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

  













