library(shiny)
library(shinydashboard)
library(tidyverse)
library(dbscan)

# TO DO
# - file joining
# - missing values
# - outliers
# - 



source('ui.R', local = TRUE)
source('server.R', local = TRUE)


shinyApp(
  ui = ui,
  server = server
)