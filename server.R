library(shiny)
library(shinythemes)
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

shootings <- mass_shootings %>% 
  group_by(state) %>% 
  summarise(fatalities = sum(fatalities), injured = sum(injured),
            total_victims = sum(total_victims))
joined_data <- merge(happiness, gun_industry, by = "state")
joined_data <- full_join(joined_data, shootings, by = "state")
joined_data <- full_join(joined_data, state_deaths, by = "state")
joined_data <- full_join(joined_data, gun_ownership, by = "state")

legislation$state <- joined_data$state
crime <- select(joined_data, Violent.Crime...per.100.000..2013, state, Murder.and.nonnegligent.manslaughter..per.100K..2013, percown, industry_score)
legislation <- merge(legislation, crime, by = "state")

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
        color = joined_data$happiness_score, colors = "Reds",
        reversescale = TRUE
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
    } else if (input$yaxis == "lawtotal") {
      y <- legislation$lawtotal
      title <- "Happiness Score by Count of Gun Control Laws"
      yaxis <- "Count of Gun Control Laws"
    }
    
    p <- plot_ly(x = joined_data$happiness_score,
                 color = I("black")
                ) %>%
      add_markers(y = y,
                  text = paste(joined_data$state, "<br>", "Happiness Rank:",
                               joined_data$happiness_rank),
                  showlegend = FALSE) %>% 
      add_lines(x = joined_data$happiness_score, y = fitted(lm(y ~ joined_data$happiness_score)),
                line = list(color = "rgba(220, 0, 0, 0.62)"),
                showlegend = FALSE) %>%
      layout(title = title,
             yaxis = list(title = yaxis, zeroline = FALSE),
             xaxis = list(title = "Happiness Score", zeroline = FALSE))
  })
  
  output$cor <- renderText({
    if (input$yaxis == "percown") {
      y <- joined_data$percown
      cor <- cor(joined_data$happiness_score, y)
    } else if (input$yaxis == "rate") {
      y <- joined_data$rate
      cor <- cor(joined_data$happiness_score, y)
    } else if (input$yaxis == "lawtotal") {
      y <- legislation$lawtotal
      cor <- cor(joined_data$happiness_score, y)
    }
    correlation <- paste("Correlation:", cor)
    return(correlation)
  })
  
  output$cor_message <- renderText({
    if (input$yaxis == "percown") {
      message <- "This negative correlation shows that the higher the happiness score, the lower the percentage of gun ownership."
    } else if (input$yaxis == "rate") {
      message <- "This negative correlation shows that the higher the happiness score, the lower the rate of deaths per 100k people."
    } else if (input$yaxis == "lawtotal") {
      message <- "This positive correlation shows that there is an association between higher happiness score and a higher count of gun control laws."
    }
    return(message)
  })

  output$legis_scatter <- renderPlotly({
    if (input$legislation == 1) {
      y <- legislation$industry_score
      title <- "State Gun Legislation vs State Gun Industry"
      yaxis <- "State Gun Industry Score"
    } else if (input$legislation == 2) {
      y <- legislation$percown
      title <- "State Gun Legislation vs State Gun Ownership Percentage"
      yaxis <- "State Percent Gun Ownership"
    } else if (input$legislation == 3){
      y <- legislation$Violent.Crime...per.100.000..2013
      title <- "State Gun Legislation vs State Violent Crime per 100K"
      yaxis <- "State Violent Crime per 100,000"
    } else {
      y <- legislation$Murder.and.nonnegligent.manslaughter..per.100K..2013
      title <- "State Gun Legislation vs State Murder & Manslaughter per 100K"
      yaxis <- "State Murder & Manslaughter per 100,000"
    }
    p <- plot_ly(legislation, x = ~lawtotal, color = I("black")) %>%
      add_markers(y = y, text = legislation$state, showlegend = FALSE) %>%
      add_lines(x = ~lawtotal, y = ~fitted(loess(y ~ lawtotal)),
                line = list(color = "rgba(220, 0, 0, 0.62)")) %>%
      layout(yaxis = list(title = yaxis, zeroline = FALSE), xaxis = list(title = "Numer of State Gun Control Laws"),
             title = title)
    
    return(p)
    
  })
  
  output$legis_cor <- renderText({
    if (input$legislation == 1) {
      y <- legislation$industry_score
      cor <- cor(legislation$lawtotal, y)
    } else if (input$legislation == 2) {
      y <- legislation$percown
      cor <- cor(legislation$lawtotal, y)
    } else if (input$legislation == 3){
      y <- legislation$Violent.Crime...per.100.000..2013
      cor <- cor(legislation$lawtotal, y)
    } else {
      y <- legislation$Murder.and.nonnegligent.manslaughter..per.100K..2013
      cor <- cor(legislation$lawtotal, y)
    }
    correlation <- paste("Correlation:", cor)
    return(correlation)
  })
  
  output$legis_cor_message <- renderText({
    if (input$legislation == 1) {
      message <- "This moderate negative correlation shows that state gun control negatively impacts the state's gun industry."
    } else if (input$legislation == 2) {
      message <- "This moderate negative correlation shows that state gun control somewhat reduces state gun ownership."
    } else if (input$legislation == 3) {
      message <- "This slight negative correlation shows that state gun control has a minimal effect on reducing the rate of violent crime"
    } else {
      message <- "This slight negative correlation shows that state gun control has a small impact on reducing the rate of murder and manslaughter"
    }
    return(message)
  })
  
  output$legislation_bar <- renderPlotly({
    shootings <- group_by(mass_shootings, state) %>%
      summarise(total_shootings = n())
    legislation <- merge(legislation, shootings, all = TRUE, by = "state")
    legislation[is.na(legislation)] <- 0
    legislation <- select(legislation, total_shootings, lawtotal, state)
    legislation$state <- factor(legislation$state, levels = unique(legislation$state)[order(legislation$total_shootings, decreasing = TRUE)])
    p <- plot_ly(legislation, x = ~state, y = ~lawtotal, type = "bar", name = "legislation", color = I("black")) %>%
      add_trace(y = ~total_shootings, name = "shootings", color = I("red")) %>%
      layout(yaxis = list(title = "Count"), xaxis = list(title = "State"), title = "State Gun Control VS Mass Shootings", barmode = "group")
    
    return(p)
  })
}

shinyServer(my_server)
