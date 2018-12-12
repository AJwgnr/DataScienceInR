#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

# only includes in ui.R neccessary?
#library(shiny)
#library(shinydashboard)
library("rgl")
library("car")
library("data.table")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Path to dataSet
  csv_test_trajectories_path <-
    ("../../res/position_data/DEBUGFILENODATA_V2.csv")
  
  # Load data...
  trajectorie <- fread(csv_test_trajectories_path)
  
  output$trj3d <- renderRglwidget({
    rgl.open(useNULL=T)
    x<-trajectorie$x;
    y<-trajectorie$y;
    z<-trajectorie$z;
    scatter3d(x,z,y,point.col=c(1,2,3,4,5,6,7),surface = FALSE);
    rglwidget()
  })
  
  
})
