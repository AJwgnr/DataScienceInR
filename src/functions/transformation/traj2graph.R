# Trajectory function

# Compute roomGraph for whole trajectorieSet of Day One
computeRoomGraphByDay <-
  function(day,
           personsDataTable,
           trajectoryData,
           VR1coordinates,
           VR2coordinates) {
    roomGraphData <-  list()
    for (vp in personsDataTable$VP) {
      # get vr from personsDataTable
      if (day == 1) {
        vr = personsDataTable[VP == vp, firstVR]
      } else if (day == 2) {
        vr = personsDataTable[VP == vp, VE_Day2]
      } else{
        print("Unexpected day provided in computeRoomGraphByDay")
        return(NULL)
      }
      
      if (vr == 1 || vr == 3) {
        roomGraphData[[vp]] = traj2graph(trajectoryData[[vp]], VR1coordinates)
      } else if (vr == 2)
      {
        roomGraphData[[vp]] = traj2graph(trajectoryData[[vp]], VR2coordinates)
      } else{
        print("Unexpected vr id provided in computeRoomGraphByDay")
        return(NULL)
      }
      
    }
    return(roomGraphData)
  }


# Compute roomGraph for one single trajectorie data frame. Fitting room coordinates must be provided.
traj2graph <- function(trajectorie, rooms) {
  # Room coordinates must be sorted along z and x1<x2,y1<y2 is forced on data loading
  # Create col 'Room' to store room id for each entry in trajectory
  trajectorie$Room <-  -1
  # Create col 'RoomHeight' to store
  trajectorie$RoomHeight <-  -100
  trajectorie$RoomType <- -1
  
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
    trajectorie[condition == TRUE, "RoomType"] = rooms[rows, "RoomType"]
  }
  # Summarize into roomGraph
  trajectorie$rleid <-  rleid(trajectorie$Room)
  return(unique(trajectorie[, list(TimeSpent = .N * 0.1, Room, RoomType, rleid), trajectorie$rleid])[, c(2, 3, 4)]) # 0.1 sec spentd per trajectory row/timestemp
}

computeRoomHistByDay <- function(day, personsData, roomGraph, VR1, VR2) {
  roomHist <- list()
  for (vp in personsData$VP) {
    if (day == 1) {
      vr = personsData[VP == vp, firstVR]
    } else if (day == 2) {
      vr = personsData[VP == vp, VE_Day2]
    } else{
      print("Unexpected day provided in computeRoomHistByDay")
    }
    
    if (vr == 1 || vr == 3) {
      roomHist[[vp]] = roomGraph2roomHist(roomGraph[[vp]], VR1)
    } else if (vr == 2) {
      roomHist[[vp]] = roomGraph2roomHist(roomGraph[[vp]], VR2)
    } else{
      print("Unexpected VR provided in computeRoomHistByDay")
      return(NULL)
    }
  }
  return(roomHist)
}


roomGraph2roomHist <- function(rooms, VR) {
  roomHist = aggregate(
    rooms[, "TimeSpent"],
    by = list(Room = rooms$Room),
    FUN = sum,
    drop = FALSE
  )
  roomHist = merge(roomHist,
                   VR,
                   by.x = "Room",
                   by.y = "id",
                   all.y = TRUE)
  roomHist = roomHist[, c(1, 2)]
  roomHist = unique(roomHist)
  roomHist[is.na(roomHist$TimeSpent), "TimeSpent"] = 0
  
  return(roomHist)
}