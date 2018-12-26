# PATH DECLARATIONS
CSV_TRAJECTORIES_FOLDER_PATH <- "../../res/position_data/"
CSV_PERSONS_FOLDER_PATH <-
  ("../../res/person_data/minecraft_all_subjects.xlsx")
CSV_ROOM_WORLD_ONE_COORDINATE_PATH <-
  ("../../res/SortedRooms_V1.0.csv")
CSV_ROOM_WORLD_TWO_COORDINATE_PATH <-
  ("../../res/SortedRooms_V2.0.csv")


# Loads the dataset containing all persons attributes into a data table
loadPersonsDataset <- function() {
  persons <- as.data.table(read_excel(CSV_PERSONS_FOLDER_PATH))
  return(persons)
}

# Loads a dataframe which contains the coordinates of the rooms in the minecraft world one
loadRoomsDefinitionWorld <- function(world_id) {
  if (world_id == 1) {
    rooms <- fread(CSV_ROOM_WORLD_ONE_COORDINATE_PATH)
  } else if (world_id == 2) {
    rooms <- fread(CSV_ROOM_WORLD_TWO_COORDINATE_PATH)
  } else{
    print("Wrong world_id provided")
    return()
  }
  
  # Sort room coordinates : x1<x2,y1<y2
  # Room coordinates MUST be presorted by z to work correctly with traj2graph!
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
  
  return(rooms)
}



# Loads all .csv files contained in the CSV_TRAJECTORIES_FOLDER_PATH specified directory
# Returns a list of data tables of the csv files
loadCompleteTrajectorieDataset <- function() {
  fileNames <-
    list.files(path = CSV_TRAJECTORIES_FOLDER_PATH,
               pattern = ".csv",
               full.names = TRUE)
  
  ## Read data using fread
  readdata <- function(fn) {
    dt_temp <- fread(fn, sep = ",")
    return(dt_temp)
  }
  ## List containing all data tables
  mylist <- lapply(fileNames, readdata)
  return(mylist)
}

# Loads all .csv files in CSV_TRAJECTORIES_FOLDER_PATH matching "*minecraft_pos_log_VP.*_Tag#_neu.csv", where # = {1,2}
loadTrajectoryByDay <- function(day) {
  fileNames <-
    list.files(path = CSV_TRAJECTORIES_FOLDER_PATH,
               pattern = ".csv",
               full.names = TRUE)
  # Filter files by day
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
    # Don't append an ID or similar here..just creats a bunch of problems on it's own...
    trajectoryData[[key]] = value 
    # maybe names(mylist) <- c(VP1..VPi..VPn) is more robust/faster?
  }
  return(trajectoryData)
}


loadTrajectorieByPersonIDAndDay <- function(id, day) {
  fileNamesList <-
    list.files(path = CSV_TRAJECTORIES_FOLDER_PATH,
               pattern = ".csv",
               full.names = TRUE)
  trajectory <- loadCompleteTrajectorieDataset()
  
  if (id == 0 || day == 0) {
    return()
  }
  
  if (day == 1) {
    index <- ((id * 2) - 1)
  } else if (day == 2) {
    index <- (id * 2)
  }
  else{
    print('Wrong day provided')
  }
  fileName <- fileNamesList[[index]]
  
  if (nchar(id) == 1) {
    id = paste('0', id, sep = "")
  }
  
  idToCheck <- (paste('VP', id, sep = ""))
  dayToCheck <- (paste('Tag', day, sep = ""))
  
  
  if (grepl(idToCheck, fileName) & grepl(dayToCheck, fileName)) {
    trajectoryFileForIDandDay = trajectory[[index]]
    
  } else{
    print('ID and date enteres doesn´t correspond to the filename of the csv')
  }
  
  return(trajectoryFileForIDandDay)
}


#trajec <- c(loadTrajectorieByPersonIDAndDay(1,1),loadTrajectorieByPersonIDAndDay(11,2),loadTrajectorieByPersonIDAndDay(03,2))
