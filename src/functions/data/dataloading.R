# PATH DECLARATIONS
CSV_TRAJECTORIES_FOLDER_PATH <- "./res/position_data/"
CSV_PERSONS_FOLDER_PATH <-
  ("./res/person_data/minecraft_all_subjects.xlsx")
CSV_ROOM_WORLD_ONE_COORDINATE_PATH <- ("./res/room_data/SortedRooms_V1.0.csv")
CSV_ROOM_WORLD_TWO_COORDINATE_PATH <- ("")


# Loads the dataset containing all persons attributes into a data table
loadPersonsDataset <- function() {
  persons <- as.data.table(read_excel(CSV_PERSONS_FOLDER_PATH))
  return(persons)
}

# Loads a dataframe which contains the coordinates of the rooms in the minecraft world one
loadRoomsDefinitionWorldOne <- function() {
  roomsWorldOne <- fread(CSV_ROOM_WORLD_ONE_COORDINATE_PATH)
  return(roomsWorldOne)
}


# Loads a dataframe which contains the coordinates of the rooms in the minecraft world two
loadRoomsDefinitionWorldTwo <- function() {
  rooms <- fread(CSV_ROOM_WORLD_TWO_COORDINATE_PATH)
  return(rooms)
}




loadTrajectorieDataset <- function() {
  #tempNames = list.files(path=CSV_TRAJECTORIES_FOLDER_PATH, pattern="*.csv")
  #myfiles = lapply(tempNames, fread)
  #trajectorie <- fread(csv_test_trajectories_path)
  
  all.files <- list.files(path = CSV_TRAJECTORIES_FOLDER_PATH,pattern = ".csv",full.names= TRUE)
  
  ## Read data using fread
  readdata <- function(fn){
    dt_temp <- fread(fn, sep=",")
    #keycols <- c("VP")
    #setkeyv(dt_temp,keycols)  # Notice there's a "v" after setkey with multiple keys
    return(dt_temp)
    
  }
  mylist <- lapply(all.files, readdata)
  
  
  return(mylist)
}



loadTrajectorieDataset()