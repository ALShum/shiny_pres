---
title       : Introduction to Shiny
subtitle    : 
author      : Alex Shum
job         : 
framework   : revealjs        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : [mathjax]            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## Introduction to Shiny 

Alex Shum

November 18, 2015

---

## About Me
<img src="bio-photo.jpg" alt="bio" style="width: 250px;"/> #"

Languages: R, Java, C/C++, Python

Github: www.github.com/ALShum <br/>
URL: www.ALShum.com  <br/>
Twitter: @NotAlexShum

--- &vertical

## What is Shiny?

* An R package for building interactive web applications.
* Open source.  Developed by R Studio.
* Rmarkdown and knitr are great but not interactive.
* Share data analysis without need for programming.

***

## Motivation
* Too much data to make simple overview plots.
* Models too complex for a few simple diagnostics.
* Working with non-R users.
* User facing applications built on top of R.

***

## Examples

* https://gallery.shinyapps.io/Ebola-Dynamic/
* Graphics generated using ggplot2
* Slider controls feedback input to ggplot2
* Plots regenerate when controls change

***

## How does it work?

* Uses R as a backend for data.
* Use R data structures, R packages and R graphics.
* Front end built using HTML, Javascript and CSS.
* No HTML, Javascript or CSS knowledge necessary.

***

## Advanced Options

* Supports integration with D3.js.
* Support for many libraries built on top of D3.
* Dygraphs, leaflet, Google charts and others.
* Custom CSS and javascript.

--- 

## Requirements

* For running shiny code locally
  - R
  - Shiny Package (on CRAN)
* For hosting web applications
  - Linux server
  - Shiny-server software

--- &vertical

## Simple example User Interface


```r
library(shiny)
shinyUI(
  fluidPage(
    titlePanel("Hello World!"),

    sidebarPanel(
      sliderInput("obs", 
        "Number of observations:", 
        min = 1,
        max = 1000, 
        value = 500)
    ),
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
)
```

***

## Simple example Server Code


```r
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
```

***

## Shiny design flow
* User interface contained in `shinyUI` function -- often in its own file: `ui.R`.
* Server logic contained inside `shinyServer` -- often in its own file: `server.R`.
* User interface, takes user input and displays output.
  - Controls buttons, messages, menus etc.
  - Can be built without any HTML, CSS or Javascript knowledge.
* Server function take input from UI and has full access to R packages.

***

## Shiny design flow 2
* New data entered from UI is automatically detected.
* New data prompts an internal update.
* All functions and plots using this data are regenerated.
* This is done automatically using reactively.

***

## Reactive Programming


```r
A = 100
B = A + 1
A = 200
```

What is the value of `B` at the end of this code segment?

* Normal R: `B == 101`
* Reactive R: `B == 201`

***

## Shiny logic flow

* Data input from "Reactive Source"
  - Typically user input from browser interface.
  - Example: select an item, click a button, enter in a value.
* Data from "Reactive Source" processed using R
  - Take user input and run further calculations.
  - Example: calculate summary statistics on user input data.
* Data output as "Reactive endpoint"
  - Reactive endpoint displays result to user.
  - Example: Plot data after processing.

--- &vertical

## More complicated example

ui.R


```r
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
```

***

## More complicated example

Server.R


```r
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

    output[["dygraph1"]] = renderDygraph({
      dygraphs::dygraph(rct_get_data())
    })
  }
)
```
***
## Server and UI Design
* UI does not contain any functions that process data.
* Server function has `input` and `output` parameters.
  - These are `reactiveValues` -- lists of reactive types.
  - `input` is a reactiveValues list for data from the UI.
  - `output` is a reactiveValues list with plots and output for the UI.

***

## Reactive Types


```r
shinyServer(
  function(input, output, session) {
```
* Reactive Source:
  - `input`: `reactiveValues` list from UI
* Reactive Endpoint:
  - `output`: `reactiveValues` list to UI
* `Session` contains other metadata for shiny

*** 

## Reactive Types


```r
    rct_get_data = reactive({
      validate(
        need(rv_data$forecast_xts, "Please query data from server")
      )
      print("test")
      rv_data$forecast_xts
    })
```
Reactive Conductor:
* `rct_get_data`: `reactive` is a type of reactive function.  
* This function will run any time any of the reactive expressions inside the function change.
* In above example, this will detect when new time series data is available, validate the data and return it.

*** 

## Reactive Types


```r
    observeEvent(
      eventExpr = input[["submit_loc"]],
      handlerExpr = {
        data = rwunderground::hourly10day(input[["location_id"]])
        data_temp = data["temp"]
        forecast_xts = xts::xts(data_temp, order.by = data$date)
        rv_data$forecast_xts = forecast_xts
      }
    )
```
Reactive Observers:
* Similar to `reactive` functions but they are not a function and thus have no return output.  
* Good way to update a reactiveValue based on a trigger (in this case button push).

--- &vertical

## Input Controls


```r
library(shiny)
```

***

## Output Display Types

--- &vertical

## Step by step coding

***

## Step by step coding

***

## Step by step coding

--- 

## Advanced Server Issues

* User authentication
* Handling multiple users

---

## END
<img src="Ice_King.png" alt="ik" style="width: 250px;"/>
