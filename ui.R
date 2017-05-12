shinyUI(fluidPage(
  titlePanel('', windowTitle = 'Chinook Carrying Capacity'),
  theme = shinytheme('cosmo'),
  tags$header(includeCSS('styles.css')),
  # title + branding
  fluidRow(
    column(width = 12, id = 'title',
           tags$img(src = 'greylogo.png', width = '200px'),
           tags$h1('Chinook Carrying Capacity Calculator', id = 'app_name')
    )),
  fluidRow(
    column(id='controls_col', width = 3,
           div(id='controls',
             selectInput('stream_reach', 'Reach', 
                         choices = habitat_adults$watershed, selected = 'Merced River',
                         width = '220px'),
             tags$h4('Habitat Available (Acres)'),
             div(
               uiOutput('spawn_hab'),
               uiOutput('fry_hab')
             ),
             tags$h4('Model Simulated Number of Natural Spawners'),
             div(
               uiOutput('num_adults'),
               radioButtons(inputId = 'nat_adults', label = NULL, 
                            choices = c('initial', 'max', 'min', 'mean'), 
                            inline = TRUE)
             )
           )
    ),
    column(width = 9,
           fluidRow(
             column(width = 5, class = 'fish',
                    div(class = 'fish_sq', 
                        tags$img(src = 'spawn.png'), 
                        tags$h4('Spawners', style = 'font-weight:bold;'),
                        div(tags$h5('Total'), textOutput('num_spawners')),
                        div(tags$h5('Available Habitat'), textOutput('spawn_hab_available')),
                        div(tags$h5('Needed Habitat'), textOutput('spawn_hab_need')),
                        div(tags$h5('Habitat Limited'), textOutput('spawn_limit')))),
             column(width = 5, class = 'fish', 
                    div(class='fish_sq', id='fry_sq', 
                        tags$img(src = 'fry.png', style='padding-top:17px;'), 
                        tags$h4('Fry', style = 'font-weight:bold;'),
                        div(tags$h5('Total'), textOutput('num_fry')),
                        div(tags$h5('Available Habitat'), textOutput('fry_hab_available')),
                        div(tags$h5('Needed Habitat'), textOutput('fry_hab_need')),
                        div(tags$h5('Habitat Limited'), textOutput('fry_limit'))))),
           fluidRow(id = 'chart',
             column(width = 11,
                    tags$h5('Grand Tab Escapement', style = 'width: 400px;'),
                    plotlyOutput('grand_tab')
             ),
             column(width = 1, style = 'padding-left:0;',
                    radioButtons('run', 'Run', choices = c('Fall', 'Late-Fall', 'Winter', 'Spring'),
                                  selected = 'Fall')
             )
           ))

  )
))