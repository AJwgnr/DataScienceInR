library(data.table)
library(dplyr)
library(ggplot2)
# This file convertes trajectories to room based graphes
# x,y,z,time -> roomeId,roomeName,timeSpent (on this single entry(multiple entries stored seperately))

# Path to dataSet
# ToDo: adapt to use test persons world ID for correct room file
csv_room_coordinates_path <-
  ("../res/RoomsV1.0.csv")
csv_test_trajectories_path <-
  ("../res/position_data/minecraft_pos_log_VP01_Tag1_neu.csv")

# Load data...
rooms <- fread(csv_room_coordinates_path)
trajectorie <- fread(csv_test_trajectories_path)

# Swap x and y coordinates to make the left one the smaller one
for (row in 1:nrow(rooms)) {
  xx1 <- rooms[row, 2]
  xx2 <- rooms[row, 4]
  yy1 <- rooms[row, 3]
  yy2 <- rooms[row, 5]
  if (xx1 > xx2) {
    rooms[row, 2] <- xx2
    rooms[row, 4] <- xx1
  }
  
  if (yy1 > yy2) {
    rooms[row, 3] <- yy2
    rooms[row, 5] <- yy1
  }
}

# Convert Minecraft Coordinates to Python Coordinates
rooms$z  = rooms$z  - 72
rooms$x1 = rooms$x1 - 249
rooms$x2 = rooms$x2 - 249
rooms$y1 = rooms$y1 - 227
rooms$y2 = rooms$y2 - 227

trajectorie$Room = -1
tic <- Sys.time()
for (rows in 1:nrow(rooms)) {
  condition <-
    (
      trajectorie$x >= rooms[rows, x1] &
        trajectorie$x <= rooms[rows, x2] &
        trajectorie$y >= rooms[rows, y1] &
        trajectorie$y <= rooms[rows, y2] &
        # ToDo: Confirm right handlig of height
        trajectorie$z < rooms[rows, z] + 4 &
        trajectorie$z > rooms[rows, z] -1
    )
  trajectorie[condition == TRUE, "Room"] = rooms[rows, "id"]
}
toc <- Sys.time() - tic
print(toc)
tic <- Sys.time()
# Summarize into roomGraph
trajectorie$rleid = rleid(trajectorie$Room)
roomGraph = unique(trajectorie[, list(TimeSpent = .N * 0.1, Room, rleid), trajectorie$rleid])
toc <- Sys.time() - tic

print(toc)

#########################################################################################################################
###Visualisatzion                                                                                                     ###
#########################################################################################################################
z1filter = -100# set z1filter to -100 to get all levels
z2filter = 100# set z1filter to 100 to get all levels

# integrate time spent per room into
rooms = merge(
  rooms,
  aggregate(
    roomGraph$TimeSpent,
    by = list(TimeSpent = roomGraph$Room),
    FUN = sum
  ),
  by.x = "id",
  by.y = "TimeSpent",
  all.x = TRUE
)
colnames(rooms)[colnames(rooms) == "x"] <- "TimeSpent"
rooms[is.na(TimeSpent),"TimeSpent"]=0

g <- ggplot()
g <- g + scale_x_continuous(name = "x")
g <- g + scale_y_continuous(name = "y")
g <- g + geom_rect(
  data = rooms[z > z1filter & z < z2filter],
  #z< 100 to omit Inf for RoomID 0
  mapping = aes(
    xmin = x1,
    xmax = x2,
    ymin = -y1,
    ymax = -y2,
    fill = TimeSpent
  ),
  color = "black",
  alpha = 0.5
)
g <-
  g + geom_path(data = trajectorie[z > z1filter & z < z2filter],
                mapping = aes(x = x, y = -y),
                alpha = 0.5)#,color=as.factor(Room)
# highlight room visits < n sec
n <- 1
shortVisits = trajectorie[rleid %in% roomGraph[TimeSpent < 1]$rleid]
#g <-
  g + geom_point(data = trajectorie[Room <1000 &
                                      z > z1filter & z < z2filter], mapping = aes(x = x, y =
                                                                                    -y, color = "red"))
print(g)
