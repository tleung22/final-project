library(shiny)
library(dplyr)
library(plotly)

ui <- navbarPage(
  "Application Title",
  
  # Introduction tab
  tabPanel(
    "Introduction"
    
  ),
  
  # Happiness tab
  tabPanel(
    "Happiness",
    sidebarLayout(
      sidebarPanel(),
      mainPanel()
    )
  )
  
  
  
)























shinyUI(ui)