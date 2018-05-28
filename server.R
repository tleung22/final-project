library(shiny)
library(dplyr)
library(plotly)

mass_shootings <-
  read.csv("Data/Mother Jones - Mass Shootings Database, 1982 - 2018 - Sheet1.csv", stringsAsFactors = FALSE)
happiness <- read.csv("Data/state_happiness.csv", stringsAsFactors = FALSE)
gun_industry <- read.csv("Data/gun_industry.csv", stringsAsFactors = FALSE)
legislation <- read.csv("Data/legislation.csv", stringsAsFactors = FALSE)
gun_crime <- read.csv("Data/US gun crime - SUMMARY 2011.csv", stringsAsFactors = FALSE)
gun_ownership <- read.csv("Data/gun_ownership.csv", stringsAsFactors = FALSE)
gun_ownership$percown <- as.numeric(gsub("%", "", gun_ownership$percown))
background_checks <- read.csv("Data/nics-firearm-background-checks.csv", stringsAsFactors = FALSE)
state_deaths <- read.csv("Data/firearm2016.csv", stringsAsFactors = FALSE)

mass_shootings <- mass_shootings %>% 
  group_by(state) %>% 
  summarise(fatalities = sum(fatalities), injured = sum(injured),
            total_victims = sum(total_victims))
joined_data <- merge(happiness, gun_industry, by = "state")
joined_data <- full_join(joined_data, mass_shootings, by = "state")
joined_data <- full_join(joined_data, state_deaths, by = "state")
joined_data <- full_join(joined_data, gun_ownership, by = "state")

my_server <- function(input, output) {
  output$interactive_map <- renderPlotly({
    joined_data$hover <- with(joined_data, paste(state, "<br>", "Happiness Rank:", happiness_rank,
                              "<br>", "Gun Industry Rank:", industry_rank,
                              "<br>", "Total Victims:", total_victims))
    
    l <- list(color = toRGB("white"), width = 2)
    # specify some map projection/options
    g <- list(
      scope = "usa",
      projection = list(type = "albers usa"),
      showlakes = TRUE,
      lakecolor = toRGB("white")
    )
    
    map <- plot_geo(joined_data, locationmode = "USA-states") %>%
      add_trace(
        z = joined_data$happiness_score, text = joined_data$hover,
        locations = joined_data$state,
        color = joined_data$happiness_score, colors = "Reds"
      ) %>%
      colorbar(title = "Happiness Score") %>%
      layout(
        title = "Happiness and Gun Related Data for Each State",
        geo = g
      )
    return(map)
  })
  
  # Scatter plot
  output$scatter_plot <- renderPlotly({
    if (input$yaxis == "percown") {
      y <- joined_data$percown
      title <- "Happiness Score by Percent of Gun Ownership"
      yaxis <- "Percent of Gun Ownership"
    } else if (input$yaxis == "rate") {
      y <- joined_data$rate
      title <- "Happiness Score by Rate of Gun Related Deaths per 100k People"
      yaxis <- "Rate of Gun Related Deaths per 100k People"
    }
    p <- plot_ly(data = joined_data,
                 x = joined_data$happiness_score,
                 color = I("black")
                ) %>%
      add_markers(y = y,
                  text = paste(joined_data$state, "<br>", "Happiness Rank:",
                               joined_data$happiness_rank),
                  showlegend = FALSE) %>% 
      add_lines(y = ~fitted(loess(y ~ happiness_score)),
                line = list(color = "rgba(220, 0, 0, 0.62)"),
                showlegend = FALSE) %>%
      layout(title = title,
             yaxis = list(title = yaxis, zeroline = FALSE),
             xaxis = list(title = "Happiness Score", zeroline = FALSE))
  })


  state_ab <- as.vector(happiness$state)
  states <- as.vector(legislation$state)
  output$shootings <- renderPlotly({
    validate(need(input$radio == 1, message = FALSE))
  })

  output$casualties <- renderPlotly({
    validate(need(input$radio == 2, message = FALSE))
  })
  
  output$legislation <- renderPlotly({
    shootings <- group_by(mass_shootings, state) %>%
      summarise(total_shootings = n())
    legislation$state <- state_ab
    legislation <- merge(legislation, shootings, all = TRUE, by = "state")
    legislation[is.na(legislation)] <- 0
    validate(need(input$radio == 3, message = FALSE))
    p <- plot_ly(legislation, x = ~state, y = ~lawtotal, type = "bar", name = "legislation") %>%
      add_trace(y = ~total_shootings, name = "shootings") %>%
      layout(yaxis = list(title = "Count"), barmode = "group")
    
    return(p)
  })
}

shinyServer(my_server)
