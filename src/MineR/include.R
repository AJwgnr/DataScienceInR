# Include librarys for UI and SERVER

# Require returns false if package is not found (https://www.r-bloggers.com/difference-between-library-and-require-in-r/)
# Check if the packages were already installed, otherwise installs them
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
if(!require(crosstalk)){
  install.packages(crosstalk)
}
if(!require(GGally)){
  install.packages(GGally)
}

# Load the libraries
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(data.table)
library(plotly)
library(dtplyr)
library(readxl)
library(stringr)
library(DT)
library(crosstalk)
library(GGally)


# pkg: dygraphs sounds good
# Remove or comment unused libs to avoid abigous function calls and save ram space
# Currently unused:
# library(rgl)
# library(car)
# library(ggplot2)



