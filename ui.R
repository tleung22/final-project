library(shiny)
library(dplyr)
library(plotly)
library(shinythemes)

ui <- navbarPage(
  # returns a theme
  theme=shinytheme("slate"),
  
  "Application Title",
  
  
  
  # Introduction tab
  tabPanel(
    "Introduction",
    includeCSS("www/style.css"),
    div(class = "center",
      h1("Why It Matters"),
      em("The United States has been vicitim to 101 mass shootings this calendar,"),
      em("accroding to the following article by"),
      a("Business Insider",
        href = "http://www.businessinsider.com/how-many-mass-shootings-in-america-this-year-2018-2","."),
      em("More worrisome however, is the continious lack of action from our elected officials in Washington D.C."),
      em("to get anything done in order to address this ongoing issue that has claimed so many innoncent lives."),
      h2("Our Purpose"),
      em("Our mission behind this project is not take sides or shift the blame from one side to another!"),
      em("Instead, our goal is to simply prompt awareness to an issue that has almost become like something of a"),
      em("normality nowadays, unfortunately. Furthermore, we want to make it very clear that this no way, shape, or form"),
      em(" mean't to come off as a"), strong("attack"),
      em("or"), strong("challenge"), em("to gun owners and those who believe and support the 2nd Amendment."),
      em("Instead, the goal of our work to spurr healthy dialogue amongst all spectrums so that we can all work"),
      em("together to find a solution. No kid should be afraid to attend school and no parent should have to fear"),
      em("for their child's safety."),
      h3("Meet The Team:")
    ),
    flowLayout(
      div( class = "caption",
        tags$img(src= '33895746_1417277445084602_4308802712805310464_n.jpg', height =200, width =200),
        p(em("Varun Patel"))
      ),
      div( class = "caption",
        tags$img(src= '33850842_961835110646127_8613901815181737984_n.jpg', height =200, width = 200),
        p(em("Logan Selley"))
      ),
      div( class = "caption",
        tags$img(src= '33835367_2093832907496109_6306088030159503360_n.jpg', height = 200, width = 200),
        p(em("Trevor Leung"))
      ),
      div( class = "caption",
        tags$img(src = 'IMG_3992.jpg', height = 200, width = 200),
        p(em("Jose Aguirre"))
      )
    )
  
    
    
  ),
  
  # Happiness tab
  tabPanel(
    "Happiness",
    sidebarLayout(
      sidebarPanel(
        radioButtons("yaxis", "View Happiness Score by Rate of Gun Related Deaths per 100k People, Percent of Gun Ownership, or the Count of Gun Control Laws:",
                     choiceNames = c("Rate of Gun Related Deaths per 100k People", "Percent of Gun Ownership", "Count of Gun Control Laws"),
                     choiceValues = c("rate", "percown", "lawtotal")
                     
                     
        )
      ),
      mainPanel(
        div(class = "center",
          h1("Comparing State Happiness with Gun Related Data"),
          em("Are happier states "), strong("safer"),
          em("? We took data from wallet hub where they took in multiple factors "),
          em("like depression rates and average income to calculate a happiness score "),
          em("for each state. We compared the happiness scores from this data with the "),
          a("percentages of gun ownership per state",
            href = "http://demographicdata.org/facts-and-figures/gun-ownership-statistics/"),
          em(", "),
          a("rate of gun related deaths per 100k people",
            href = "https://www.cdc.gov/nchs/pressroom/sosmap/firearm_mortality/firearm.htm"),
          em(" and the "),
          a("count of gun control laws",
            href = "https://www.statefirearmlaws.org/table.html"),
          em(" to make insightful conclusions and correlations between these variables. "),
          em("In order to learn more about how happiness score was calculated, follow this "),
          a("link", href = "https://wallethub.com/edu/happiest-states/6959/#methodology"),
          em("."),
          h3("Interactive Scatter Plot"),
          br(),
          plotlyOutput("scatter_plot"),
          textOutput("cor"),
          textOutput("cor_message"),
          br(),
          p("The following map is color coded by happiness rank. Useful information such as the happiness rank out of all the states, gun industry rank, which ranks the states by how much a state relies on the firearm industry, and total victims of mass shootings."),
          h3("Interactive Map")
        ),
        br(),
        plotlyOutput("interactive_map")
      )
    )
  ),
  #bar chart
  tabPanel(
    "Legislation",
    sidebarLayout(
      sidebarPanel(
        radioButtons("legislation", label = h3("Legislation Comparisons"),
          choices = list("Gun Industry" = 1, "Gun Ownership" = 2, "Violent Crime" = 3, "Murder & Manslaughter" = 4) 
          )
      ),
      mainPanel(
        div(class = "center",
          h1("Analyzing the effects of State Legislated Gun Control"),
          em("Due to a lack of federal action, many have looked to state legislatures to pass gun control laws"),
          em(" in order to stem the epidemic of gun violence in the country. But is this legislation effective"),
          em(" in keeping our communities safe? And what might be keeping state legislatures from implementing"),
          em(" this reform?"),
          br(),
          br(),
          strong("DATA & METHODOLOGY:"),
          br(),
          a("Mother Jones mass shooting data", href = "https://www.motherjones.com/politics/2012/12/mass-shootings-mother-jones-full-data/"),
          br(),
          a("WalletHub gun industry data", href = "https://wallethub.com/edu/states-most-dependent-on-the-gun-industry/18719/"),
          br(),
          a("State Firearm Laws", href = "https://www.statefirearmlaws.org/table.html"),
          br(),
          a("State gun crime/ownership", href = "http://demographicdata.org/facts-and-figures/gun-ownership-statistics/"),
          br(),
          br(),
          plotlyOutput("legis_scatter"),
          textOutput("legis_cor"),
          textOutput("legis_cor_message"),
          br(),
          br(),
          plotlyOutput("legislation_bar")
        )
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