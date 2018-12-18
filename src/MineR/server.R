#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

# only includes in ui.R neccessary?
library(shiny)
library(shinydashboard)
library("rgl")
library("car")
library("data.table")
library("plotly")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
######################################################################################################
###***********************************************************************************************####
### COPIED FOLLOWING CODE FROM trjectoryToGraphs.R NEEDS REFACTORING    (bad between *** and ===) ####
###***********************************************************************************************####
######################################################################################################
  
  # Path to dataSet
  # ToDo: adapt to use test persons world ID for correct room file
  csv_room_coordinates_path <-
    ("../../res/SortedRooms_V1.0.csv")
  csv_test_trajectories_path <-
    ("../../res/position_data/DEBUGFILENODATA_V1.csv")
  
  # Load data...
  rooms <- fread(csv_room_coordinates_path)
  trajectorie <- fread(csv_test_trajectories_path)
  
  # Swap x and y coordinates to make the left one the smaller one
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
  
  # Convert Minecraft Coordinates to Python Coordinates V1.0
  #############
  ### V 1.0 ###
  #############
  rooms$z  = rooms$z  - 72
  rooms$x1 = rooms$x1 - 249
  rooms$x2 = rooms$x2 - 249
  rooms$y1 = rooms$y1 - 227
  rooms$y2 = rooms$y2 - 227
  #############
  ### V 2.0 ###
  #############
  # rooms$z  = rooms$z  - 64
  # rooms$x1 = rooms$x1 - 64
  # rooms$x2 = rooms$x2 - 64
  # rooms$y1 = rooms$y1 - 188
  # rooms$y2 = rooms$y2 - 188
  ############
  
  trajectorie$Room = -1
  for (rows in 1:nrow(rooms)) {
    condition <-
      (
        trajectorie$x >= rooms[rows, x1] &
          trajectorie$x <= rooms[rows, x2] &
          trajectorie$y >= rooms[rows, y1] &
          trajectorie$y <= rooms[rows, y2] &
          # ToDo: Confirm right handlig of height
          trajectorie$z >= rooms[rows, z] - 1# &trajectorie$z <= rooms[rows, z] + 4
      )
    trajectorie[condition == TRUE, "Room"] = rooms[rows, "id"]
    trajectorie[condition == TRUE, "RoomHeight"] = rooms[rows, "z"]
  }
  # Summarize into roomGraph
  trajectorie$rleid = rleid(trajectorie$Room)
  roomGraph = unique(trajectorie[, list(TimeSpent = .N * 0.1, Room, rleid), trajectorie$rleid]) # 0.1 sec spentd per trajectory row/timestemp
  
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
  
  
  
  ######################################################################################################
  ###===============================================================================================####
  ### COPIED ABOVE CODE FROM trjectoryToGraphs.R NEEDS REFACTORING  (bad between *** and ===)       ####
  ###===============================================================================================####
  ######################################################################################################
  
  ### Here the plotting starts
  
  # Fix this shit later!
  output$histTimeRooms <-renderPlotly({plot_ly()%>%add_bars(data=unique(rooms[,c("id","TimeSpent")]),y=~TimeSpent,x=~names)}) 
  
  output$trj3d <- renderRglwidget({
    rgl.open(useNULL=T)
    x<-trajectorie$x;
    y<-trajectorie$y;
    z<-trajectorie$z;
    scatter3d(x,z,y,point.col=c(1,2,3,4,5,6,7),surface = FALSE);
    rglwidget()
  })
  
  
})
