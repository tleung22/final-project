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
        em("Are happier states "), strong("safer"),
        em("? We took data from wallet hub where they took in multiple factors "),
        em("like depression rates and average income to calculate a happiness score "),
        em("for each state. We compared the happiness scores from this data with the "),
        a("percentages of gun ownership per state",
          href = "http://demographicdata.org/facts-and-figures/gun-ownership-statistics/"),
        em(" and the "),
        a("rate of gun related deaths per 100k people",
          href = "https://www.cdc.gov/nchs/pressroom/sosmap/firearm_mortality/firearm.htm"),
        em(" to to make insightful conclusions about the correlations between these variables. "),
        em("In order to learn more about how happiness score was calculated, follow this "),
        a("link", href = "https://wallethub.com/edu/happiest-states/6959/#methodology"),
        em("."),
        h3("Interactive Scatter Plot"),
        plotlyOutput("scatter_plot"),
        textOutput("cor"),
        textOutput("cor_message"),
        h3("Interactive Map"),
        plotlyOutput("interactive_map")
      )
    )
  ),
  #bar chart
  tabPanel(
    "Legislation",
    sidebarLayout(
      sidebarPanel(

      ),
      mainPanel(
        plotlyOutput("legislation"),
        plotlyOutput("industry")
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