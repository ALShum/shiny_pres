library(shiny)
# Define server logic required to generate and plot a random distribution
shinyServer(
  function(input, output) {
    output$distPlot <- renderPlot({
      dist <- rnorm(input$obs)
      hist(dist)
    })
  }
)