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

ds_header = dashboardHeader(title = "MineR",
                            dropdownMenu(
                              type = "message",
                              messageItem(from = "WHO Breaking News:",
                                          message = "Minecraft cures ADHD.")
                            ))

ds_sidebar = dashboardSidebar(
  sidebarMenu(
    id = "menuTasks",
    menuItem("Introduction",
             tabName = "introduction",
             icon = icon("th")),
    menuItem(
      "The Data - raw",
      tabName = "rawData",
      icon = icon("th"),
      badgeLabel = "sample",
      badgeColor = "green"
    ),
    menuItem(
      "Visual data exploration",
      tabName = "visualization",
      icon = icon("th")
    ),
    menuItem(
      "Trajectory feature exploration",
      tabName = "trjFeatures",
      icon = icon("th")
    ),
    menuItem("Clustering",
             tabName = "clustering",
             icon = icon("th")),
    menuItem("Decision Trees",
             tabName = "decisionTree",
             icon = icon("th"))
  )
)

ds_body = dashboardBody(tabItems(
  tabItem(tabName = "introduction",
          h2("Introduction"),
          fluidRow(
            width = 12,
            tabBox(
              title = "First tabBox",
              # The id lets us use input$tabset1 on the server to find the current tab
              id = "tabset1",
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
          )),
  tabItem(tabName = "rawData",
          h2("The data - raw"),
          fluidRow(
            tabBox(
              title = "First tabBox",
              # The id lets us use input$tabset1 on the server to find the current tab
              id = "tabset1",
              height = "250px",
              tabPanel("Tab1",
                       renderDataTable("fooblaaa")),
              tabPanel("Tab2", "Second tab content")
            ),
            tabBox(
              title = "Second tabBox",
              side = "right",
              height = "250px",
              tabPanel("Tab1", "Tab content 1"),
              tabPanel("Tab2", 
                       rglwidgetOutput("trj3d"))
            )
          )),
  tabItem(tabName = "visualization",
          h2("Visual data exploration")),
  tabItem(tabName = "trjFeatures",
          h2("Trajectory feature exploration")),
  tabItem(tabName = "clustering",
          h2("Clustering")),
  tabItem(tabName = "decisionTree",
          h2("Decision tree"))
))

# Define UI for application that draws everything
dashboardPage(ds_header, ds_sidebar, ds_body)