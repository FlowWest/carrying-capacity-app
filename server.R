library(shiny)
library(shinythemes)
library(plotly)
library(tidyverse)
library(readr)


source('utils.R')

habitat_adults <- read_rds('data/reach_habitat.rds')
territory <- territory_needs()

shinyServer(function(input, output) {
  
  spawnInput <- reactive({
      ceiling(filter(habitat_adults, watershed == input$stream_reach)[[4]])
  })
  
  fryInput <- reactive({
    ceiling(filter(habitat_adults, watershed == input$stream_reach)[[5]])
  })
  
  parrInput <- reactive({
    ceiling(filter(habitat_adults, watershed == input$stream_reach)[[6]])
  })
  
  adultInput <- reactive({
    ceiling(filter(habitat_adults, watershed == input$stream_reach)[[3]])
  })
  
  output$spawn_hab <- renderUI({
    req(input$stream_reach)
    textInput('spawn', 'Spawning', value = spawnInput()) 
  })
  
  output$fry_hab <- renderUI({
    req(input$stream_reach)
    textInput('fry', 'Fry', value = fryInput()) 
  })
  
  output$parr_hab <- renderUI({
    req(input$stream_reach)
    textInput('parr', 'Parr', value = parrInput()) 
  })
  
  output$num_adults <- renderUI({
    req(input$stream_reach)
    textInput('adults', 'Returning Adults', value = adultInput())
  })
  
})