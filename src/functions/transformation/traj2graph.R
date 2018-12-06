# Trajectory function

traj2graph <- function(trajectorie,rooms){
  
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
  # Summarize into roomGraph
  trajectorie$rleid = rleid(trajectorie$Room)
  roomGraph = unique(trajectorie[, list(TimeSpent = .N * 0.1, Room, rleid), trajectorie$rleid])
  return(roomGraph)
}