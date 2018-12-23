# Include librarys for UI and SERVER

#https://www.r-bloggers.com/difference-between-library-and-require-in-r/
#Require returns false if package is not found
if(!require(shiny)){
  install.packages(shiny)
}
if(!require(shinydashboard)){
  install.packages(shinydashboard)
}
if(!require(shinyWidgets)){
  install.packages(shinyWidgets)
}
if(!require(data.table)){
  install.packages(data.table)
}
if(!require(plotly)){
  install.packages(plotly)       
}
if(!require(dtplyr)){
  install.packages(dtplyr)
}
if(!require(readxl)){
  install.packages(readxl)
}
if(!require(stringr)){
  install.packages(stringr)
}
if(!require(DT)){
  install.packages(DT)
}

library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(data.table)
library(plotly)
library(dtplyr)
library(readxl)
library(stringr)
library(DT)

# pkg: dygraphs sounds good

# Remove or comment unused libs to avoid abigous function calls and save ram space

# Currently unused:
# library(rgl)
# library(car)
# library(ggplot2)



