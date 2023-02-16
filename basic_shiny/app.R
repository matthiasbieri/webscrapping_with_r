
library(shiny)
library(leaflet)
library(dplyr)
library(ggplot2)

ui <- fluidPage(
  tabsetPanel(
    tabPanel("Map", leafletOutput("map")),
    tabPanel("Graph",
             selectInput("zipname", "Zip/Name:", choices = unique(df$zip_name)),
             plotOutput("boxplot")
    )
  )
)

server <- function(input, output) {
  
  # Load the data
  df <- read.csv("df_for_Shiny.csv")
  
  # Create a reactive function for the filtered data
  filtered_data <- reactive({
    df %>%
      filter(zip_name == input$zipname) %>%
      na.omit()
  })
  
  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addMarkers(data = filtered_data(), ~lon, ~lat, popup = ~paste0(zip_name, "<br>$", prices))
  })
  
  # Create the boxplot
  output$boxplot <- renderPlot({
    ggplot(filtered_data(), aes(x = factor(zip_name), y = prices)) +
      geom_boxplot() +
      labs(x = "Zip/Name", y = "Price (CHF)")
  })
  
}

shinyApp(ui, server)

