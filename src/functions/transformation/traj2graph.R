# Trajectory function


# Possible Combinations:
# Day1      | Day2     | Novelty |  firstVR
# Mansion     Mansion    1          1
# Mansion     Mansion(C) 3          1
# Mansion(C)  Mansion    3          3
# Mansion(C)  Mansion(C) 1          3
# Mansion     Pirate     2          1
# Mansion(C)  Pirate     2          3
# Pirate      Pirate     1          2
# Pirate      Mansion    2          2
# Pirate      Mansion(C) 2          2

# Compute roomGraph for whole trajectorieSet of Day One
# Trajectory Data MUST fit room (unsafe)??
computeRoomGraphDayOne <-
  function(personsDataTable,
           trajectoryData,
           VR1coordinates,
           VR2coordinates) {
    roomGraphData <-  list()
      for (vp in personsDataTable$VP) {
        print(vp)
        # firstVR ==1 or 3 says that it is the mansion or the colored mansion
        if (personsDataTable[VP==vp,firstVR] == 1 || personsDataTable[VP==vp,firstVR] == 3) {
          roomGraphData[[vp]] <-  traj2graph(trajectoryData[[vp]], VR1coordinates)
        }
        # firstVR ==2 says that it is the pirate ship
        else if(personsDataTable[VP==vp,firstVR] == 2) {
          roomGraphData[[vp]] <-  traj2graph(trajectoryData[[vp]], VR2coordinates)
        }
        else{
          print('Unknown attribute value of FirstVR')
        }
      }
    return(roomGraphData)
  }


# Compute roomGraph for whole trajectorieSet of Day One
# Trajectory Data MUST fit room (unsafe)??
computeRoomGraphDayTwo <-
  function(personsDataTable,
           trajectoryData,
           VR1coordinates,
           VR2coordinates) {
    roomGraphData <-  list()
    for (vp in personsDataTable$VP) {
      print(vp)
      # On first day it was either the mansion or the colored mansion (firstVR ==1 or 3)
      if (((personsDataTable[VP==vp,firstVR] == 1) || (personsDataTable[VP==vp,firstVR] == 3))){
        #novelty indicates the same or only partial different world on the second day (novelty ==1 or 3)
        if ((personsDataTable[VP==vp,Novelty] == 1) || (personsDataTable[VP==vp,Novelty] == 3)) {
        # So use coordinates from mansion
        roomGraphData[[vp]] <-  traj2graph(trajectoryData[[vp]], VR1coordinates)
        } 
        # If novelty indicates new world
        else if ((personsDataTable[VP==vp,Novelty] == 2)) {
          #use coordinates of the pirate ship world
        roomGraphData[[vp]] <-  traj2graph(trajectoryData[[vp]], VR2coordinates)
        }}
      # if the first world was the pirate ship
      else if(personsDataTable[VP==vp,firstVR] == 2){
        # and novelty indicates same world
        if(personsDataTable[VP==vp,Novelty] == 1){
          # use pirate bay
          roomGraphData[[vp]] <-  traj2graph(trajectoryData[[vp]], VR2coordinates)
        }
        # if novelty indicates a new world use the mansion
        else if (personsDataTable[VP==vp,Novelty] == 2){
          roomGraphData[[vp]] <-  traj2graph(trajectoryData[[vp]], VR1coordinates)
        }
      }
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