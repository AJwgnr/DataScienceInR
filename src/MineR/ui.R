#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# see https://rstudio.github.io/shinydashboard/structure.html

# include everything once
source("inc.R")



### Set up column names of persons table for checkboxes
# Risky solution loading personsTable in ui? (static anyway)
# TODO: how about features beeing appended to personsTable serverSides? -> different plotting enough?
source("../functions/data/dataloading.R") # sourcing ui sides seems like bad practice: possible to get table names from server?
personsTable <- loadPersonsDataset()
columChoicesPersonsTable <- 1:ncol(personsTable)
names(columChoicesPersonsTable) <- names(personsTable)


################################################################################
### Header:

ds_header = dashboardHeader(title = "MineR",
                            dropdownMenu(
                              type = "message",
                              messageItem(from = "WHO Breaking News:",
                                          message = "Minecraft cures ADHD.")
                            ))
################################################################################
### Sidebar:

ds_sidebar = dashboardSidebar(
  sidebarMenu(
    id = "menuTasks",
    # what is the id good for in graphics menus? (also works with tabItems, tabBoxes etc.)
    ###**************************
    ### MenueItem 1: Introduction
    ###**************************
    menuItem(
      "Project Introduction",
      tabName = "introduction",
      icon = icon("th")
    ),
    ###**************************
    ### MenueItem 2: Dataset
    ###**************************
    menuItem(
      "Minecraft World´s",
      tabName = "minecraft",
      icon = icon("th")
    ),
    menuItem(
      "The Dataset",
      tabName = "rawData",
      icon = icon("database")
    ),
    ###**************************
    ### MenueItem 3: Visuals
    ###**************************
    menuItem(
      "Visual data exploration",
      tabName = "visualization",
      icon = icon("analytics")
    ),
    ###**************************
    ### MenueItem 4: Features
    ###**************************
    menuItem(
      "Trajectory feature exploration",
      tabName = "trjFeatures",
      icon = icon("running")
    ),
    ###**************************
    ### MenueItem 5: Clustering
    ###**************************
    menuItem(
      "Clustering",
      tabName = "clustering",
      icon = icon("chart-pie")
    ),
    ###**************************
    ### MenueItem 6: DecisionTree
    ###**************************
    menuItem("Decision Trees",
             tabName = "decisionTree",
             icon = icon("tree"))
  )
)

################################################################################
### Dashboard Content:

ds_body = dashboardBody(tabItems(
  ###****************************************************************************************************************************************************************
  ### Page 1: Indroduction; videos, experiment, text, data, motivation ect. ...
  ###****************************************************************************************************************************************************************
  tabItem(
    tabName = "introduction",
    h2("Project Introduction"),
    tags$div(
      tags$p("Enter description of course here!!!"),
      tags$b("Johannes Dambacher"),
      "and",
      tags$b("Alexander Wagner"),
      "winter semester 2018/2019 at the Otto-von-Guericke university Magdeburg",
      tags$br(),
      tags$a(
        href = " http://www.kkjp.ovgu.de/Forschung.html",
        "Universitätsklinik für Psychiatrie, Psychotherapie und Psychosomatische Medizin des Kindes- und Jugendalters (KKJP)"
      ),
      tags$br(),
      tags$a(href = "https://drive.google.com/file/d/14JyjdShlHViJ199tRS3etAleqFE1tPem/view?usp=sharing", "project proposal"),
      tags$br(),
      tags$a(href = "https://kmd.cs.ovgu.de/teaching/DataSciR/index.html", "course website"),
      tags$br(),
      tags$a(href = "http://www.kmd.ovgu.de", "KMD Lab"),
      tags$br(),
      tags$a(href = "https://gitlab.com/vornamenachname/datascience_r", "GitLab Repository"),
      tags$br(),
      tags$br(),
      
      tags$br()
    ),
    tags$div(
      tags$img(src = 'datascir.png', align = "left"),
      tags$img(src = 'fin.png', align = "right"),
      tags$img(src = 'medlogo.jpeg', align = "center")
    ),
    #======================================
    # Page 1: fluidRow 1: ToDo: Teaser Video
    #======================================
    fluidRow(width = 12,
             tabBox(
               title = "Watch me! :)",
               width = 12,
               tags$video(
                 id = "video2",
                 type = "video/mp4",
                 src = "VR1.0.mp4",
                 controls = "controls",
                 width = "auto",
                 height = 250
               )))),
               
    
    
    tabItem(tabName = "minecraft",
            h2("Minecraft World's"),
            tags$br(),
            tags$div(
              
              
            ),    
            # Page 2: fluidRow 1: Minecraft Worlds
            #======================================
            fluidRow(
              width = 12,
              tabBox(
                title = "Minecraft World´s",
                height = "auto",
                width = 12,
                tabPanel(
                  "The Mansion",
                  tags$video(
                    id = "video1",
                    type = "video/mp4",
                    src = "VR1.0.mp4",
                    controls = "controls",
                    width = "auto",
                    height = 250
                  )
                ),
                tabPanel(
                  "The Mansion (altered)",
                  tags$video(
                    id = "video2",
                    type = "video/mp4",
                    src = "VR1.1.mp4",
                    controls = "controls",
                    width = "auto",
                    height = 250
                  )
                ),
                tabPanel(
                  "The pirate island",
                  tags$video(
                    id = "video3",
                    type = "video/mp4",
                    src = "VR2.0.mp4",
                    controls = "controls",
                    width = "auto",
                    height = 250
                  )
                )
              )
            )
    ),
    ###****************************************************************************************************************************************************************
    ### Page 2: Data Raw; table, scatterplots,
    ###****************************************************************************************************************************************************************
    tabItem(
      tabName = "rawData",
      h2("The dataset"),
      #======================================
      # Tab 2: fluidRow 1: ToDo
      #======================================
      fluidRow(
        width = 12,
        box(
          title = "Test persons data table",
          width = 12,
          pickerInput(
            inputId = "id_pickerInputDTpersonsRaw",
            label = "Select columns to display:",
            choices = columChoicesPersonsTable[-1],
            options = list(
              `actions-box` = TRUE,
              size = 10,
              `selected-text-format` = "count > 3"
            ),
            multiple = TRUE,
            selected = columChoicesPersonsTable[2:7]
          ),
          DT::dataTableOutput("gx_DT_personsDataTable")
        )
      ),
      #======================================
      # Tab 2: fluidRow 2: ToDo
      #======================================
      fluidRow(
        width = 12,
        h2(width = 12, "Trajectory and room data:"),
        tabBox(
          title = "First Day",
          side = "right",
          selected = "Tab2",
          tabPanel("Tab1", "Times room entered"),
          tabPanel("Tab2",
                   "Time spent per room"),
          tabPanel(
            "Tab3",
            plotlyOutput("gx_3d_trajectoryDayOne"),
            sliderInput(
              "colorInput_dayOne",
              "Select time intervall",
              min = 0,
              max = 100,
              value = c(0,100)
            )
          )
        ),
        tabBox(
          title = "Second Day",
          side = "right",
          selected = "Tab2",
          tabPanel("Tab1", "Times room entered"),
          tabPanel("Tab2", "Time spent per room"),
          tabPanel("Tab3", plotlyOutput("gx_3d_trajectoryDayTwo"),
                   verbatimTextOutput("value"),
                   sliderInput(
                     "colorInput_dayTwo",
                     "Select time intervall",
                     min = 0,
                     max = 100,
                     value = c(0,100)
                   ))
        )
      )
    ),
    ###****************************************************************************************************************************************************************
    ### Page 3: Visualization
    ###****************************************************************************************************************************************************************
    tabItem(tabName = "visualization",
            h2("Visual data exploration")),
    ###****************************************************************************************************************************************************************
    ### Page 4: Trajectroy features
    ###****************************************************************************************************************************************************************
    tabItem(tabName = "trjFeatures",
            h2("Trajectory feature exploration")),
    ###****************************************************************************************************************************************************************
    ### Page 5: Clustering plus visualization
    ###****************************************************************************************************************************************************************
    tabItem(tabName = "clustering",
            h2("Clustering")),
    ###****************************************************************************************************************************************************************
    ### Page 6: Decision Tree plus visualization
    ###****************************************************************************************************************************************************************
    tabItem(tabName = "decisionTree",
            h2("Decision tree"))
  ))
  
  ################################################################################
  ### DashboardPage: (must be last)
  dashboardPage(ds_header, ds_sidebar, ds_body)
  