#library(readr)
library(readxl)
library(data.table)
library(stringr)


# PATH DECLARATIONS
CSV_TRAJECTORIES_FOLDER_PATH <- "./res/position_data/"
CSV_PERSONS_FOLDER_PATH <-
  ("./res/person_data/minecraft_all_subjects.xlsx")
CSV_ROOM_WORLD_ONE_COORDINATE_PATH <- ("./res/SortedRooms_V1.0.csv")
CSV_ROOM_WORLD_TWO_COORDINATE_PATH <- ("")


# Loads the dataset containing all persons attributes
loadPersonsDataset <- function() {
  persons <- as.data.table(read_excel(CSV_PERSONS_FOLDER_PATH))
  persons[is.na(firstVR), "firstVR"] = -1
  persons[is.na(VE_Day2), "VE_Day2"] = -1
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


# Loads 
loadTrajectorieDataset <- function() {
  file_list <-
    list.files(path = CSV_TRAJECTORIES_FOLDER_PATH, pattern = "*.csv")
  # read in each .csv file in file_list and create a data frame with the same name as the .csv file
  for (i in 1:length(file_list)) {
    assign(file_list[i], fread(paste(
      CSV_TRAJECTORIES_FOLDER_PATH, file_list[i], sep = ''
    )))
    # get the test persons id
    tpID = as.numeric(substr(
      file_list[i],
      str_locate(file_list[i], regex("VP", ignore_case = TRUE)) + 2,
      str_locate(file_list[i], regex("VP", ignore_case = TRUE)) +
        3
    ))
    # get the test day id
    day = as.numeric(substr(
      file_list[i],
      str_locate(file_list[i], regex("Tag", ignore_case = TRUE)) + 3,
      str_locate(file_list[i], regex("Tag", ignore_case = TRUE)) +
        3
    ))
    if (day == 1 & as.numeric(persons[VP == tpID]$firstVR) == 1) {
      #assig(traj2graph( ) # ToDo: fix me harder!
    } else if (day == 2  &
               as.numeric(persons[VP == tpID]$VE_Day2) == 1) {
      #get(file_list[i]) # pass me to a function and give me the right world as well!
    }
    
  }
  
}








# Load into list: might be practical later
# trajectorieFilenames <- list.files(csv_trajectories_folder_path, pattern="*.csv", full.names=TRUE)
# listTrajectories <- lapply(trajectorieFilenames,fread)



