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

  

shinyServer(function(input, output, session) {

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
  
  
  
  
  
  adhdChildren <- personsDataTable[personsDataTable$ADHD_Subtype>0]
  healthyChildren <- personsDataTable[personsDataTable$ADHD_Subtype==0]
  
  
  # Extract persons with respect 
  # Persons that have only seen the same world twice
  sameWorld <- personsDataTable[personsDataTable$Novelty == 1]
  sameWorldADHD <- sameWorld[sameWorld$ADHD_Subtype > 0 ] 
  sameWorldHealthy <- sameWorld[sameWorld$ADHD_Subtype == 0 ] 
  
  # Persons that have seen a new world
  newWorld <- personsDataTable[personsDataTable$Novelty == 2]
  newWorldADHD <- newWorld[newWorld$ADHD_Subtype > 0]
  newWorldHealthy <- newWorld[newWorld$ADHD_Subtype == 0]
  
  # Persons that have seen a partial new world (different color)
  partialNewWorld <- personsDataTable[personsDataTable$Novelty == 3]
  partialNewWorldADHD <- partialNewWorld[partialNewWorld$ADHD_Subtype > 0]
  partialNewWorldHealthy <- partialNewWorld[partialNewWorld$ADHD_Subtype == 0]
  
  
  
  
  ###################
  #### Precompute ###
  ###################
  
  # function is currently in traj2graph.R may be put into preComputation,dataLoading...
  # list containing roomGraphData similar to trajectoryDataDayOne
  # COMMENT THE NEXT TWO LINES TO RUN CODE OR FIX traj2graph.R
  #roomGraphDataDayOne = computeRoomGraphByDay(1,personsDataTable,trajectoryDataDayOne,roomCoordinatesVR1.0,roomCoordinatesVR2.0)
  #roomGraphDataDayTwo = computeRoomGrahpByDay(2,personsDataTable,trajectoryDataDayTwo,roomCoordinatesVR1.0,roomCoordinatesVR2.0)
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
      personsDataTable[, c(1, as.integer(input$id_pickerInputDTpersonsRaw1)), with = FALSE],
      # with = FALSE need for DT version <= 1.96
      options = list(
        scrollX = TRUE,
        scrollY = 350,
        pageLength = -1
      ),
      selection = "single"
    )
  
  output$gx_splom_personsDataTable <- renderPlotly({
    d <-
      SharedData$new(personsDataTable[, as.integer(input$id_pickerInputDTpersonsRaw1), with = FALSE])
    p <- GGally::ggpairs(d)
    highlight(ggplotly(p), on = "plotly_selected") # plotly function highlighting using ggplotly to convert ggplot_plot to plotly_plot
  })
  
  # roomGraphDayOne = renderPrint({
  #   selectedPersons = input$gx_DT_personsDataTable_rows_selected
  #   if (length(selectedPersons)) {
  #     # ToDo: invoke traj2graph and compute the roooms visited
  #   }
  # })
  
  ###################################################################################### 
  #Memorizing Value Boxes
  ######################################################################################
  output$wordsValueBox <- renderValueBox({
    valueBox(20, "Words to memorize", icon = icon("credit-card"))
  })
  output$avgDirectRecallBox <- renderValueBox({
    valueBox(10 * 2, "Average Direct Recall", icon = icon("credit-card"))
  })
  output$avgDelayedRecallBox <- renderValueBox({
    valueBox(10 * 2, "Average Delayed Recall", icon = icon("credit-card"))
  })
  output$sameWorldBox <- renderValueBox({
    valueBox(paste(round((nrow(sameWorld)/nrow(personsDataTable))*100,2), '%'), "Patient same world", icon = icon("percent"), color = 'green')
  })
  output$newWorldBox <- renderValueBox({
    valueBox(paste(round((nrow(newWorld)/nrow(personsDataTable))*100,2), ' %'), "Patient new world", icon = icon("percent"), color = 'green')
  })
  output$partialNewWorldBox <- renderValueBox({
    valueBox(paste(round((nrow(partialNewWorld)/nrow(personsDataTable))*100,2), '%'), "Patient Partial new world", icon = icon("percent"), color = 'yellow')
  })
  
  output$sameTyp0 <- renderValueBox({
    valueBox(width = 1, nrow(sameWorldHealthy), "Type 0", icon = icon("percent"))
  })
  output$sameTyp1 <- renderValueBox({
    valueBox(width = 1,10 * 2, "Type 1", icon = icon("percent"))
  })
  output$sameTyp2 <- renderValueBox({
    valueBox(width = 1,10 * 2, "Type 2", icon = icon("percent"))
  })
  output$sameTyp3 <- renderValueBox({
    valueBox(width = 1,20, "Type 3", icon = icon("percent"))
  })
  output$newTyp0 <- renderValueBox({
    valueBox(width = 1,nrow(newWorldHealthy), "Type 0", icon = icon("percent"))
  })
  output$newTyp1 <- renderValueBox({
    valueBox(width = 1,10 * 2, "Type 1", icon = icon("percent"))
  })
  output$newTyp0 <- renderValueBox({
    valueBox(width = 1, 20, "Type 0", icon = icon("percent"))
  })
  output$newTyp1 <- renderValueBox({
    valueBox(width = 1,20, "Type 1", icon = icon("percent"))
  })
  output$newTyp2 <- renderValueBox({
    valueBox(width = 1, 20, "Type 2", icon = icon("percent"))
  })
  output$newTyp3 <- renderValueBox({
    valueBox(width = 1,10 * 2, "Type 3", icon = icon("percent"))
  })
  output$paritalNewTyp0 <- renderValueBox({
    valueBox(width = 1,nrow(partialNewWorldHealthy), "Type 0", icon = icon("percent"))
  })
  output$paritalNewTyp1 <- renderValueBox({
    valueBox(width = 1,20, "Type 1", icon = icon("percent"))
  })
  output$paritalNewTyp2 <- renderValueBox({
    valueBox(width = 1,10 * 2, "Type 2", icon = icon("percent"))
  })
  output$paritalNewTyp3 <- renderValueBox({
    valueBox(width = 1,10 * 2, "Type 3", icon = icon("percent"))
  })
  
  ###################################################################################### 
  #Memorizing Boxplots
  ###################################################################################### 
  output$boxplotOverall <- renderPlotly({
  
  plot_ly(
    y = adhdChildren$TP_DirectRecall,
    name = 'ADHD TP_Direct',
    type = 'box',
    boxpoints = 'all',
    jitter = 0.3,
    pointpos = -1.8
  ) %>%
    add_trace(y = healthyChildren$TP_DirectRecall  , name = 'Healthy TP_Direct ') %>%
    add_trace(y = adhdChildren$TP_DelayedRecall, name = 'ADHD TP_Delayed') %>%
    add_trace(y = healthyChildren$TP_DelayedRecall, name =
                'Healthy TP_Delayed')
  
  })

  output$boxplotSameWorld <- renderPlotly({
    plot_ly(
      y = sameWorldADHD$TP_DirectRecall,
      name = ' SameWorld TP_Direct (ADHD)' ,
      type = "box",
      boxpoints = "all",
      jitter = 0.3,
      pointpos = -1.8
    ) %>%
      add_trace(y = sameWorldHealthy$TP_DirectRecall, name = ' SameWorld TP_Direct (Healthy)') %>%
      add_trace(y = sameWorldADHD$TP_DelayedRecall, name = ' SameWorld TP_Delayed (ADHD)') %>%
      add_trace(y = sameWorldHealthy$TP_DelayedRecall, name = ' SameWorld TP_Delayed (Healthy)')

  })

  output$boxplotNewWorld <- renderPlotly({
    plot_ly(
      y = newWorldADHD$TP_DirectRecall,
      name = ' NewWorld TP_Direct (ADHD)' ,
      type = "box",
      boxpoints = "all",
      jitter = 0.3,
      pointpos = -1.8
    ) %>%
      add_trace(y = newWorldHealthy$TP_DirectRecall, name = ' NewWorld TP_Direct (Healthy)') %>%
      add_trace(y = newWorldADHD$TP_DelayedRecall, name = ' NewWorld TP_Delayed (ADHD)') %>%
      add_trace(y = newWorldHealthy$TP_DelayedRecall, name = ' NewWorld TP_Delayed (Healthy)')
  })
  
  output$boxplotPartialNewWorld <- renderPlotly({
    
    plot_ly(
      y = partialNewWorldADHD$TP_DirectRecall,
      name = ' PartialNewWorld TP_Direct (ADHD)' ,
      type = "box",
      boxpoints = "all",
      jitter = 0.3,
      pointpos = -1.8
    ) %>%
      add_trace(y = partialNewWorldHealthy$TP_DirectRecall, name = ' PartialNewWorld TP_Direct (Healthy)') %>%
      add_trace(y = partialNewWorldADHD$TP_DelayedRecall, name = ' PartialNewWorld TP_Delayed (ADHD)') %>%
      add_trace(y = partialNewWorldHealthy$TP_DelayedRecall, name = ' PartialNewWorld TP_Delayed (Healthy)')

  })
  
  
  ### TODO: abstract plotting into functions -> currently exact same plotting is done for day one and two...
  output$gx_3d_trajectoryDayOne <- renderPlotly({
    selectedPersons = input$gx_DT_personsDataTable_rows_selected
    print(selectedPersons)
    if (length(selectedPersons)) {
      # create colorscale
      n = nrow(trajectoryDataDayOne[[personsDataTable[selectedPersons, VP]]])
      sRl = input$colorInput_dayOne[1]
      sRh = input$colorInput_dayOne[2]
      leadingZeros = floor((sRl / 100) * n)
      trailingZeros = n - floor((sRh / 100) * n)
      shade = c(
        array(0, leadingZeros),
        seq(0, n, length.out = n - leadingZeros - trailingZeros),
        array(0, trailingZeros)
      )
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
        colorbar = list(title = 'Colorbar'),
        colorscale = 'Viridis'
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
  
  
  # Couple id_pickerInputDTpersonsRaw1 and id_pickerInputDTpersonsRaw2 to show same selection of cols and update each other
  
  # If picker1 changes update picker
  observe({
    x <- input$id_pickerInputDTpersonsRaw1
    updatePickerInput(session, "id_pickerInputDTpersonsRaw2", selected = x)
  })
  # Vice versa
  observe({
    y <- input$id_pickerInputDTpersonsRaw2
    updatePickerInput(session, "id_pickerInputDTpersonsRaw1", selected = y)
  })
  
  
})
