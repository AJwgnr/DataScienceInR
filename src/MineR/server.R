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
library(dtplyr)
library(readxl)
library(stringr)
library(DT)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  ###################
  ###    Source   ###
  ###################
  # Source the function written in various files:
  source("../functions/data/dataloading.R")
  
  ###################
  ###    Load     ###
  ###################
  
  # Load all stored data
  personsDataTable <- loadPersonsDataset()
  
  ###################
  #### Precompute ###
  ###################
  
  # Compute roomgraph for each trajectory/person
  
  # Compute roomtime for each trajectory/person
  
  ###################
  ###   Features  ###
  ###################
  
  # Compute features for each person based on trajectory and roomGraph/Time
  
  ###################
  ### Clustering? ###
  ###################
  
  ###################
  ### DecisionTree###
  ###################
  
  ###################
  ###   Plotting  ###
  ###################
  
  # Plot personsDataTable as table
  output$gx_DT_personsDataTable <-
    DT::renderDataTable(
      personsDataTable,
      options = list(
        scrollX = TRUE,
        scrollY = 350,
        pageLength = -1
      ),
      selection = "single"
    )
  
  # roomGraphDayOne = renderPrint({
  #   selectedPersons = input$gx_DT_personsDataTable_rows_selected
  #   if (length(selectedPersons)) {
  #     # ToDo: invoke traj2graph and compute the roooms visited
  #   }
  # })
  
  output$plot <- renderPlotly({
    if (FALSE) {
      plot_ly(mtcars, x = ~ mpg, y = ~ wt)
    }
    
  })
  
  output$gx_3d_trajectoryDayOne <- renderPlotly({
    selectedPersons = input$gx_DT_personsDataTable_rows_selected
    if (length(selectedPersons)) {
      print(selectedPersons)
      print(personsDataTable[selectedPersons, VP])
      # ToDo: invoke traj2graph and compute the roooms visited
      selectedPersonTrajectoryDayOne <-
        loadTrajectorieByPersonIDAndDay(personsDataTable[selectedPersons, VP], 1)
      plot_ly() %>% add_trace(
        data = selectedPersonTrajectoryDayOne,
        type = "scatter3d",
        x = ~ x,
        y = ~ y,
        z = ~ z,
        line = list(
          width = 6,
          color = ~ z,
          reverscale = FALSE
        ),
        mode = 'lines'
      )
    }
    
  })
  
  
  output$gx_3d_trajectoryDayTwo <- renderPlotly({
    selectedPersons = input$gx_DT_personsDataTable_rows_selected
    if (length(selectedPersons)) {
      print(selectedPersons)
      print(personsDataTable[selectedPersons, VP])
      # ToDo: invoke traj2graph and compute the roooms visited
      selectedPersonTrajectoryDayTwo <-
        loadTrajectorieByPersonIDAndDay(personsDataTable[selectedPersons, VP], 2)
      plot_ly() %>% add_trace(
        data = selectedPersonTrajectoryDayTwo,
        type = "scatter3d",
        x = ~ x,
        y = ~ y,
        z = ~ z,
        line = list(
          width = 6,
          color = ~ z,
          reverscale = FALSE
        ),
        mode = 'lines'
      )
    }
    
  })
  
  
  # # Fix this shit later!
  # output$histTimeRoomsDayOne <-
  #   renderPlotly({
  #     plot_ly() %>% add_bars(data = unique(rooms[, c("id", "TimeSpent")]),
  #                            y =  ~ TimeSpent,
  #                            x =  ~ names)
  #   })
  #
  # output$histTimeRoomsDayOne <-
  #   renderPlotly({
  #     plot_ly() %>% add_bars(data = unique(rooms[, c("id", "TimeSpent")]),
  #                            y =  ~ TimeSpent,
  #                            x =  ~ names)
  #   })
  #
  
  
  
})
