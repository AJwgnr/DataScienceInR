###########################################################

# Responsible for all functions that process the trajectory data

###########################################################

# Compute roomGraph for the whole trajectorie set of day One
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
        # get id of virtual world on first day
        vr = personsDataTable[VP == vp, firstVR]
      } else if (day == 2) {
        # get id of virtual world on second day
        vr = personsDataTable[VP == vp, VE_Day2]
      } else{
        print("Unexpected day provided in computeRoomGraphByDay")
        return(NULL)
      }
      
      # id 1 and 3 relate to the world 1 (normal and colored world)
      if (vr == 1 || vr == 3) {
        roomGraphData[[vp]] = traj2graph(trajectoryData[[vp]], VR1coordinates)
      } else if (vr == 2)
      { # id 2 relates to the world 2 
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
  roomNames = unique(rooms[, c("id", "name")])
  
  # Create col 'Room' to store room id for each entry in trajectory
  trajectorie$Room <-  -1
  # Create col 'RoomHeight' to store
  trajectorie$RoomHeight <-  -100
  trajectorie$RoomType <- -1
  
  # Iterate over all rooms and create id entry for each row in trajectory. (speed up via vectorization might be possible)
  for (rows in 1:nrow(rooms)) {
    # Compare position with room coordinates
    condition <-
      (
        trajectorie$x >= rooms[rows, x1] &
          trajectorie$x <= rooms[rows, x2] &
          trajectorie$y >= rooms[rows, y1] &
          trajectorie$y <= rooms[rows, y2] &
          trajectorie$z >= rooms[rows, z] - 1
      )
    # Store room ID ('plane sweep' along z axis is used to compute correct room id. Only highest possible room ID survives)
    trajectorie[condition == TRUE, "Room"] = rooms[rows, "id"]
    trajectorie[condition == TRUE, "RoomHeight"] = rooms[rows, "z"]
    trajectorie[condition == TRUE, "RoomType"] = rooms[rows, "RoomType"]
  }
  # Summarize into roomGraph
  trajectorie$rleid <-  rleid(trajectorie$Room)
  trajectorie <-
    unique(trajectorie[, list(TimeSpent = .N * 0.1, Room, RoomType, rleid), trajectorie$rleid])[, c(2, 3, 4)]
  trajectorie <-
    merge(
      trajectorie,
      roomNames,
      by.x = "Room",
      by.y = "id",
      all.x = TRUE
    )
  return(trajectorie) # 0.1 sec spent per trajectory row/timestemp
}

# Create list containing data.table with ID, Name and TimeSpent per Room (person wise)
computeRoomHistByDay <-
  function(day, personsData, roomGraph, VR1, VR2) {
    # get unique rooms
    roomNamesVR1.0 = unique(VR1[, c("id", "name")])
    roomNamesVR2.0 = unique(VR2[, c("id", "name")])
    names(roomNamesVR1.0) = c("ID", "Name")
    names(roomNamesVR2.0) = c("ID", "Name")
    
    roomHist <- list()
    for (vp in personsData$VP) {
      # filter by day
      if (day == 1) {
        vr = personsData[VP == vp, firstVR]
      } else if (day == 2) {
        vr = personsData[VP == vp, VE_Day2]
      } else{
        print("Unexpected day provided in computeRoomHistByDay")
      }
      
      # use the different room files depending on the vr id
      if (vr == 1 || vr == 3) {
        roomHist[[vp]] = as.data.table(roomGraph2roomHist(roomGraph[[vp]], VR1, roomNamesVR1.0))
      } else if (vr == 2) {
        roomHist[[vp]] = as.data.table(roomGraph2roomHist(roomGraph[[vp]], VR2, roomNamesVR2.0))
      } else{
        print("Unexpected VR provided in computeRoomHistByDay")
        return(NULL)
      }
    }
    return(roomHist)
  }

# Convert roomGraph into roomHist containg the ID, Name and TimeSpent for every room
roomGraph2roomHist <- function(roomGraph, VR, roomNames) {
  roomHist = aggregate(
    roomGraph[, "TimeSpent"],
    by = list(Room = roomGraph$Room),
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
  roomHist = merge(
    roomHist,
    roomNames,
    by.x = "Room",
    by.y = "ID",
    all.x = TRUE
  )
  return(roomHist)
}

# Compute list of data.tables containing Id, Name, TimeSpent and Entries per Room (person wise)
computeRoomEntryHistogramByDay <-
  function(day,
           personsData,
           roomGraph,
           roomHist,
           VR1,
           VR2) {
    roomEntryHist <- list()
    # iterate over all persons
    for (vp in personsData$VP) {
      # get the vr id depending on the day
      if (day == 1) {
        vr = personsData[VP == vp, firstVR]
      } else if (day == 2) {
        vr = personsData[VP == vp, VE_Day2]
      } else{
        print("Unexpected day provided in computeRoomHistByDay")
      }
      
      # Distinguish the roomEntryHist calculation based on the virtual world id
      #TODO: FIXME (hard)
      if (vr == 1 || vr == 3) {
        roomEntryHist[[vp]] = as.data.table(roomHist2roomEntry(roomGraph[[vp]], roomHist[[vp]]))
      } else if (vr == 2) {
        roomEntryHist[[vp]] = as.data.table(roomHist2roomEntry(roomGraph[[vp]], roomHist[[vp]]))
      } else{
        print("Unexpected VR provided in computeRoomHistByDay")
        return(NULL)
      }
    }
    return(roomEntryHist)
  }

# Compute number of entries per room
roomHist2roomEntry <-
  function(roomGraph, roomHist) {
    # Count number of visits of each room
    entries = as.data.frame(count(roomGraph$Room))
    names(entries) = c("ID", "Entries")
    
    # Merge with roomHist to create table containing Id, Name, TimeSpent and Entries
    entries = merge(entries,
                    roomHist,
                    by.x = "ID",
                    by.y = "Room",
                    all = TRUE)
    entries$Entries[is.na(entries$Entries)] = 0
    return(entries)
  }