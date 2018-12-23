#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# see https://rstudio.github.io/shinydashboard/structure.html

library(shiny)
library(shinydashboard)
library("rgl")
library("car")
library("data.table")
library("plotly")

# pkg: dygraphs sounds good

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
    id = "menuTasks", # what is the id good for in graphics menus? (also works with tabItems, tabBoxes etc.)
    menuItem("Project Introduction",
    ###**************************
    ### MenueItem 1: Introduction
    ###**************************
             tabName = "introduction",
             icon = icon("th")),
    ###**************************
    ### MenueItem 1: Dataset
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
    ### MenueItem 1: Visuals
    ###**************************
    menuItem(
      "Visual data exploration",
      tabName = "visualization",
      icon = icon("analytics")
    ),
    ###**************************
    ### MenueItem 1: Features
    ###**************************
    menuItem(
      "Trajectory feature exploration",
      tabName = "trjFeatures",
      icon = icon("running")
    ),
    ###**************************
    ### MenueItem 1: Clustering
    ###**************************
    menuItem("Clustering",
             tabName = "clustering",
             icon = icon("chart-pie")),
    ###**************************
    ### MenueItem 1: DecisionTree
    ###**************************
    menuItem("Decision Trees",
             tabName = "decisionTree",
             icon = icon("tree"))
  )
)

################################################################################
### Dashboard Content:

ds_body = dashboardBody(tabItems(
  ###********************************************************************************
  ### Page 1: Indroduction; videos, experiment, text, data, motivation ect. ...
  ###********************************************************************************
  tabItem(tabName = "introduction",
          h2("Project Introduction"),
          tags$div(
            tags$p("Enter description of course here!!!"), 
            tags$b("Johannes Dambacher"), "and",
            tags$b("Alexander Wagner"),
            "winter semester 2018/2019 at the Otto-von-Guericke university Magdeburg",
            tags$br(),
            tags$a(href=" http://www.kkjp.ovgu.de/Forschung.html", "Universitätsklinik für Psychiatrie, Psychotherapie und Psychosomatische Medizin des Kindes- und Jugendalters (KKJP)"),
            tags$br(),
            tags$a(href="https://drive.google.com/file/d/14JyjdShlHViJ199tRS3etAleqFE1tPem/view?usp=sharing", "project proposal"),
            tags$br(),
            tags$a(href="https://kmd.cs.ovgu.de/teaching/DataSciR/index.html", "course website"),
            tags$br(),
            tags$a(href="http://www.kmd.ovgu.de", "KMD Lab"), 
            tags$br(),
            tags$a(href="https://gitlab.com/vornamenachname/datascience_r", "GitLab Repository"),
            tags$br(),
            tags$br(),
           
            tags$br()
          ),
          #======================================
          # Page 1: fluidRow 1: ToDo: Teaser Video
          #======================================
          fluidRow(width = 12,
                   tabBox(title = "Watch me! :)",
                          height = "auto",
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
                   tags$img(src='datascir.png', align = "left"),
                   tags$img(src='fin.png', align = "right"),
                   tags$img(src='medlogo.jpeg', align = "center"))),
          
         
          tabItem(tabName = "minecraft",
                  h2("Minecraft World's"),
                  tags$br(),
                  tags$div(
                    
                    
                  ),
          #======================================
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
          )),
  ###********************************************************************************
  ### Page 2: Data Raw; table, scatterplots, 
  ###********************************************************************************
  tabItem(tabName = "rawData",
          h2("The dataset"),
          "Add a short description of the dataset here and explain this website",
          tags$div(
            tags$p("First paragraph"), 
            tags$p("Second paragraph"), 
            tags$p("Third paragraph")
          ),
          #======================================
          # Tab 2: fluidRow 1: ToDo
          #======================================
          fluidRow(
            tabBox(
              title = "First tabBox",
              height = "250px",
              tabPanel("Tab1",
                       renderDataTable("fooblaaa")),
              tabPanel("Tab2", "Second tab content")
            ),
            tabBox(
              title = "Second tabBox",
              side = "right",
              height = "250px",
              tabPanel("Tab1", plotlyOutput("histTimeRooms")),
              tabPanel("Tab2", 
                       rglwidgetOutput("trj3d"))
            )
          )),
  ###********************************************************************************
  ### Page 3: Visualization 
  ###********************************************************************************
  tabItem(tabName = "visualization",
          h2("Visual data exploration")),
  ###********************************************************************************
  ### Page 4: Trajectroy features
  ###********************************************************************************
  tabItem(tabName = "trjFeatures",
          h2("Trajectory feature exploration")),
  ###********************************************************************************
  ### Page 5: Clustering plus visualization
  ###********************************************************************************
  tabItem(tabName = "clustering",
          h2("Clustering")),
  ###********************************************************************************
  ### Page 6: Decision Tree plus visualization
  ###********************************************************************************
  tabItem(tabName = "decisionTree",
          h2("Decision tree")
)))

################################################################################
### DashboardPage: (must be last)
dashboardPage(ds_header, ds_sidebar, ds_body)