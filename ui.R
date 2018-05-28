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
        radioButtons("yaxis", "View Happiness Score by Rate of Gun Related Deaths per 100k People OR Percent of Gun Ownership:",
                     choiceNames = c("Rate of Gun Related Deaths per 100k People", "Percent of Gun Ownership"),
                     choiceValues = c("rate", "percown")
                     
                     
        )
      ),
      mainPanel(
        h1("Comparing State Happiness with Gun Related Data"),
        p("Description of happiness score and other useful infomation. Describe the importance/significance of comparing happiness with gun data. Describe what questions this page is trying to answer."),
        h3("Interactive Scatter Plot"),
        plotlyOutput("scatter_plot"),
        h3("Interactive Map"),
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