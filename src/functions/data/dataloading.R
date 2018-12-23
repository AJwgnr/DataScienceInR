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


# Loads all .csv files contained in the CSV_TRAJECTORIES_FOLDER_PATH specified directory
# Returns a list of data tables of the csv files
loadCompleteTrajectorieDataset <- function() {
  fileNames <- list.files(path = CSV_TRAJECTORIES_FOLDER_PATH,pattern = ".csv",full.names= TRUE)
  
  ## Read data using fread
  readdata <- function(fn){
    dt_temp <- fread(fn, sep=",")
    return(dt_temp)
  }
  ## List containing all data tables 
  mylist <- lapply(fileNames, readdata)
  return(mylist)
}


loadTrajectorieByPersonIDAndDay <- function(id, day){
  fileNamesList <- list.files(path = CSV_TRAJECTORIES_FOLDER_PATH,pattern = ".csv",full.names= TRUE)
  trajectory <- loadCompleteTrajectorieDataset()
  
  if(id ==0 || day==0){
    return()
  }
  
  
  if (day == 1) {
    index <-((id*2)-1)
  }else if(day == 2) {
    index <-(id*2)
    }
    else{
      print('Wrong day provided')
    }
  fileName <- fileNamesList[[index]]

  if(nchar(id) == 1){
    id = paste('0',id,sep="")
  }
  
  idToCheck <- (paste('VP',id,sep=""))
  dayToCheck <- (paste('Tag',day,sep=""))
  
  
  if(grepl(idToCheck,fileName) & grepl(dayToCheck,fileName)){
    trajectoryFileForIDandDay = trajectory[[index]]
    
  }else{
    print('ID and date enteres doesn´t correspond to the filename of the csv')
    print('ID and date enteres doesn´t correspond to the filename of the csv')
  }
  
  return(trajectoryFileForIDandDay)
}


trajec <- c(loadTrajectorieByPersonIDAndDay(1,1),loadTrajectorieByPersonIDAndDay(11,2),loadTrajectorieByPersonIDAndDay(03,2))

