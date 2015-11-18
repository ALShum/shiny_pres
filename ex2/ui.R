library(shiny)
shinyUI(
  fluidPage(
    titlePanel("Weather Plotter"),
    column(4,
      textInput(
        inputId = "location_id",
        label = "Enter location: ",
        value = "California/San_Diego"
      ),
      actionButton(
        inputId = "submit_loc",
        label = "Submit"
      )
    ),
    column(8,
      dygraphs::dygraphOutput("dygraph1")
    )
  )
)