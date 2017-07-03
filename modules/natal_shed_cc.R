natal_shed_ccUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    column(id='controls_col', width = 3,
           div(id='controls',
               selectInput(ns('stream_reach'), 'Reach', 
                           choices = habitat_adults$watershed, selected = 'Merced River',
                           width = '220px'),
               tags$h4('Habitat Available (Acres)'),
               div(
                 radioButtons(inputId = ns('ic_fp'), label = NULL, choices = c('in channel', 'flood plain', 'both')),
                 uiOutput(ns('spawn_hab')),
                 uiOutput(ns('fry_hab'))
               ),
               tags$h4('Model Simulated Number of Natural Spawners'),
               div(
                 uiOutput(ns('num_adults')),
                 radioButtons(inputId = ns('nat_adults'), label = NULL, 
                              choices = c('initial', 'max', 'min', 'mean'), 
                              inline = TRUE),
                 tags$h4('Estimates are derived from the Central Valley Project Improvement Act salmon population model 
                                as developed by the Science Integration Team.'),
                 tags$h4('App created and maintained by', 
                         tags$a('Sadie Gill', href = 'mailto:sgill@flowwest.com', target = '_blank'))
               )
           )
    ),
    column(width = 9,
           fluidRow(
             column(width = 5, class = 'fish',
                    div(class = 'fish_sq', 
                        tags$img(src = 'spawn.png'), 
                        tags$h4('Spawners', style = 'font-weight:bold;'),
                        div(tags$h5('Total'), textOutput(ns('num_spawners'))),
                        div(tags$h5('Available Habitat'), textOutput(ns('spawn_hab_available'))),
                        div(tags$h5('Needed Habitat'), textOutput(ns('spawn_hab_need'))),
                        div(tags$h5('Habitat Limited'), textOutput(ns('spawn_limit'))))),
             column(width = 5, class = 'fish', 
                    div(class='fish_sq', id='fry_sq', 
                        tags$img(src = 'fry.png', style='padding-top:17px;'), 
                        tags$h4('Fry', style = 'font-weight:bold;'),
                        div(tags$h5('Total'), textOutput(ns('num_fry'))),
                        div(tags$h5('Available Habitat'), textOutput(ns('fry_hab_available'))),
                        div(tags$h5('Needed Habitat'), textOutput(ns('fry_hab_need'))),
                        div(tags$h5('Habitat Limited'), textOutput(ns('fry_limit')))))),
           fluidRow(id = 'chart',
                    column(width = 11,
                           tags$h5('Grand Tab Escapement', style = 'width: 400px;'),
                           plotlyOutput(ns('grand_tab'))
                    ),
                    column(width = 1, style = 'padding-left:0;',
                           radioButtons(ns('run'), 'Run', choices = c('Fall', 'Late-Fall', 'Winter', 'Spring'),
                                        selected = 'Fall')
                    )
           ))
  )
  
} 

natal_shed_cc <- function(input, output, session) {
  
  ns <- session$ns
  
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
    textInput(inputId = ns('adults'), label = NULL, value = ceiling(natural_spawners()), width = '220px')
  })
  
  output$spawn_hab <- renderUI({
    textInput(ns('spawn'), 'Spawning', value = ceiling(allInput()$spawning), width = '60px')
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
    textInput(ns('fry'), 'Fry', value = fry_habitat(), width = '60px')
    
  })
  
  # print number of spawners and fry
  output$num_fry <- renderText(pretty_num(num_spawn_fry()$fry, 0))
  output$num_spawners <- renderText(pretty_num(num_spawn_fry()$spawners, 0))
  
  #print habitat needed
  spawn_need <- reactive(num_spawn_fry()$spawners * 6.2 / 4046.86)
  fry_need <- reactive(num_spawn_fry()$fry * territory[[1]] / 4046.86)
  
  output$spawn_hab_need <- renderText(pretty_num(spawn_need(), 2))
  output$fry_hab_need <- renderText(pretty_num(fry_need(), 2))
  
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
      add_trace(data = dbd(), x = c(1952,2015), y = ~doubling_goal, type = 'scatter', mode = 'lines+markers', 
                line = list(color = 'rgb(0, 0, 0)', dash = 'dash'), 
                hoverinfo = 'text', text = ~paste('Doubling Goal', format(doubling_goal, big.mark = ',', trim = FALSE))) %>% 
      layout(yaxis = list(title = 'count'), showlegend = FALSE) %>% 
      config(displayModeBar = FALSE)
  })
  
}