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
source("include.R")



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
      "The Dataset",
      tabName = "rawData",
      icon = icon("database")
    ),
    ###**************************
    ### MenueItem 3: Minecraft World´s
    ###**************************
    menuItem(
      "Minecraft World´s",
      tabName = "minecraft",
      icon = icon("th")
    ),
    ###**************************
    ### MenueItem 4: Visuals
    ###**************************
    menuItem(
      "Visual data exploration",
      tabName = "visualization",
      icon = icon("analytics")
    ),
    ###**************************
    ### MenueItem 5: Features
    ###**************************
    menuItem(
      "Trajectory feature exploration",
      tabName = "trjFeatures",
      icon = icon("running")
    ),
    ###**************************
    ### MenueItem 6: Clustering
    ###**************************
    menuItem(
      "Clustering",
      tabName = "clustering",
      icon = icon("chart-pie")
    ),
    ###**************************
    ### MenueItem 7: DecisionTree
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
      "This webpage is the result of the semester project of the course",
      tags$b("Data Science with R"),
      "held in the winter semester 2018/2019 at the computer science faculty at the Otto-von-Guericke university Magdeburg by M.Sc. Uli Niemann from the",  
      tags$a(href = "http://www.kmd.ovgu.de", "KMD Lab"),". Further details regarding the lecture can be found on the official",
      tags$a(href = "https://kmd.cs.ovgu.de/teaching/DataSciR/index.html", "course website"), ".",
      "This project was done as a team consisting of the members",
      tags$b("Johannes Dambacher"),
      "and",
      tags$b("Alexander Wagner"),
      ".",
      "The general project idea as well as an detailed time plan can be found in the " ,
      tags$a(href = "https://drive.google.com/file/d/14JyjdShlHViJ199tRS3etAleqFE1tPem/view?usp=sharing", "project proposal"),".",
      "The basic idea of the course was to choose a dataset and to to gain new insights using the language R. We have decided to use a dataset from the ",
      tags$a(
        href = " http://www.kkjp.ovgu.de/Forschung.html",
        "Universitätsklinik für Psychiatrie, Psychotherapie und Psychosomatische Medizin des Kindes- und Jugendalters (KKJP)"),
      "at the medical faculty of the university of Magdeburg. Further information regarding the dataset can be found in the dataset tab.",
      
      "The whole code for this project is stored in this",
      tags$a(href = "https://gitlab.com/vornamenachname/datascience_r", "GitLab Repository"),".",
      tags$br(),
      tags$br()
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
               ))),
  
  
    
    tags$div(
      tags$img(src = 'datascir.png', width='78', height='91', align = "left"),
      tags$img(src = 'fin.png', align = "right"),
      tags$img(src = 'medlogo.jpeg', align = "center")
    ),
    tags$br(),
    tags$br()),
    ###****************************************************************************************************************************************************************
    ### Page 2: Data Raw; table, scatterplots,
    ###****************************************************************************************************************************************************************
    tabItem(
      tabName = "rawData",
      h1("The dataset"),
      tags$br(),
      tags$br(),
      tags$br(),
      tags$br(),
      tags$br(),
      
      
      "Give description of dataset here!!",
      
      
      #======================================
      # Tab 2: fluidRow 1: ToDo
      #======================================
      fluidRow(
        width = 12,
        box(
          h2(width = 12, "Test persons data table"),
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
        h2(width = 12, "Trajectory and room data"),
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
  
  
  tabItem(tabName = "minecraft",
          h2("Minecraft World's"),
          
          "Give description of dataset here!!",
          
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
  