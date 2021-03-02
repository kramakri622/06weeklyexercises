

library(shiny)
library(tidyverse)

covid19 <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv")

covid19_states <- covid19 %>% select(state) %>% distinct(state) %>% arrange(state) %>% pull(state)

ui <- fluidPage("COVID-19 Cases by State",
  selectInput(inputId = "state",
              label = "Pick which states to graph",
              choices = covid19_states,
              multiple = TRUE),
  plotOutput(outputId = "covid19plot"))

server <- function(input, output) {
  output$covid19plot <- renderPlot(
    covid19 %>%
    filter(state %in% input$state) %>%
      ggplot(aes(x = date, y = cases, color = state)) +
      geom_line() +
      scale_y_log10() +
      theme_minimal() +
      labs(title = "Cumulative Number of COVID-19 Cases",
           x = "",
           y = "")
  )
}
shinyApp(ui = ui, server = server)