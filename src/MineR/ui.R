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
library(DT)

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
    id = "menuTasks",
    # what is the id good for in graphics menus? (also works with tabItems, tabBoxes etc.)
    ###**************************
    ### MenueItem 1: Introduction
    ###**************************
    menuItem("Introduction",
             tabName = "introduction",
             icon = icon("th")),
    ###**************************
    ### MenueItem 1: Raw Data
    ###**************************
    menuItem(
      "The Data - raw",
      tabName = "rawData",
      icon = icon("th"),
      badgeLabel = "sample",
      badgeColor = "green"
    ),
    ###**************************
    ### MenueItem 1: Visuals
    ###**************************
    menuItem(
      "Visual data exploration",
      tabName = "visualization",
      icon = icon("th")
    ),
    ###**************************
    ### MenueItem 1: Features
    ###**************************
    menuItem(
      "Trajectory feature exploration",
      tabName = "trjFeatures",
      icon = icon("th")
    ),
    ###**************************
    ### MenueItem 1: Clustering
    ###**************************
    menuItem("Clustering",
             tabName = "clustering",
             icon = icon("th")),
    ###**************************
    ### MenueItem 1: DecisionTree
    ###**************************
    menuItem("Decision Trees",
             tabName = "decisionTree",
             icon = icon("th"))
  )
)

################################################################################
### Dashboard:

ds_body = dashboardBody(tabItems(
  ###********************************************************************************
  ### Page 1: Indroduction; videos, experiment, text, data, motivation ect. ...
  ###********************************************************************************
  tabItem(
    tabName = "introduction",
    h2("Introduction"),
    #======================================
    # Page 1: fluidRow 1: ToDo: Teaser Video
    #======================================
    fluidRow(width = 12,
             tabBox(title = "First tabBox")),
    #======================================
    # Page 1: fluidRow 2: Minecraft Worlds
    #======================================
    fluidRow(
      width = 12,
      tabBox(
        title = "Second tabBox",
        height = "250px",
        width = 12,
        tabPanel(
          "Tab1",
          tags$video(
            id = "video2",
            type = "video/mp4",
            src = "VR1.0.mp4",
            controls = "controls",
            width = "auto",
            height = 250
          )
        ),
        tabPanel(
          "Tab2",
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
          "Tab3",
          tags$video(
            id = "video2",
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
  ###********************************************************************************
  ### Page 2: Data Raw; table, scatterplots,
  ###********************************************************************************
  tabItem(
    tabName = "rawData",
    h2("The data - raw"),
    #======================================
    # Tab 2: fluidRow 1: ToDo
    #======================================
    fluidRow(
      width = 12,
      h3(width = 12, "Fuck you!"),
      DT::dataTableOutput("gx_DT_personsDataTable"),style = "height:500px; overflow-y: scroll;overflow-x: scroll;",
      h3(width = 12, "Fuck you too!")
    ),
    #======================================
    # Tab 2: fluidRow 2: ToDo
    #======================================
    fluidRow(
      width = 12,
      tabBox(
        title = "2nd row FIrst tabBox",
        side = "right",
        height = "250px",
        tabPanel("Tab1", plotlyOutput("histTimeRooms")),
        tabPanel("Tab2",
                 h2("wasrgelouts"))
      ),
      tabBox(
        title = "2nd row Second tabBox",
        side = "right",
        height = "250px",
        tabPanel(
          "mytable"
        ),
        tabPanel("Tab2", h2("tab2"))
      )
    )
  ),
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
          h2("Decision tree"))
))

################################################################################
### DashboardPage: (must be last)
dashboardPage(ds_header, ds_sidebar, ds_body)