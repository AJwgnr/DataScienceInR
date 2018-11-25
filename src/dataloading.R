#library(readr)
library(readxl)
library(data.table)


csv_trajectories_folder_path  <- "../res/position_data/"
csv_persons_folder_path <-
  ("../res/person_data/minecraft_all_subjects.xlsx")
csv_room_coordinates_path <-
  ("../res/RoomsV1.0.csv")
# Load data...
rooms <- fread(csv_room_coordinates_path)



# #Load datasets
persons <- as.data.table(read_excel(csv_persons_folder_path))
persons[is.na(firstVR), "firstVR"] = -1
persons[is.na(VE_Day2), "VE_Day2"] = -1

# Load into list: might be practical later
# trajectorieFilenames <- list.files(csv_trajectories_folder_path, pattern="*.csv", full.names=TRUE)
# listTrajectories <- lapply(trajectorieFilenames,fread)

source("traj2graph.R")

file_list <-
  list.files(path = csv_trajectories_folder_path, pattern = "*.csv")
# read in each .csv file in file_list and create a data frame with the same name as the .csv file
for (i in 1:length(file_list)) {
  assign(file_list[i], fread(paste(
    csv_trajectories_folder_path, file_list[i], sep = ''
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
    assig(traj2graph( ) # ToDo: fix me harder!
  } else if (day == 2  &
             as.numeric(persons[VP == tpID]$VE_Day2) == 1) {
    #get(file_list[i]) # pass me to a function and give me the right world as well!
  }
  
}
