library(dplyr)
# This file convertes trajectories to room based graphes
# x,y,z,time -> roomeId,roomeName,timeSpent (on this single entry(multiple entries stored seperately))

# Path to dataSet
# ToDo: adapt to use test persons world ID for correct room file
csv_room_coordinates_path <- ("../res/RoomsV1.0.csv")
csv_test_trajectories_path <- ("../res/position_data/minecraft_pos_log_VP01_Tag1_neu.csv")

# Load data...
rooms <- read.csv(csv_room_coordinates_path)
trajectorie <- read.csv(csv_test_trajectories_path)

# swap x and y coordinates to make the left one the smaller one
for (row in 1:nrow(rooms)) {
  xx1 <- rooms[row,2]
  xx2 <- rooms[row,4]
  yy1 <- rooms[row,3]
  yy2 <- rooms[row,5]
  if(xx1 > xx2){
    rooms[row,2]<-xx2
    rooms[row,4]<-xx1
  }
  
  if(yy1 > yy2){
    rooms[row,3]<-yy2
    rooms[row,5]<-yy1
  }
}

rooms$z  = rooms$z  - 72
rooms$x1 = rooms$x1 - 249
rooms$x2 = rooms$x2 - 249
rooms$y1 = rooms$y1 - 227
rooms$y2 = rooms$y2 - 227


roomsgraph <- data.frame(roomID=integer(),roomName=character(),time=double())

for (row in 1:nrow(trajectorie)) {
  x <- trajectorie[row,2]
  y <- trajectorie[row,3]
  z <- trajectorie[row,4]
  for (currentroom in 1:nrow(rooms)) {
    if(rooms[currentroom,]){}
  }
}


# Only for display purposes
###################################################################################
### Stop here for correct x,y,z room coordinates. Continue for correct plotting ###
###################################################################################
rooms$x1 <- rooms$x1 * (-1)
rooms$x2 <- rooms$x2 * (-1)
xmin <- min(min(rooms$x1),min(rooms$x2))
rooms$x1 <- rooms$x1 - xmin
rooms$x2 <- rooms$x2 - xmin

#rooms <- rooms %>% dplyr::filter(z>75)

plot.new()
plot(c(-10,90),c(-40,60),rect(rooms[,2],rooms[,3],rooms[,4],rooms[,5]))