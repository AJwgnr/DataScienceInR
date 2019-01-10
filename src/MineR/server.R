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
  source("../functions/transformation/traj2graph.R")
  
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
  
  roomNamesVR1.0 = unique(roomCoordinatesVR1.0[, c("id", "name")])
  roomNamesVR2.0 = unique(roomCoordinatesVR2.0[, c("id", "name")])
  
  
  
  adhdChildren <-
    personsDataTable[personsDataTable$ADHD_Subtype > 0]
  healthyChildren <-
    personsDataTable[personsDataTable$ADHD_Subtype == 0]
  
  
  # Extract persons with respect
  # Persons that have only seen the same world twice
  sameWorld <- personsDataTable[personsDataTable$Novelty == 1]
  sameWorldADHD <- sameWorld[sameWorld$ADHD_Subtype > 0]
  sameWorldADHD1 <- sameWorld[sameWorld$ADHD_Subtype == 1]
  sameWorldADHD2 <- sameWorld[sameWorld$ADHD_Subtype  == 2]
  sameWorldADHD3 <- sameWorld[sameWorld$ADHD_Subtype  == 3]
  sameWorldHealthy <- sameWorld[sameWorld$ADHD_Subtype == 0]
  
  # Persons that have seen a new world
  newWorld <- personsDataTable[personsDataTable$Novelty == 2]
  newWorldADHD <- newWorld[newWorld$ADHD_Subtype > 0]
  newWorldADHD1 <- newWorld[newWorld$ADHD_Subtype == 1]
  newWorldADHD2 <- newWorld[newWorld$ADHD_Subtype == 2]
  newWorldADHD3 <- newWorld[newWorld$ADHD_Subtype == 3]
  newWorldHealthy <- newWorld[newWorld$ADHD_Subtype == 0]
  
  # Persons that have seen a partial new world (different color)
  partialNewWorld <- personsDataTable[personsDataTable$Novelty == 3]
  partialNewWorldADHD <-
    partialNewWorld[partialNewWorld$ADHD_Subtype > 0]
  partialNewWorldADHD1 <-
    partialNewWorld[partialNewWorld$ADHD_Subtype == 1]
  partialNewWorldADHD2 <-
    partialNewWorld[partialNewWorld$ADHD_Subtype == 2]
  partialNewWorldADHD3 <-
    partialNewWorld[partialNewWorld$ADHD_Subtype == 3]
  partialNewWorldHealthy <-
    partialNewWorld[partialNewWorld$ADHD_Subtype == 0]
  
  
  
  
  ###################
  #### Precompute ###
  ###################
  

  
  # # Compute roomGraph and roomHist for each trajectory/person
  # # Compute functions are in traj2graph
  # roomGraphDataDayOne = computeRoomGraphByDay(1,personsDataTable,trajectoryDataDayOne,roomCoordinatesVR1.0,roomCoordinatesVR2.0)
  # roomGraphDataDayTwo = computeRoomGraphByDay(2,personsDataTable,trajectoryDataDayTwo,roomCoordinatesVR1.0,roomCoordinatesVR2.0)
  # roomHistDayOne = computeRoomHistByDay(1,personsDataTable,roomGraphDataDayOne,roomCoordinatesVR1.0,roomCoordinatesVR2.0)
  # roomHistDayTwo = computeRoomHistByDay(2,personsDataTable,roomGraphDataDayTwo,roomCoordinatesVR1.0,roomCoordinatesVR2.0)

  # Loading functions are in dataloading.R
  roomGraphDataDayOne = loadRoomGraphByDay(1,personsDataTable,trajectoryDataDayOne,roomCoordinatesVR1.0,roomCoordinatesVR2.0)
  roomGraphDataDayTwo = loadRoomGraphByDay(2,personsDataTable,trajectoryDataDayTwo,roomCoordinatesVR1.0,roomCoordinatesVR2.0)
  roomHistDayOne = loadRoomHistByDay(1,personsDataTable,roomGraphDataDayOne,roomCoordinatesVR1.0,roomCoordinatesVR2.0)
  roomHistDayTwo = loadRoomHistByDay(2,personsDataTable,roomGraphDataDayTwo,roomCoordinatesVR1.0,roomCoordinatesVR2.0)

  
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
  
  ###################
  ###   Plotting  ###
  ###################
  
  
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
  
  # roomGraphDayOne = renderPrint({
  #   selectedPersons = input$gx_DT_personsDataTable_rows_selected
  #   if (length(selectedPersons)) {
  #     # ToDo: invoke traj2graph and compute the roooms visited
  #   }
  # })
  
  
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
        nrow(sameWorldHealthy) / nrow(sameWorld)
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
        nrow(newWorldHealthy) / nrow(newWorld)
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
        nrow(partialNewWorldHealthy) / nrow(partialNewWorld)
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
      sameWorldHealthy
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
      newWorldHealthy
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
      nrow(partialNewWorldHealthy) / (nrow(partialNewWorld))
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
  
  
  ######################################################################################
  # Trajectory Plots
  ######################################################################################
  
  
  ### TODO: abstract plotting into functions -> currently exact same plotting is done for day one and two...
  output$gx_3d_trajectoryDayOne <- renderPlotly({
    selectedPersons = input$gx_DT_personsDataTable_rows_selected
    lower_z_filter = input$z_level_dayOne[1]
    upper_z_filter = input$z_level_dayOne[2]
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
      sRl = input$colorInput_dayOne[1]
      sRh = input$colorInput_dayOne[2]
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
      if ((vr == 1 || vr == 3) && input$showRoomInput_dayOne ) {
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
        
      } else if ((vr == 2) && input$showRoomInput_dayOne) {
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
      } else if(input$showRoomInput_dayOne){
        print("Unexpected VR ID provided in trajectory plotting")
        print(toString(vr))
      }
    }
    trjPlotDayOne
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
  
  
  ######################################################################################
  # Times rooms entered bar chart
  ######################################################################################
  
  output$gx_roomEntriesBarDayOne <- renderPlotly({
    selectedPersons = input$gx_DT_personsDataTable_rows_selected
    p <- plot_ly() 
    if (length(selectedPersons)) {
      d = computeRoomEntryHistogramByDay(1,personsDataTable,roomGraphDataDayOne[[personsDataTable[selectedPersons, VP]]],roomHistDayOne[[personsDataTable[selectedPersons, VP]]],roomCoordinatesVR1.0,roomCoordinatesVR2.0,selectedPersons)
      
      #TODO: debug + color code rooms seperately in traj??

      p <- p %>%
        add_trace(
          data = d,
          x = d$entries,
          y = d$name,
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
          y = ~name,
          name = "Time spent per room",
          type = "bar",
          orientation = "h"
        )
    }
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
    hist = as.data.table(roomHistDayOne[[vp]])
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
    histEntries = as.data.table(computeRoomEntryHistogramByDay(1,personsDataTable,graph,hist,roomCoordinatesVR1.0,roomCoordinatesVR2.0,selectedPersons))
    histEntries = histEntries[histEntries[,entries==0],]$id
    # Printing
    printf("For Day One: \n")
    printf("selected person id: %d vp: %d  vr: %d \n",selectedPersons, vp, vr)
    printf("Time: trj = %4.1f rGraph = %4.1f rHist = %4.1f \n", trjTime,graphTime,histTime)
    # Print unvisited rooms
    printf("Rooms not entered: \n")
    print(graphRoomUnvisited)
    print(histRoomUnvisited)
    print(histEntries)
    printf("Difference roomGraph to roomHist:")
    print(symdiff(graphRoomUnvisited,histRoomUnvisited))
    printf("\n")
    printf("Difference roomHist to histEntries:")
    print(symdiff(histRoomUnvisited,histEntries))
    printf("\n")
    #TODO: fix histEntrie computation!
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
