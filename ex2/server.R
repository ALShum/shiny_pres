library(shiny)
shinyServer(
  function(input, output, session) {
    rv_data = reactiveValues(
      forecast_xts = NULL
    )

    observeEvent(
      eventExpr = input[["submit_loc"]],
      handlerExpr = {
        data = rwunderground::hourly10day(input[["location_id"]])
        data_temp = data["temp"]
        forecast_xts = xts::xts(data_temp, order.by = data$date)
        rv_data$forecast_xts = forecast_xts
      }
    )

    rct_get_data = reactive({
      validate(
        need(rv_data$forecast_xts, "Please query data from server")
      )
      rv_data$forecast_xts
    })

    output[["dygraph1"]] = dygraphs::renderDygraph({
      dygraphs::dygraph(rct_get_data())
    })
  }
)