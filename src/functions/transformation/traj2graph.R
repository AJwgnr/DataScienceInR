# Trajectory function


# Compute roomGraph for whole trajectorieSet of Day:day
# Trajectory Data MUST fit room (unsafe)
computeRoomGraphByDay <-
  function(day,
           personsDataTable,
           trajectoryData,
           VR1coordinates,
           VR2coordinates) {
    # this function has not been tested at all
    roomGraphData <-  list()
    if (day == 1) {
      for (vp in personsDataTable$VP) {
        print(vp)
        # Different room coordinates need on same day....
        if (personsDataSet[VP==vp,firstVR]< 3) {
          # < 3 correct for coordinates of VR1? double check
          roomGraphData[[vp]] <-  traj2graph(trajectoryData[[vp]], VR1coordinates)
        }
        else {
          roomGraphData[[vp]] <-  traj2graph(trajectoryData[[vp]], VR2coordinates)
        }
      }
      
    } else if (day == 2) {
      # same just different day...
      
    } else{
      print("Unsupported day entered in computeRoomGraphByDay")
      return()
      
    }
    
    return(roomGraphData)
  }

# Compute roomGraph for one single trajectorie data frame. Room coordinates must be provided.
traj2graph <- function(trajectorie, rooms) {
  # Room coordinates must be sorted along z and x1<x2,y1<y2 is forced on data loading
  # Create col 'Room' to store room id for each entry in trajectory
  trajectorie$Room <-  -1
  # Create col 'RoomHeight' to store
  trajectorie$RoomHeight <-  -100
  
  # Iterate rooms and create id entry for each row in trajectory. (speed up via vectorization might be possible)
  for (rows in 1:nrow(rooms)) {
    # Compare position with room coordinates
    condition <-
      (
        trajectorie$x >= rooms[rows, x1] &
          trajectorie$x <= rooms[rows, x2] &
          trajectorie$y >= rooms[rows, y1] &
          trajectorie$y <= rooms[rows, y2] &
          trajectorie$z >= rooms[rows, z] - 1
        # &trajectorie$z <= rooms[rows, z] + 4 # Set maximum room height: usefull for debuggin, may produce false negatives on stairs
      )
    # Store room ID ('plane sweep' along z axis is used to compute correct room id. Only highest possible room ID survives)
    trajectorie[condition == TRUE, "Room"] = rooms[rows, "id"]
    trajectorie[condition == TRUE, "RoomHeight"] = rooms[rows, "z"]
  }
  # Summarize into roomGraph
  # FIXME: currently dosen't work because traj is used by reference
  trajectorie$rleid <-  rleid(trajectorie$Room)
  return(unique(trajectorie[, list(TimeSpent = .N * 0.1, Room, rleid), trajectorie$rleid])[, c(2, 3)]) # 0.1 sec spentd per trajectory row/timestemp
}




roomGraph2roomHist <- function() {
  # THE FOLLOWING CODE IS FROM TRAJECTORYTOGRAPHES AND DOES NOT WORK CORRECTLY
  # FIXME: rooms can have same id because of none-rectangularity, this not working properly yet
  # TEST: total time spent after computing time per room must be equal to time spent in world (as nrwo(traj)*0.1)
  
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
  rooms[is.na(TimeSpent), "TimeSpent"] = 0
  
}