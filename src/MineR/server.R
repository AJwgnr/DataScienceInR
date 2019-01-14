# Source the librarys to include
source("include.R")

# Source the functions for data preprocessing
source("../functions/data/dataloading.R")
source("../functions/transformation/traj2graph.R")

shinyServer(function(input, output, session) {
  ##########################
  #### Load & Precompute ###
  ##########################
  
  # Load all stored person data
  personsDataTable <- loadPersonsDataset()
  
  # Load trajectorie data for day one and day two into a key value like list
  trajectoryDataDayOne <-  loadTrajectoryByDay(1)
  trajectoryDataDayTwo <-  loadTrajectoryByDay(2)
  
  # Load room coordinates of the virtual worlds
  roomCoordinatesVR1.0 <-  loadRoomsDefinitionWorld(1)
  roomCoordinatesVR2.0 <-  loadRoomsDefinitionWorld(2)
  
  # Precomputes the visited rooms and also the spent time for each day for each trajectorie using a csv. file where the "rooms" of the worlds are provided
  # Creates a histogram of the visited rooms/with spent time for each day for each trajectorie
  roomGraphDataDayOne <-  loadRoomGraphByDay(1,personsDataTable,trajectoryDataDayOne,roomCoordinatesVR1.0,roomCoordinatesVR2.0)
  roomGraphDataDayTwo <-  loadRoomGraphByDay(2,personsDataTable,trajectoryDataDayTwo,roomCoordinatesVR1.0,roomCoordinatesVR2.0)
  roomHistDayOne <-  loadRoomHistByDay(1,personsDataTable,roomGraphDataDayOne,roomCoordinatesVR1.0,roomCoordinatesVR2.0)
  roomHistDayTwo <-  loadRoomHistByDay(2,personsDataTable,roomGraphDataDayTwo,roomCoordinatesVR1.0,roomCoordinatesVR2.0)
  
  # Precompute a list of all trajectories of the two test day for each world
  roomHistWorldOneList <- append(roomHistDayOne[personsDataTable[personsDataTable[,firstVR==1], VP]] ,roomHistDayTwo[personsDataTable[personsDataTable[,VE_Day2==1], VP]])
  roomHistWorldTwoList <- append(roomHistDayOne[personsDataTable[personsDataTable[,firstVR==2], VP]] ,roomHistDayTwo[personsDataTable[personsDataTable[,VE_Day2==2], VP]])
  roomHistWorldThreeList <- append(roomHistDayOne[personsDataTable[personsDataTable[,firstVR==3], VP]] ,roomHistDayTwo[personsDataTable[personsDataTable[,VE_Day2==3], VP]])
  
  # Adds all trajectories from one world together
  worldOne <- do.call('rbind',roomHistWorldOneList)
  worldTwo <- do.call('rbind',roomHistWorldTwoList)
  worldThree <- do.call('rbind',roomHistWorldThreeList)
  
  # Aggregates all trajectories based on the ID (calculates SpentTime)
  worldOneAggregatedRooms <- worldOne[, list(TimeSpent = sum(TimeSpent), Entries= sum(Entries)), by = ID]
  worldTwoAggregatedRooms <- worldTwo[, list(TimeSpent = sum(TimeSpent), Entries= sum(Entries)), by = ID]
  worldThreeAggregatedRooms <- worldThree[, list(TimeSpent = sum(TimeSpent), Entries= sum(Entries)), by = ID]
  
  
  # Filter persons data table for adhd childs and the control group
  adhdChildren <-
    personsDataTable[personsDataTable$ADHD_Subtype > 0]
  controlGroup <-
    personsDataTable[personsDataTable$ADHD_Subtype == 0]
  
  # Extract persons with respect to the experiment and the type of ADHD or control group
  # personsDataTable$Novelty == 1 -> Persons have seen the same world twice
  sameWorld <- personsDataTable[personsDataTable$Novelty == 1]
  sameWorldADHD <- sameWorld[sameWorld$ADHD_Subtype > 0]
  sameWorldADHD1 <- sameWorld[sameWorld$ADHD_Subtype == 1]
  sameWorldADHD2 <- sameWorld[sameWorld$ADHD_Subtype  == 2]
  sameWorldADHD3 <- sameWorld[sameWorld$ADHD_Subtype  == 3]
  sameWorldControl <- sameWorld[sameWorld$ADHD_Subtype == 0]
  
  # personsDataTable$Novelty == 2 -> Persons have seen two different worlds
  newWorld <- personsDataTable[personsDataTable$Novelty == 2]
  newWorldADHD <- newWorld[newWorld$ADHD_Subtype > 0]
  newWorldADHD1 <- newWorld[newWorld$ADHD_Subtype == 1]
  newWorldADHD2 <- newWorld[newWorld$ADHD_Subtype == 2]
  newWorldADHD3 <- newWorld[newWorld$ADHD_Subtype == 3]
  newWorldControl <- newWorld[newWorld$ADHD_Subtype == 0]
  
  # personsDataTable$Novelty == 3 -> Persons have seen the second time a partial new world (diffrent color of Mansion world)
  partialNewWorld <- personsDataTable[personsDataTable$Novelty == 3]
  partialNewWorldADHD <-
    partialNewWorld[partialNewWorld$ADHD_Subtype > 0]
  partialNewWorldADHD1 <-
    partialNewWorld[partialNewWorld$ADHD_Subtype == 1]
  partialNewWorldADHD2 <-
    partialNewWorld[partialNewWorld$ADHD_Subtype == 2]
  partialNewWorldADHD3 <-
    partialNewWorld[partialNewWorld$ADHD_Subtype == 3]
  partialNewWorldControl <-
    partialNewWorld[partialNewWorld$ADHD_Subtype == 0]

  ###################
  ###   Features  ###
  ###################
  
  # Compute features for each person based on trajectory and roomGraph/Time
  # We need to use PCA at some point I'd guess;)
  
  ###################
  ### Clustering? ###
  ###################
  
  # Use time normalized room coordinates as feature vector
  
  ###################
  ### DecisionTree###
  ###################
  
 
  ###****************************************************************************************************************************************************************
  ### Page 2: Raw Data Overview; table, scatterplots,
  ###****************************************************************************************************************************************************************

  ######################################################################################
  #Dataset Value Boxes
  ######################################################################################
  output$personFiles <- renderValueBox({
    valueBox(1,
             "Files",
             icon = icon("file-excel-o"),
             color = 'blue')
  })
  output$personAttributes <- renderValueBox({
    valueBox(
      ncol(personsDataTable),
      "Attributes",
      icon = icon("columns"),
      color = 'blue'
    )
  })
  output$personInstances <- renderValueBox({
    valueBox(
      nrow(personsDataTable),
      "Instances",
      icon = icon("table"),
      color = 'blue'
    )
  })
  output$trajectoryFiles <- renderValueBox({
    valueBox(
      length(trajectoryDataDayTwo)+length(trajectoryDataDayOne),
      "Files",
      icon = icon("file-excel-o"),
      color = 'blue'
    )
  })
  output$trajectoryAttributes <- renderValueBox({
    valueBox(4,
             "Attributes",
             icon = icon("columns"),
             color = 'blue')
  })
  output$trajectoryInstances <- renderValueBox({
    valueBox(7000,
             "Instances",
             icon = icon("table"),
             color = 'blue')
  })
  
  ######################################################################################
  #Person Data table Visualizations
  ######################################################################################
  
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
  
  ######################################################################################
  # Regression
  ######################################################################################
  
  output$gx_regression <- renderPlotly({
    # Problem: input is char
    p <- plot_ly()
    if(length(input$id_pickerInputRegression)==2){
    firstAttribute = as.integer(input$id_pickerInputRegression[1])
    secondAttribute = as.integer(input$id_pickerInputRegression[2])
    d = personsDataTable[,c(..firstAttribute,..secondAttribute)]
    names(d) = c("first","second")
    # This is not how it should be done...
    #fit = lm(d[union(is.na(d$first)==FALSE,is.na(d$second))==FALSE,])
    # Stupid as shit...if done before lm
    #d$first[is.na(d$first)] = 0
    #d$second[is.na(d$second)] = 0
    p <- p %>% add_markers(data=d,x=~second,y=~first)#%>%add_lines(x=~second,y=fitted(fit))
    p}
    })
  
  ######################################################################################
  # SPLOM
  ######################################################################################
  
  
  # Create scatterplot matrix from persons Data tabui
  output$gx_splom_personsDataTable <- renderPlotly({
    d <-
      SharedData$new(personsDataTable[, as.integer(input$id_pickerInputDTpersonsRaw1), with = FALSE])
    p <-
      GGally::ggpairs(d) + theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
      theme(axis.text.y = element_text(angle = 0, vjust = 1))
    p <- ggplotly(p)
    highlight(p, on = "plotly_selected") # plotly function highlighting using ggplotly to convert ggplot_plot to plotly_plot
  })
  
  
  ######################################################################################
  # Trajectory Plots
  ######################################################################################
  
  
  ### TODO: abstract plotting into functions -> currently exact same plotting is done for day one and two...
  output$gx_3d_trajectoryDayOne <- renderPlotly({
    selectedPersons = input$gx_DT_personsDataTable_rows_selected
    lower_z_filter = input$z_level[1]
    upper_z_filter = input$z_level[2]
    # get world id
    vr = personsDataTable[selectedPersons, firstVR]
    trjPlotDayOne = NULL
    if (length(selectedPersons)) {
      trjPlotDayOne <- plot_ly()
      # adapt for z sliding
      z_filtered_traj = trajectoryDataDayOne[[personsDataTable[selectedPersons, VP]]]
      z_filtered_traj = z_filtered_traj[z_filtered_traj[,(z>lower_z_filter & z<upper_z_filter)],]
      # create colorscale
      n = nrow(z_filtered_traj)
      sRl = input$colorInput[1]
      sRh = input$colorInput[2]
      leadingZeros = floor((sRl / 100) * n)
      trailingZeros = n - floor((sRh / 100) * n)
      shade = c(
        array(0, leadingZeros),
        seq(0, n, length.out = n - leadingZeros - trailingZeros),
        array(0, trailingZeros)
      )
      trjPlotDayOne <- trjPlotDayOne %>% add_trace(
        data = z_filtered_traj,
        type = "scatter3d",
        x = ~ x,
        y = ~ y,
        z = ~ z,
        line = list(
          width = 6,
          color = shade,
          reverscale = FALSE,
          colorbar = list(title = 'Colorbar for lines'),
          showlegend = TRUE,
          colorscale = 'Viridis'
        ),
        mode = 'lines'
      )
      if ((vr == 1 || vr == 3) && input$showRoomInput ) {
        # z selection must be done here
        VR1coordinates = roomCoordinatesVR1.0[roomCoordinatesVR1.0[,(z>lower_z_filter & z<upper_z_filter)],]
        trjPlotDayOne <- trjPlotDayOne %>%
          add_trace(
            data = VR1coordinates,
            type = "mesh3d",
            opacity = 0.30,
            x = c(
              VR1coordinates$x1,
              VR1coordinates$x2,
              VR1coordinates$x1,
              VR1coordinates$x2
            ),
            y = c(
              VR1coordinates$y1,
              VR1coordinates$y1,
              VR1coordinates$y2,
              VR1coordinates$y2
            ),
            z = c(
              VR1coordinates$z,
              VR1coordinates$z,
              VR1coordinates$z,
              VR1coordinates$z
            ),
            i = c(0:(nrow(
              VR1coordinates
            ) - 1), 0:(nrow(
              VR1coordinates
            ) -
              1)),
            j = c(
              nrow(VR1coordinates):(2 * nrow(VR1coordinates) - 1),
              (2 *
                 nrow(VR1coordinates)):(3 * nrow(VR1coordinates) -
                                          1)
            ),
            k = c((3 * nrow(
              VR1coordinates
            )):(4 * nrow(
              VR1coordinates
            ) - 1), (3 *
                       nrow(
                         VR1coordinates
                       )):(4 * nrow(
                         VR1coordinates
                       ) - 1))
          )
        
      } else if ((vr == 2) && input$showRoomInput) {
        # z selection must be done here to work
        VR2coordinates = roomCoordinatesVR2.0[roomCoordinatesVR2.0[,(z>lower_z_filter & z<upper_z_filter)],]
        
        trjPlotDayOne <- trjPlotDayOne %>%
          add_trace(
            data = VR2coordinates,
            type = "mesh3d",
            opacity = 0.30,
            x = c(
              VR2coordinates$x1,
              VR2coordinates$x2,
              VR2coordinates$x1,
              VR2coordinates$x2
            ),
            y = c(
              VR2coordinates$y1,
              VR2coordinates$y1,
              VR2coordinates$y2,
              VR2coordinates$y2
            ),
            z = c(
              VR2coordinates$z,
              VR2coordinates$z,
              VR2coordinates$z,
              VR2coordinates$z
            ),
            i = c(0:(nrow(
              VR2coordinates
            ) - 1), 0:(nrow(
              VR2coordinates
            ) -
              1)),
            j = c(
              nrow(VR2coordinates):(2 * nrow(VR2coordinates) - 1),
              (2 *
                 nrow(VR2coordinates)):(3 * nrow(VR2coordinates) -
                                          1)
            ),
            k = c((3 * nrow(
              VR2coordinates
            )):(4 * nrow(
              VR2coordinates
            ) - 1), (3 *
                       nrow(
                         VR2coordinates
                       )):(4 * nrow(
                         VR2coordinates
                       ) - 1))
            
          )
      } else if(input$showRoomInput){
        print("Unexpected VR ID provided in trajectory plotting")
        print(toString(vr))
      }
    }
    trjPlotDayOne
  })
  
  
  output$gx_3d_trajectoryDayTwo <- renderPlotly({
    selectedPersons = input$gx_DT_personsDataTable_rows_selected
    lower_z_filter = input$z_level[1]
    upper_z_filter = input$z_level[2]
    # get world id
    vr = personsDataTable[selectedPersons, VE_Day2]
    trjPlotDayTwo = NULL
    if (length(selectedPersons)) {
      trjPlotDayTwo <- plot_ly()
      # adapt for z sliding
      z_filtered_traj = trajectoryDataDayTwo[[personsDataTable[selectedPersons, VP]]]
      z_filtered_traj = z_filtered_traj[z_filtered_traj[,(z>lower_z_filter & z<upper_z_filter)],]
      # create colorscale
      n = nrow(z_filtered_traj)
      sRl = input$colorInput[1]
      sRh = input$colorInput[2]
      leadingZeros = floor((sRl / 100) * n)
      trailingZeros = n - floor((sRh / 100) * n)
      shade = c(
        array(0, leadingZeros),
        seq(0, n, length.out = n - leadingZeros - trailingZeros),
        array(0, trailingZeros)
      )
      trjPlotDayTwo <- trjPlotDayTwo %>% add_trace(
        data = z_filtered_traj,
        type = "scatter3d",
        x = ~ x,
        y = ~ y,
        z = ~ z,
        line = list(
          width = 6,
          color = shade,
          reverscale = FALSE,
          colorbar = list(title = 'Colorbar for lines'),
          showlegend = TRUE,
          colorscale = 'Viridis'
        ),
        mode = 'lines'
      )
      if ((vr == 1 || vr == 3) && input$showRoomInput) {
        # z selection must be done here
        VR1coordinates = roomCoordinatesVR1.0[roomCoordinatesVR1.0[,(z>lower_z_filter & z<upper_z_filter)],]
        trjPlotDayTwo <- trjPlotDayTwo %>%
          add_trace(
            data = VR1coordinates,
            type = "mesh3d",
            opacity = 0.30,
            x = c(
              VR1coordinates$x1,
              VR1coordinates$x2,
              VR1coordinates$x1,
              VR1coordinates$x2
            ),
            y = c(
              VR1coordinates$y1,
              VR1coordinates$y1,
              VR1coordinates$y2,
              VR1coordinates$y2
            ),
            z = c(
              VR1coordinates$z,
              VR1coordinates$z,
              VR1coordinates$z,
              VR1coordinates$z
            ),
            i = c(0:(nrow(
              VR1coordinates
            ) - 1), 0:(nrow(
              VR1coordinates
            ) -
              1)),
            j = c(
              nrow(VR1coordinates):(2 * nrow(VR1coordinates) - 1),
              (2 *
                 nrow(VR1coordinates)):(3 * nrow(VR1coordinates) -
                                          1)
            ),
            k = c((3 * nrow(
              VR1coordinates
            )):(4 * nrow(
              VR1coordinates
            ) - 1), (3 *
                       nrow(
                         VR1coordinates
                       )):(4 * nrow(
                         VR1coordinates
                       ) - 1))
          )
        
      } else if ((vr == 2) && input$showRoomInput) {
        # z selection must be done here to work
        VR2coordinates = roomCoordinatesVR2.0[roomCoordinatesVR2.0[,(z>lower_z_filter & z<upper_z_filter)],]
        
        trjPlotDayTwo <- trjPlotDayTwo %>%
          add_trace(
            data = VR2coordinates,
            type = "mesh3d",
            opacity = 0.30,
            x = c(
              VR2coordinates$x1,
              VR2coordinates$x2,
              VR2coordinates$x1,
              VR2coordinates$x2
            ),
            y = c(
              VR2coordinates$y1,
              VR2coordinates$y1,
              VR2coordinates$y2,
              VR2coordinates$y2
            ),
            z = c(
              VR2coordinates$z,
              VR2coordinates$z,
              VR2coordinates$z,
              VR2coordinates$z
            ),
            i = c(0:(nrow(
              VR2coordinates
            ) - 1), 0:(nrow(
              VR2coordinates
            ) -
              1)),
            j = c(
              nrow(VR2coordinates):(2 * nrow(VR2coordinates) - 1),
              (2 *
                 nrow(VR2coordinates)):(3 * nrow(VR2coordinates) -
                                          1)
            ),
            k = c((3 * nrow(
              VR2coordinates
            )):(4 * nrow(
              VR2coordinates
            ) - 1), (3 *
                       nrow(
                         VR2coordinates
                       )):(4 * nrow(
                         VR2coordinates
                       ) - 1))
            
          )
      } else if(input$showRoomInput){
        print("Unexpected VR ID provided in trajectory plotting day two")
        print(toString(vr))
      }
    }
    trjPlotDayTwo
  })
  
  
  ######################################################################################
  # Times rooms entered bar chart
  ######################################################################################
  
  output$gx_roomEntriesBarDayOne <- renderPlotly({
    selectedPersons = input$gx_DT_personsDataTable_rows_selected
    p <- plot_ly() 
    if (length(selectedPersons)) {
      p <- p %>%
        add_trace(
          data = roomHistDayOne[[personsDataTable[selectedPersons,VP]]],
          x = ~Entries,
          y = ~Name,
          name = "Entries per room",
          type = "bar",
          orientation = "h"
        )
    }
  })
  
  output$gx_roomEntriesBarDayTwo <- renderPlotly({
    selectedPersons = input$gx_DT_personsDataTable_rows_selected
    p <- plot_ly() 
    if (length(selectedPersons)) {
      p <- p %>%
        add_trace(
          data = roomHistDayTwo[[personsDataTable[selectedPersons,VP]]],
          x = ~Entries,
          y = ~Name,
          name = "Entries per room",
          type = "bar",
          orientation = "h"
        )
    }
  })
  
  ######################################################################################
  # Time Spent per Room bar charts
  ######################################################################################
  output$gx_roomHistBarDayOne <- renderPlotly({
    selectedPersons = input$gx_DT_personsDataTable_rows_selected
    p <- plot_ly() 
    if (length(selectedPersons)) {
      p <- p %>%
        add_trace(
          data = roomHistDayOne[[personsDataTable[selectedPersons, VP]]],
          x = ~TimeSpent,
          y = ~Name,
          name = "Time spent per room",
          type = "bar",
          orientation = "h"
        )
    }
  })
  
  output$gx_roomHistBarDayTwo <- renderPlotly({
    selectedPersons = input$gx_DT_personsDataTable_rows_selected
    p <- plot_ly() 
    if (length(selectedPersons)) {
      p <- p %>%
        add_trace(
          data = roomHistDayTwo[[personsDataTable[selectedPersons, VP]]],
          x = ~TimeSpent,
          y = ~Name,
          name = "Time spent per room",
          type = "bar",
          orientation = "h"
        )
    }
  })
  
  ###****************************************************************************************************************************************************************
  ### Page 3: Experiment description and videos of the different Minecraft worlds
  ###****************************************************************************************************************************************************************
  
  ######################################################################################
  #Memorizing Value Boxes
  ######################################################################################
  output$wordsValueBox <- renderValueBox({
    valueBox(20, "Words to memorize", icon = icon("list"))
  })
  output$avgDirectRecallBox <- renderValueBox({
    valueBox(
      round(mean(personsDataTable[['TP_DirectRecall']]), 1),
      "Average Direct Recall (Words correctly memorized)",
      icon = icon("brain")
    )
  })
  output$avgDelayedRecallBox <- renderValueBox({
    valueBox(
      round(mean(personsDataTable[['TP_DelayedRecall']]), 1),
      "Average Delayed Recall (Words correctly memorized)",
      icon = icon("brain")
    )
  })
  output$sameWorldBox <- renderValueBox({
    valueBox(
      paste(round((
        nrow(sameWorld) / nrow(personsDataTable)
      ) * 100, 2), '%'),
      "Same world",
      icon = icon("percent"),
      color = 'green'
    )
  })
  output$newWorldBox <- renderValueBox({
    valueBox(
      paste(round((
        nrow(newWorld) / nrow(personsDataTable)
      ) * 100, 2), ' %'),
      "New world",
      icon = icon("percent"),
      color = 'green'
    )
  })
  output$partialNewWorldBox <- renderValueBox({
    valueBox(
      paste(round((
        nrow(partialNewWorld) / nrow(personsDataTable)
      ) * 100, 2), '%'),
      "Partial new world",
      icon = icon("percent"),
      color = 'yellow'
    )
  })
  
  output$sameTyp0 <- renderValueBox({
    valueBox(round((nrow(
      sameWorldControl
    ) / (
      nrow(sameWorld)
    )) * 100, 0),
    "Type 0",
    icon = icon("percent"),
    color = 'green')
  })
  output$sameTyp1 <- renderValueBox({
    valueBox(round((nrow(sameWorldADHD1) / (
      nrow(sameWorld)
    )) * 100, 0),
    "Type 1",
    icon = icon("percent"),
    color = 'yellow')
  })
  output$sameTyp2 <- renderValueBox({
    valueBox(round((nrow(sameWorldADHD2) / (
      nrow(sameWorld)
    )) * 100, 0),
    "Type 2",
    icon = icon("percent"),
    color = 'orange')
  })
  output$sameTyp3 <- renderValueBox({
    valueBox(round((nrow(sameWorldADHD3) / (
      nrow(sameWorld)
    )) * 100, 0),
    "Type 3",
    icon = icon("percent"),
    color = 'red')
  })
  output$newTyp0 <- renderValueBox({
    valueBox(round((nrow(
      newWorldControl
    ) / (nrow(
      newWorld
    ))) * 100, 0),
    "Type 0",
    icon = icon("percent"),
    color = 'green')
  })
  output$newTyp1 <- renderValueBox({
    valueBox(round((nrow(newWorldADHD1) / (nrow(
      newWorld
    ))) * 100, 0),
    "Type 1",
    icon = icon("percent"),
    color = 'yellow')
  })
  output$newTyp2 <- renderValueBox({
    valueBox(round((nrow(newWorldADHD2) / (nrow(
      newWorld
    ))) * 100, 0),
    "Type 2",
    icon = icon("percent"),
    color = 'orange')
  })
  output$newTyp3 <- renderValueBox({
    valueBox(round((nrow(newWorldADHD3) / (nrow(
      newWorld
    ))) * 100, 0),
    "Type 3",
    icon = icon("percent"),
    color = 'red')
  })
  output$paritalNewTyp0 <- renderValueBox({
    valueBox(round((
      nrow(partialNewWorldControl) / (nrow(partialNewWorld))
    ) * 100, 0),
    "Type 0",
    icon = icon("percent"),
    color = 'green')
  })
  output$paritalNewTyp1 <- renderValueBox({
    valueBox(round((nrow(
      partialNewWorldADHD1
    ) / (
      nrow(partialNewWorld)
    )) * 100, 0),
    "Type 1",
    icon = icon("percent"),
    color = 'yellow')
  })
  output$paritalNewTyp2 <- renderValueBox({
    valueBox(round((nrow(
      partialNewWorldADHD2
    ) / (
      nrow(partialNewWorld)
    )) * 100, 0),
    "Type 2",
    icon = icon("percent"),
    color = 'orange')
  })
  output$paritalNewTyp3 <- renderValueBox({
    valueBox(round((nrow(
      partialNewWorldADHD3
    ) / (
      nrow(partialNewWorld)
    )) * 100, 0),
    "Type 3",
    icon = icon("percent"),
    color = 'red')
  })
  
  ######################################################################################
  #Bar charts: Distribution of ADHD Types
  ######################################################################################
  output$sameWorldBar <- renderPlotly({
    p <- plot_ly(
      x = c(
        "ADHD_Type_1",
        "ADHD_Type_2",
        "ADHD_Type_3",
        "Control_Group"
      ),
      y = c(
        nrow(sameWorldADHD1) / nrow(sameWorld),
        nrow(sameWorldADHD2) / nrow(sameWorld),
        nrow(sameWorldADHD3) / nrow(sameWorld),
        nrow(sameWorldControl) / nrow(sameWorld)
      ),
      name = "Same World",
      xaxis = list(
        title = "",
        tickfont = list(size = 14,
                        color = 'rgb(107, 107, 107)')
      ),
      yaxis = list(
        title = 'Percentage',
        titlefont = list(size = 16,
                         color = 'rgb(107, 107, 107)')
      ),
      textposition = 'auto',
      type = "bar"
    )
  })
  
  #
  output$newWorldBar <- renderPlotly({
    p <- plot_ly(
      x = c(
        "ADHD_Type_1",
        "ADHD_Type_2",
        "ADHD_Type_3",
        "Control_Group"
      ),
      y = c(
        nrow(newWorldADHD1) / nrow(newWorld),
        nrow(newWorldADHD2) / nrow(newWorld),
        nrow(newWorldADHD3) / nrow(newWorld),
        nrow(newWorldControl) / nrow(newWorld)
      ),
      name = "New World",
      xaxis = list(
        title = "",
        tickfont = list(size = 14,
                        color = 'rgb(107, 107, 107)')
      ),
      yaxis = list(
        title = 'Percentage',
        titlefont = list(size = 16,
                         color = 'rgb(107, 107, 107)')
      ),
      type = "bar"
    )
  })
  
  # 
  output$partialNewWorldBar <- renderPlotly({
    p <- plot_ly(
      x = c(
        "ADHD_Type_1",
        "ADHD_Type_2",
        "ADHD_Type_3",
        "Control_Group"
      ),
      y = c(
        nrow(partialNewWorldADHD1) / nrow(partialNewWorld),
        nrow(partialNewWorldADHD2) / nrow(partialNewWorld),
        nrow(partialNewWorldADHD3) / nrow(partialNewWorld),
        nrow(partialNewWorldControl) / nrow(partialNewWorld)
      ),
      name = "Partial New World",
      xaxis = list(
        title = "",
        tickfont = list(size = 14,
                        color = 'rgb(107, 107, 107)')
      ),
      yaxis = list(
        title = 'Percentage',
        titlefont = list(size = 16,
                         color = 'rgb(107, 107, 107)')
      ),
      textposition = 'auto',
      type = "bar"
    )
  })

  ######################################################################################
  # Memorizing Boxplots
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
      add_trace(y = controlGroup$TP_DirectRecall  , name = 'Control TP_Direct ') %>%
      add_trace(y = adhdChildren$TP_DelayedRecall, name = 'ADHD TP_Delayed') %>%
      add_trace(y = controlGroup$TP_DelayedRecall, name =
                  'Control TP_Delayed')
    
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
      add_trace(y = sameWorldControl$TP_DirectRecall, name = ' SameWorld TP_Direct (Control)') %>%
      add_trace(y = sameWorldADHD$TP_DelayedRecall, name = ' SameWorld TP_Delayed (ADHD)') %>%
      add_trace(y = sameWorldControl$TP_DelayedRecall, name = ' SameWorld TP_Delayed (Control)')
    
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
      add_trace(y = newWorldControl$TP_DirectRecall, name = ' NewWorld TP_Direct (Control)') %>%
      add_trace(y = newWorldADHD$TP_DelayedRecall, name = ' NewWorld TP_Delayed (ADHD)') %>%
      add_trace(y = newWorldControl$TP_DelayedRecall, name = ' NewWorld TP_Delayed (Control)')
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
      add_trace(y = partialNewWorldControl$TP_DirectRecall, name = ' PartialNewWorld TP_Direct (Control)') %>%
      add_trace(y = partialNewWorldADHD$TP_DelayedRecall, name = ' PartialNewWorld TP_Delayed (ADHD)') %>%
      add_trace(y = partialNewWorldControl$TP_DelayedRecall, name = ' PartialNewWorld TP_Delayed (Control)')
    
  })
  
  
 
  
  ######################################################################################
  # Debug traj2roomGraph
  ######################################################################################
  
  # Create a printf function for formattet printing
  printf <- function(...) cat(sprintf(...))
  # Create symmetric diff function
  symdiff <- function( x, y) { setdiff( union(x, y), intersect(x, y))}
  # Print debug information of selected VP
  observe({
    selectedPersons = input$gx_DT_personsDataTable_rows_selected
    # Only day one beeing checked
    if(length(selectedPersons)){
    vp = personsDataTable[selectedPersons,VP]
    vr = personsDataTable[selectedPersons,firstVR]
    trj = trajectoryDataDayOne[[vp]]
    graph = roomGraphDataDayOne[[vp]]
    hist = roomHistDayOne[[vp]]
    # Timings:
    trjTime = nrow(trj)*0.1
    graphTime = sum(graph$TimeSpent)
    histTime = sum(hist$TimeSpent)
    # Unentered Rooms: (depends on VR version)
    if(vr == 1 || 3){
      graphRoomUnvisited = symdiff(roomCoordinatesVR1.0$id,graph$Room)
    }else if(vr == 2){
      graphRoomUnvisited = symdiff(roomCoordinatesVR2.0$id,graph$Room)
    }else{
      print("abort in debug observing: wrong vr id")
      return(NULL)
    }
    histRoomUnvisited = hist[hist[,TimeSpent==0],]$Room
    entryRoomUnvisited = hist[hist[,Entries==0],]$Room
    # Printing
    printf("For Day One: \n")
    printf("selected person id: %d vp: %d  vr: %d \n",selectedPersons, vp, vr)
    printf("Time: trj = %4.1f rGraph = %4.1f rHist = %4.1f \n", trjTime,graphTime,histTime)
    # Print unvisited rooms
    printf("Rooms not entered: \n")
    print(graphRoomUnvisited)
    print(histRoomUnvisited)
    print(entryRoomUnvisited)
    printf("Difference roomGraph to roomHist:")
    print(symdiff(graphRoomUnvisited,histRoomUnvisited))
    printf("\n")
    printf("Difference roomHist to histEntries:")
    print(symdiff(histRoomUnvisited,entryRoomUnvisited))
    printf("\n")
    }
  })
  
  
  ######################################################################################
  # Selection cupling (not really visualization stuff..)
  ######################################################################################
  
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
