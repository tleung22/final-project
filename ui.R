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
      sidebarPanel(
        radioButtons("yaxis", "View Happiness Score by Percent of Gun Ownership OR Rate of Gun Related Deaths per 100k People:",
                     choiceNames = c("Percent of Gun Ownership", "Rate of Gun Related Deaths per 100k People"),
                     choiceValues = c("percown", "rate")
                     
                     
        )
      ),
      mainPanel(
        plotlyOutput("scatter_plot"),
        plotlyOutput("interactive_map")
      )
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