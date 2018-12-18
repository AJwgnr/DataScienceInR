#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

# only includes in ui.R neccessary?
library(shiny)
library(shinydashboard)
library("rgl")
library("car")
library("data.table")
library("plotly")
library(dtplyr)
library(readxl)
library(stringr)
library(DT)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  #Source the 
  source("../functions/data/dataloading.R")
  
  personsDataTable <- loadPersonsDataset()
  
  ### Here the plotting starts
  
  # Plot personsDataTable as table
  output$gx_DT_personsDataTable <- DT::renderDataTable(personsDataTable,options = list(paging = FALSE))
  
  
  # Fix this shit later!
  output$histTimeRooms <-renderPlotly({plot_ly()%>%add_bars(data=unique(rooms[,c("id","TimeSpent")]),y=~TimeSpent,x=~names)}) 
  
  # Deprecated Rgl plot => use plot_ly mesh3d/scatter3 instead
  output$trj3d <- renderRglwidget({
    rgl.open(useNULL=T)
    x<-trajectorie$x;
    y<-trajectorie$y;
    z<-trajectorie$z;
    scatter3d(x,z,y,point.col=c(1,2,3,4,5,6,7),surface = FALSE);
    rglwidget()
  })
  
  
})
