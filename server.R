library(shiny)
library(shinythemes)
library(plotly)
library(tidyverse)



source('helpers.R')
source('calc_num_fish.R')

habitat_adults <- filter(read_rds('data/reach_habitat.rds'), adults > 0)
territory <- territory_needs()



shinyServer(function(input, output) {
  
  allInput <- reactive({
    req(input$stream_reach)
    filter(habitat_adults, watershed == input$stream_reach)
  })
  
  
  #TODO- figure out how to get values from adjustable inputs with reactive defaults
  num_spawn_fry <- reactive({
    calc_num_fish(adults = as.numeric(input$adults),
             retQ = allInput()$retQ,
             SCDELT = allInput()$SCDELT,
             hatch.alloc = allInput()$hatch.alloc,
             TISD = allInput()$TISD,
             YOLO = allInput()$YOLO,
             p.tempMC2025 = allInput()$p.tempMC2025,
             A.HARV = allInput()$A.HARV,
             P.scour.nst = allInput()$P.scour.nst,
             egg.tmp.eff = allInput()$temp_eff,
             degday = allInput()$degday,
             spawn = as.numeric(input$spawn),
             order = allInput()$order)
  })
  

  output$spawn_hab <- renderUI({
    textInput('spawn', 'Spawning', value = ceiling(allInput()[[3]]), width = '60px')
  })
  
  output$fry_hab <- renderUI({
    textInput('fry', 'Fry', value = ceiling(allInput()[[4]]), width = '60px')
  })
  
  output$num_adults <- renderUI({
    textInput('adults', 'Returning Adults', value = ceiling(allInput()[[6]]), width = '60px')
  })

  output$num_fry <- renderText(num_spawn_fry()$fry)
  
  output$num_spawners <- renderText(num_spawn_fry()$spawners)
  
  output$spawn_hab_need <- renderText(num_spawn_fry()$spawners * 6.2 / 4046.86)
  output$fry_hab_need <- renderText(num_spawn_fry()$fry * territory[[1]] / 4046.86)
  
  #TODO-once number of fry calculator works, apply territory needs given available habitats
  
  #TODO - figure out parr calculator, take number at maximum parr present (month 3?)
  
})