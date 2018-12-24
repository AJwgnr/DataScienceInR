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
    ### MenueItem 2: Experiment Overview
    ###**************************
    menuItem(
      "The Experiment",
      tabName = "experiment",
      icon = icon("th")
    ),
    ###**************************
    ### MenueItem 3: Dataset
    ###**************************
    menuItem(
      "The Dataset",
      tabName = "rawData",
      icon = icon("database")
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
    h1("Project Introduction"),
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
      "at the medical faculty of the university of Magdeburg. Further information regarding the process how the dataset was generated can be found in the experiment tab. The dataset itself can be explored in the dataset tab.",
      
      "The whole code for this project is stored in this",
      tags$a(href = "https://gitlab.com/vornamenachname/datascience_r", "GitLab Repository"),".",
      "If you want to get a short introduction for this application, please see the video below",
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
      fluidRow(
        width = 12,
        box( h2(width = 12, "Description"),
             width = 12,
      "The used datasets consists of", tags$b("two different types"), "of csv files. The first type, in the following named", tags$em("Test subject data,"), "contains all personal information about the tested persons.",
      "The second type, in the following named", tags$em("Trajectory data,"), "contains information about the movement of the test subjects in the virtual world.",tags$br(),tags$br(),
      tags$b("Test subject data:"),tags$ul(
        tags$li("1 csv file"),
        tags$li("63 instances"), 
        tags$li("31 attributes")
      ),
      tags$br(),
      tags$b("Trajectory data:"),tags$ul(
        tags$li("130 csv files"), 
        tags$li("~7000 instances each"), 
        tags$li("4 attributes")
      ),
      "In the following tables you can get an insight into the dataset.",
      tags$br())),
      
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
        box(h2(width = 12, "Trajectory and room data"),
            width=12,
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
      ))
    ),
  
  
  tabItem(tabName = "experiment",
          h1("Experiment Overview"),
          
          fluidRow(
            width = 12,
            box(h2(width = 12, "Description"),
                width=12,
          
          tags$br("Give description of the experiment here!! Describe here how to data was recorded, what was the idea of the experiment, etc.")
            )),
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
  