library(shiny)
library(shinythemes)
library(plotly)
library(tidyverse)
library(readr)


source('helpers.R')
source('calc_fry.R')

habitat_adults <- filter(read_rds('data/reach_habitat.rds'), adults > 0)
territory <- territory_needs()

shinyServer(function(input, output) {
  
  allInput <- reactive({
    filter(habitat_adults, watershed == input$stream_reach)
  })
  
  output$spawn_hab <- renderUI({
    req(input$stream_reach)
    textInput('spawn', 'Spawning', value = ceiling(allInput()[[3]]), width = '60px')
  })

  output$fry_hab <- renderUI({
    req(input$stream_reach)
    textInput('fry', 'Fry', value = ceiling(allInput()[[4]]), width = '60px')
  })

  output$parr_hab <- renderUI({
    req(input$stream_reach)
    textInput('parr', 'Parr', value = ceiling(allInput()[[5]]), width = '60px')
  })
  
  output$num_adults <- renderUI({
    req(input$stream_reach)
    textInput('adults', 'Returning Adults', value = ceiling(allInput()[[6]]), width = '60px')
  })
  
  #TODO- figure out how to get values from adjustable inputs with reactive defaults
  num_fry <- reactive({
    req(input$stream_reach)
    calc_fry(adults = allInput()[[6]],
             retQ = allInput()[[16]],
             SCDELT = allInput()[[7]],
             hatch.alloc = allInput()[[11]],
             TISD = allInput()[[13]],
             YOLO = allInput()[[12]],
             p.tempMC2025 = allInput()[[8]],
             A.HARV = allInput()[[10]],
             P.scour.nst = allInput()[[9]],
             egg.tmp.eff = allInput()[[14]],
             degday = allInput()[[15]],
             spawn = allInput()[[3]])
  })

  output$num_fry <- renderText(num_fry())
  
  #TODO-once number of fry calculator works, apply territory needs given available habitats
  
  #TODO - figure out parr calculator, take number at maximum parr present (month 3?)
  
})