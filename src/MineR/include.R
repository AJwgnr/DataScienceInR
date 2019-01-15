# Include librarys for UI and SERVER
# Check if the packages were already installed, otherwise installs them
if (!require('yaml')) {
  install.packages('yaml')
}
if (!require('shiny')) {
  install.packages('shiny')
}
if (!require('lazyeval')) {
  install.packages('lazyeval')
}
if (!require('shinydashboard')) {
  install.packages('shinydashboard')
}
if (!require('shinyWidgets')) {
  install.packages('shinyWidgets')
}
if (!require('data.table')) {
  install.packages('data.table')
}
if (!require('ggplot2')) {
  install.packages('ggplot2')
}
if (!require('plotly')) {
  install.packages('plotly')
}
if (!require('dtplyr')) {
  install.packages('dtplyr')
}
if (!require('readxl')) {
  install.packages('readxl')
}
if (!require('stringr')) {
  install.packages('stringr')
}
if (!require('DT')) {
  install.packages('DT')
}
if (!require('crosstalk')) {
  install.packages('crosstalk')
}
if (!require('GGally')) {
  install.packages('GGally')
}
if (!require('tibble')) {
  install.packages('tibble')
}

if (!require('reader')) {
  install.packages('reader')
}

if (!require('plyr')) {
  install.packages('plyr')
}

if (!require('pracma')) {
  install.packages('pracma')
}

if (!require('trajr')) {
  install.packages('trajr')
}

# Load the libraries
library('shiny')
library('pracma')
library('tibble')
library('shinydashboard')
library('shinyWidgets')
library('data.table')
library('ggplot2')
library('plotly')
library('dtplyr')
library('readxl')
library('stringr')
library('DT')
library('crosstalk')
library('GGally')
library('reader')
library('plyr')
library('trajr')