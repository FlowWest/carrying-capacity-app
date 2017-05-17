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
  
  fry_habitat <- reactive({
    if (input$ic_fp == 'in channel') {
      ceiling(allInput()$fry)
    } else if (input$ic_fp == 'flood plain') {
      ceiling(allInput()$fp_area_acres)
    } else {
      ceiling(allInput()$fry + allInput()$fp_area_acres)
    }
  })
  
  
  output$fry_hab <- renderUI({
    textInput('fry', 'Fry', value = fry_habitat(), width = '60px')
    
  })
  
  # print number of spawners and fry
  output$num_fry <- renderText(pretty_num(num_spawn_fry()$fry, 0))
  output$num_spawners <- renderText(pretty_num(num_spawn_fry()$spawners, 0))
  
  #print habitat needed
  spawn_need <- reactive(pretty_num(num_spawn_fry()$spawners * 6.2 / 4046.86, 2))
  fry_need <- reactive(pretty_num(num_spawn_fry()$fry * territory[[1]] / 4046.86, 2))
  
  output$spawn_hab_need <- renderText(spawn_need())
  output$fry_hab_need <- renderText(fry_need())
  
  # print available habitat?
  output$spawn_hab_available <- renderText(input$spawn)
  output$fry_hab_available <- renderText(input$fry)
  
  # print habitat limited
  output$spawn_limit <- renderText(ifelse(as.numeric(input$spawn) < as.numeric(spawn_need()), 'Yes', 'No'))
  output$fry_limit <- renderText(ifelse(as.numeric(input$fry) < as.numeric(fry_need()), 'Yes', 'No'))
  
  gt <- reactive({
    filter(grandtab, watershed == input$stream_reach, run == input$run)
  })
  
  dbd <- reactive({
    filter(doubling, watershed == input$stream_reach)
  })
  
  output$grand_tab <- renderPlotly({
    gt() %>% 
      plot_ly(x = ~year, y = ~count, type = 'bar', marker = list(color = 'rgb(68, 68, 68)'), 
              hoverinfo = 'text', text = ~paste('Year', year, '</br>Count', format(count, big.mark = ',', trim = FALSE))) %>% 
      add_trace(data = dbd(), x = c(1952,2015), y = ~doubling_goal, type = 'scatter', mode = 'lines', 
                line = list(color = 'rgb(0, 0, 0)', dash = 'dash'), 
                hoverinfo = 'text', text = ~paste('Doubling Goal', format(doubling_goal, big.mark = ',', trim = FALSE))) %>% 
      layout(yaxis = list(title = 'count'), showlegend = FALSE) %>% 
      config(displayModeBar = FALSE)
  })
  
  
  # dbd <- reactive({
  #   temp <- filter(doubling, watershed == input$stream_reach)
  #   if (is.na(temp$run)) {
  #     return(temp)
  #   } else {
  #     filter(temp, run == input$run)
  #   }
  # })
  # 
  # output$grand_tab <- renderPlotly({
  #   gt() %>% 
  #     plot_ly(x = ~year, y = ~count, type = 'bar', marker = list(color = 'rgb(68, 68, 68)'), 
  #             hoverinfo = 'text', text = ~paste('Year', year, '</br>Count', format(count, big.mark = ',', trim = FALSE))) %>% 
  #     add_trace(data = dbd(), x = c(1974,2015), y = ~goal, type = 'scatter', line = list(dash = 'dash'), 
  #               hoverinfo = 'text', text = ~paste('Doubling Goal', goal)) %>% 
  #     layout(yaxis = list(title = 'count'), showlegend = FALSE) %>% 
  #     config(displayModeBar = FALSE)
  # })
  
})