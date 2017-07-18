migrants_ccUI <- function(id) {
  
  ns <- NS(id)
  
  tagList(
    fluidRow(
      column(width = 8,
             selectInput(ns('stem'), 'Select Stem',
                         choices = c('Upper-mid Sacramento River', 'Lower-mid Sacramento River',
                                     'Lower Sacramento River', 'San Joaquin River', 'North Delta', 'South Delta'),
                         selected = 'Upper-mid Sacramento River'),
             checkboxGroupInput(ns('sizes'), 'Select Sizes', choices = c('small', 'medium', 'large', 'very large'), selected = c('small', 'medium', 'large', 'very large'),
                                inline = TRUE),
             tabsetPanel(
               tabPanel('Migrants',
                        withSpinner(plotlyOutput(ns('migrants')), type = 8, color = '#666666'),
                        textOutput(ns('comment'))),
               tabPanel('Upstream Contribution',
                        tags$br(),
                        dataTableOutput(ns('monthly'))))
      ),
      column(width = 4,
             tags$br(),
             tags$img(src = 'sheds2.png', width = '85%'))
    ),
    fluidRow(
      column(width = 12,
             tags$h4('Size Class Ranges:'),
             tags$h4('small (3.75 - 4.2 cm), medium (4.2 - 7.4 cm), large (7.4 - 11 cm), very large (>11 cm)')
             )
    )
  )
  
}

migrants_cc <- function(input, output, session) {
  
  values <- reactiveValues(click_month = NULL)
  
  observeEvent(input$stem, {
    values$click_month <- NULL
  })
  
  observeEvent(event_data('plotly_click'), {
    values$click_month = event_data('plotly_click')$key
  })
  
  plotd <- reactive({
    migr %>% 
      dplyr::filter(location == input$stem, size %in% input$sizes, count > 1) 
  })
  
  output$migrants <- renderPlotly({
    validate(
      need(dim(plotd())[1] > 0, 'No fish in this size class')
    )
    
    plotd() %>% 
      plot_ly(x = ~factor(month.name[month], month.name), y = ~count, color = ~size, key = ~month, type = 'bar', hoverinfo = 'text',
              text = ~paste(month.name[month], '<br>', 
                            pretty_num(count, 0), size),
              colors = 'Dark2') %>% 
      layout(barmode = 'stack', xaxis = list(title = 'month')) %>% 
      config(displayModeBar = FALSE)
    
  })
  
  contributions <- reactive({
    
    tots <- migr %>%
      dplyr::filter(location == input$stem, count > 1) %>% 
      dplyr::group_by(location, month, size) %>% 
      dplyr::summarise(`stem total` = sum(count))
    
    perc <- migr %>%
      dplyr::filter(location == input$stem, count > 1) %>% 
      dplyr::group_by(location, month, size, watershed) %>% 
      dplyr::summarise(`shed total` = sum(count)) %>% 
      dplyr::ungroup() %>% 
      dplyr::left_join(tots) %>% 
      dplyr::mutate(percent = `shed total`/`stem total` * 100) %>% 
      dplyr::select(month, watershed, size, percent, `shed total`, `stem total`) %>% 
      dplyr::filter(percent > 1) %>% 
      dplyr::mutate(percent = paste(pretty_num(percent), '%'),
                    `shed total` = pretty_num(`shed total`),
                    `stem total` = pretty_num(`stem total`))
    
    perc %>% 
      dplyr::filter(month == values$click_month) %>% 
      dplyr::mutate(month = month.name[month])
    
  })
  
  output$monthly <- renderDataTable({
    validate(
      need(!is.null(values$click_month), 'Click on a month on the chart')
    )
    
    DT::datatable(dplyr::filter(contributions(), size %in% input$sizes), rownames = FALSE)
  })
  
  
  more_terr <- reactive({
    contributions() %>% 
      dplyr::group_by(size) %>% 
      dplyr::summarise(total = max(parse_number(`stem total`))) %>% 
      dplyr::mutate(more = total * territory[size] * 0.000247105) %>% 
      dplyr::ungroup() %>% 
      dplyr::summarise(mores = sum(more)) %>% 
      magrittr::extract2(1)
  })
  
  
  output$comment <- renderText({
    validate(
      need(!is.null(values$click_month), 'Click on a month on the chart')
    )
    if (input$stem %in% c('North Delta', 'South Delta')) {
      paste0('Currently there are ', pretty_num(dplyr::filter(habitat, watershed == input$stem)[[2]]), ' acres of rearing habitat in the ',
             input$stem, '. In ', month.name[as.numeric(values$click_month)], ', an additional ', pretty_num(more_terr()), 
             ' acres of rearing habitat is needed to prevent out migration.')
    } else {
    paste0('Currently there are ', pretty_num(dplyr::filter(habitat, watershed == input$stem)[[2]]), 
           ' acres of in-channel rearing habitat in the ', 
           input$stem, '. In ', month.name[as.numeric(values$click_month)], ', an additional ', pretty_num(more_terr()), 
           ' acres of rearing habitat is needed to prevent out migration. Floodplain habitat is activated
           when flow exceeds ', 
           pretty_num(dplyr::pull(dplyr::filter(flow_notes, Watershed == input$stem), `Floodplain Threshold`)),
           ' cfs, creating an additional ',
           pretty_num(dplyr::pull(dplyr::filter(fp_accum, stems == input$stem), fp_area_acres)),
           ' acres of rearing habitat.')
    }
  })
  
}