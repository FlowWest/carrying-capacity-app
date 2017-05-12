source('helpers.R', local = TRUE)
source('calc_num_fish.R', local = TRUE)

territory <- territory_needs()

shinyServer(function(input, output) {
  
  #filter results based on selected reach----
  allInput <- reactive({
    req(input$stream_reach)
    filter(habitat_adults, watershed == input$stream_reach)
  })
  
  natural_spawners <- reactive({
    req(input$stream_reach)
    filter(spawners, watershed == input$stream_reach) %>% 
    select_(input$nat_adults)
  })
  
  #calc number of spawners and resulting fry----
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
             spawn = as.numeric(input$spawn))
  })
  
  # create text input with default reach values----
  output$num_adults <- renderUI({
    textInput(inputId = 'adults', label = NULL, value = ceiling(natural_spawners()), width = '220px')
  })
  
  output$spawn_hab <- renderUI({
    textInput('spawn', 'Spawning', value = ceiling(allInput()$spawning), width = '60px')
  })
  
  output$fry_hab <- renderUI({
    textInput('fry', 'Fry', value = ceiling(allInput()$fry), width = '60px')
  })
  
  # print number of spawners and fry
  output$num_fry <- renderText(pretty_num(num_spawn_fry()$fry, 0))
  output$num_spawners <- renderText(pretty_num(num_spawn_fry()$spawners, 0))
  
  #print habitat needed
  spawn_need <- reactive(pretty_num(num_spawn_fry()$spawners * 6.2 / 4046.86, 2))
  fry_need <- reactive(pretty_num(num_spawn_fry()$fry * territory[[1]] / 4046.86, 2))
  
  output$spawn_hab_need <- renderText(spawn_need())
  output$fry_hab_need <- renderText(fry_need())
  
  # print available habitat
  output$spawn_hab_available <- renderText(input$spawn)
  output$fry_hab_available <- renderText(input$fry)
  
  # print habitat limited
  output$spawn_limit <- renderText(ifelse(as.numeric(input$spawn) < as.numeric(spawn_need()), 'Yes', 'No'))
  output$fry_limit <- renderText(ifelse(as.numeric(input$fry) < as.numeric(fry_need()), 'Yes', 'No'))
  
  #Run == input$run, 
  gt <- reactive({
    filter(grandtab, River == input$stream_reach, Run %in% input$run)
  })
  
  
  dbd <- reactive({
    doubling %>% 
      filter(watershed == input$stream_reach, run == input$run)
  })
  
  output$grand_tab <- renderPlotly({
    gt() %>% 
      plot_ly(x = ~year, y = ~Count, type = 'bar', marker = list(color = 'rgb(68, 68, 68)')) %>% 
      add_trace(data = dbd(), x = c(1974,2015), y = ~goal, type = 'scatter', line = list(dash = 'dash'), 
                hoverinfo = 'text', text = ~paste('Doubling Goal', goal)) %>% 
      layout(yaxis = list(title = 'count'), showlegend = FALSE) %>% 
      config(displayModeBar = FALSE)
  })
  
})