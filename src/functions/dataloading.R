###########################################################

# Responsible for all functions that load data

###########################################################
# Path definitions to our data
# Folder with all trajectorie data
CSV_TRAJECTORIES_FOLDER_PATH <- "../../res/position_data/"

# Path to the .xlsx with the information about all test persons
CSV_PERSONS_FOLDER_PATH <-
  ("../../res/person_data/minecraft_all_subjects.csv")

# CSV defining the coordinates of the rooms in world one
CSV_ROOM_WORLD_ONE_COORDINATE_PATH <-
  ("../../res/SortedRooms_V1.0.csv")

# CSV defining the coordinates of the rooms in world two
CSV_ROOM_WORLD_TWO_COORDINATE_PATH <-
  ("../../res/SortedRooms_V2.0.csv")


# Loads and returns the dataset containing all persons attributes into a data table
loadPersonsDataset <- function() {
  # reads from the above defined path constant
  persons <- as.data.table(fread(CSV_PERSONS_FOLDER_PATH))
  return(persons)
}

# Loads a dataframe which contains the coordinates of the rooms in the minecraft world
# Don´t change this function because it sorts the coordinates in the end, which is really crucial for the later trajectorie processing
loadRoomsDefinitionWorld <- function(world_id) {
  if (world_id == 1) {
    rooms <- fread(CSV_ROOM_WORLD_ONE_COORDINATE_PATH)
  } else if (world_id == 2) {
    rooms <- fread(CSV_ROOM_WORLD_TWO_COORDINATE_PATH)
  } else{
    print("Wrong world_id provided")
    return()
  }
  
  # Transform minecraft to python coordinates (python references mc world origin, mc references spwan origin)
  if (world_id == 1) {
    rooms$z  = rooms$z  - 72
    rooms$x1 = rooms$x1 - 249
    rooms$x2 = rooms$x2 - 249
    rooms$y1 = rooms$y1 - 227
    rooms$y2 = rooms$y2 - 227
  } else if (world_id == 2) {
    rooms$z  = rooms$z  - 64
    rooms$x1 = rooms$x1 - 64
    rooms$x2 = rooms$x2 - 64
    rooms$y1 = rooms$y1 - 188
    rooms$y2 = rooms$y2 - 188
  }
  
  # reflect y to fix python logging bug
  rooms[, y1 := -y1]
  rooms[, y2 := -y2]
  
  # Sort room coordinates : x1<x2,y1<y2
  # Room coordinates MUST be presorted by z to work correctly with the functions in traj2graph!
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
  return(rooms)
}



# Loads all .csv files (trajectories) contained in the CSV_TRAJECTORIES_FOLDER_PATH specified directory
# Returns a list of data tables of csv files
loadCompleteTrajectorieDataset <- function() {
  # filenames of the .csv files in the CSV_TRAJECTORIES_FOLDER_PATH directory
  fileNames <-
    list.files(path = CSV_TRAJECTORIES_FOLDER_PATH,
               pattern = ".csv",
               full.names = TRUE)
  
  # Read data using fread
  readdata <- function(fn) {
    dt_temp <- fread(fn, sep = ",")
    return(dt_temp)
  }
  # List containing all data tables
  mylist <- lapply(fileNames, readdata)
  return(mylist)
}

# Loads all .csv files in CSV_TRAJECTORIES_FOLDER_PATH matching "*minecraft_pos_log_VP.*_Tag#_neu.csv", where # = {1,2}
loadTrajectoryByDay <- function(day) {
  fileNames <-
    list.files(path = CSV_TRAJECTORIES_FOLDER_PATH,
               pattern = ".csv",
               full.names = TRUE)
  # Filter files by the provided day variable
  if ((day == 1 | day == 2)) {
    # filter files for the specfied day
    fileNames <-
      fileNames[grepl(paste("*minecraft_pos_log_VP.*_Tag", day, "_neu.csv", sep =
                              ""),
                      fileNames)]
    # Create list for trajectories
    trajectoryData = list()
    # Load trajectories into list: acces via VP number (NOT id)
    for (trajectory in fileNames) {
      key = as.integer(sub("_Tag.*", "", sub(".*VP", "", trajectory)))
      value = fread(trajectory, sep = ",")
      # reflect y coordinates to fix possible python logging error
      value[, y := -y]
      # Don't append an ID or similar here..just creats a bunch of problems on it's own...
      trajectoryData[[key]] = value
    }
    return(trajectoryData)
  } else{
    # There was a wrong day provided
    print('Wrong day provided. Only "1" and "2" possible!')
    return(NULL)
  }
}

# Function to precompute room graph data only once and load it from storage every secutive run
# Data is stored in .rds files because it is much faster
loadRoomGraphByDay <-
  function(day,
           personsDataTable,
           trajectoryData,
           VR1,
           VR2) {
    if (day == 1) {
      # Compute data if not present in directory
      if (find.file('roomGraphDayOne.rds', "../../res/precomputed_data/") ==
          "") {
        print("Precomputing roomGraphDayOne")
        roomGraph <-
          computeRoomGraphByDay(1, personsDataTable, trajectoryData, VR1, VR2)
        saveRDS(roomGraph, file = '../../res/precomputed_data/roomGraphDayOne.rds')
      } else{
        print("Loading previously roomGraphDayOne")
        roomGraph <-
          readRDS('../../res/precomputed_data/roomGraphDayOne.rds')
      }
    } else if (day == 2) {
      # Compute data if not present in directory
      if (find.file('roomGraphDayTwo.rds', "../../res/precomputed_data/") ==
          "") {
        print("Precomputing roomGraphDayTwo")
        roomGraph <-
          computeRoomGraphByDay(2, personsDataTable, trajectoryData, VR1, VR2)
        saveRDS(roomGraph, file = '../../res/precomputed_data/roomGraphDayTwo.rds')
      } else{
        print("Loading previously computed roomGraphDayTwo")
        roomGraph <-
          readRDS('../../res/precomputed_data/roomGraphDayTwo.rds')
      }
    } else{
      print("Unexpected day provided in loadRoomGraph")
    }
    return(roomGraph)
  }

# Function to precompute room histogram data only once and load it from storage every secutive run
loadRoomHistByDay <-
  function(day, personsDataTable, roomGraph, VR1, VR2) {
    if (day == 1) {
      # Compute data if not present in directory
      if (find.file('roomHistDayOne.rds', "../../res/precomputed_data/") ==
          "") {
        print("Precomputing roomHistDayOne")
        roomHist <-
          computeRoomHistByDay(1, personsDataTable, roomGraph, VR1, VR2)
        roomHist <-
          computeRoomEntryHistogramByDay(1, personsDataTable, roomGraph, roomHist)
        saveRDS(roomHist, file = '../../res/precomputed_data/roomHistDayOne.rds')
      } else{
        print("Loading previously computed roomHistDayOne")
        roomHist <-
          readRDS('../../res/precomputed_data/roomHistDayOne.rds')
      }
    } else if (day == 2) {
      # Compute data if not present in directory
      if (find.file('roomHistDayTwo.rds', "../../res/precomputed_data/") ==
          "") {
        print("Precomputing roomHistDayTwo")
        roomHist <-
          computeRoomHistByDay(2, personsDataTable, roomGraph, VR1, VR2)
        roomHist <-
          computeRoomEntryHistogramByDay(2, personsDataTable, roomGraph, roomHist)
        saveRDS(roomHist, file = '../../res/precomputed_data/roomHistDayTwo.rds')
      } else{
        print("Loading previously roomHistDayTwo")
        roomHist <-
          readRDS('../../res/precomputed_data/roomHistDayTwo.rds')
      }
    } else{
      print("Unexpected day provided in loadRoomHist")
    }
    
    return(roomHist)
  }