#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# include everything once
source("include.R")



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
  
  # Load trajectorie data for day one into key value like list
  trajectoryDataDayOne = loadTrajectoryByDay(1)
  trajectoryDataDayTwo = loadTrajectoryByDay(2)
  
  # Load room coordinates of VR1.0/1 and VR2.0
  # ( TODO: sorts and transforms coordinates to respective world)
  roomCoordinatesVR1.0 = loadRoomsDefinitionWorld(1)
  roomCoordinatesVR2.0 = loadRoomsDefinitionWorld(2)
  
  ###################
  #### Precompute ###
  ###################
  
  # function is currently in traj2graph.R may be put into preComputation,dataLoading...
  # list containing roomGraphData similar to trajectoryDataDayOne
  # COMMENT THE NEXT TWO LINES TO RUN CODE OR FIX traj2graph.R
  roomGraphDataDayOne = computeRoomGraphByDay(1,personsDataTable,trajectoryDataDayOne,roomCoordinatesVR1.0,roomCoordinatesVR2.0)
  roomGraphDataDayTwo = computeRoomGrahpByDay(2,personsDataTable,trajectoryDataDayTwo,roomCoordinatesVR1.0,roomCoordinatesVR2.0)
  #traj2graph works and returns [room<ID>,timeSpent<sec>]
  #computeRoomGraphByDay dosen't work. should return list similar to trajectoryDataDay[One,Two] (with VP as index)
  #roomGraph2roomHist dosen't work. should return list with room ID and TOTAL time spent within
  
  
  # Compute roomgraph for each trajectory/person
  
  # Compute roomtime for each trajectory/person
  
  ###################
  ###   Features  ###
  ###################
  
  # Compute features for each person based on trajectory and roomGraph/Time
  
  ###################
  ### Clustering? ###
  ###################
  
  # Use time normalized room coordinates as feature vector
  
  ###################
  ### DecisionTree###
  ###################
  
  ###################
  ###   Plotting  ###
  ###################
  
  # Plot personsDataTable as table
  
  # debug text output for various stuff
  # put as gxElement into ui.R: verbatimTextOutput("value")
  # output$value <- renderText({ input$<whateveryouwish> })
  
  output$gx_DT_personsDataTable <-
    DT::renderDataTable(
      personsDataTable[, c(1, as.integer(input$id_pickerInputDTpersonsRaw)), with = FALSE],
      # with = FALSE need for DT version <= 1.96
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
  
  
  ### TODO: abstract plotting into functions -> currently exact same plotting is done for day one and two...
  output$gx_3d_trajectoryDayOne <- renderPlotly({
    selectedPersons = input$gx_DT_personsDataTable_rows_selected
    if (length(selectedPersons)) {
      # create colorscale
      n = nrow(trajectoryDataDayOne[[personsDataTable[selectedPersons, VP]]])
      sRl = input$colorInput_dayOne[1]
      sRh = input$colorInput_dayOne[2]
      leadingZeros = floor((sRl/100) * n)
      trailingZeros = n - floor((sRh / 100) * n)
      shade = c(array(0, leadingZeros), seq(0, n,length.out = n - leadingZeros- trailingZeros), array(0,trailingZeros))
      print(shade)
      # FIXME : shade dosen't work at all
      # TODO: highligth room geometry, fix aspec ratio, colorcode time, provide slider input
      plot_ly() %>% add_trace(
        data = trajectoryDataDayOne[[personsDataTable[selectedPersons, VP]]],
        type = "scatter3d",
        x = ~ x,
        y = ~ y,
        z = ~ z,
        line = list(
          width = 6,
          color = shade,
          #array(0,c(3,5))
          reverscale = FALSE
        ),
        mode = 'lines',
        # FIXME (colorbar,colorscale not attributes of scatter3d)
        colorbar=list(
          title='Colorbar'
        ),
        colorscale='Viridis'
      )
    }
    
  })
  
  
  output$gx_3d_trajectoryDayTwo <- renderPlotly({
    selectedPersons = input$gx_DT_personsDataTable_rows_selected
    if (length(selectedPersons)) {
      # TODO: highligth room geometry, fix aspec ratio, colorcode time, provide slider input
      plot_ly() %>% add_trace(
        data = trajectoryDataDayTwo[[personsDataTable[selectedPersons, VP]]],
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
