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
      mainPanel(plotlyOutput("interactive_map"))
    )
  ),
  #bar chart
  tabPanel(
    "temp",
    sidebarLayout(
      sidebarPanel(
        radioButtons("radio", label = h3("Data to Display"),
          choices = list("Total Shootings" = 1, "Casualties" = 2, "Legislation" = 3), 
          selected = 1)
      ),
      mainPanel(
        plotlyOutput("shootings"),
        plotlyOutput("casualties"),
        plotlyOutput("legislation")
      )
    )
  ),
  
  # Conslusions
  tabPanel(
    "Conclusion",
    sidebarLayout(
      sidebarPanel(),
      mainPanel()
    )
  )
  
  
  
)























shinyUI(ui)