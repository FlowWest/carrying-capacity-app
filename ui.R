
shinyUI(fluidPage(
  titlePanel('', windowTitle = 'Chinook Carrying Capacity'),
  theme = 'styles.css',
  # title + branding
  fluidRow(
    column(width = 12,
           div(id = 'title',
               tags$img(src = 'logo.png', width = '250px'),
               tags$h1('Chinook Carrying Capacity')
               )
    )),
  fluidRow(
    column(width = 2,
           tags$h3(''),
           selectInput('stream_reach', 'Reach', 
                       choices = habitat_adults$watershed, selected = 'Merced River',
                       width = '220px'),
           uiOutput('num_adults')),
    column(width = 3,
           tags$h3('Habitat Available (Acres)'),
           uiOutput('spawn_hab'),
           uiOutput('fry_hab')),
    column(width = 4,
           tags$h3('Total Present'),
           div(style = 'display:inline-block;',
             div(
               tags$img(src = 'spawn.png'),
                   tags$h5('Spawners', style = 'font-weight:bold;')),
               textOutput('num_spawners')),
           div(style = 'display:inline-block;',
             div(
               tags$img(src = 'fry.png'),
               tags$h5('Fry', style = 'font-weight:bold;')
             ),
             textOutput('num_fry')
           )),
    column(width =3,
           tags$h3('Habitat Needed (Acres)'),
           tags$h5('Spawning', style = 'font-weight:bold;'),
           textOutput('spawn_hab_need'),
           tags$h5('Fry', style = 'font-weight:bold;'),
           textOutput('fry_hab_need'))
  )
#   fluidRow(
#     column(width = 3,
#            selectInput('stream_reach', 'Select Reach', 
#                        choices = habitat_adults$watershed, selected = 'Merced River',
#                        width = '220px'),
#            uiOutput('num_adults'),
#            tags$h5('Available Habitat (Acres)', style = 'font-weight:bold; width:400px;'),
#            div(id = 'size_hab',
#                uiOutput('spawn_hab'),
#                uiOutput('fry_hab')
#            )
#     ),
#     column(width = 9,
#            div(
#              tags$h3('Total Present'),
#                div(
#                  tags$img(src = 'spawn.png'),
#                  tags$h4('Spawning')),
#                textOutput('num_spawners'),
#                div(
#                  tags$img(src = 'fry.png'),
#                  tags$h4('Fry')),
#                textOutput('num_fry')
#                ),
#            div(
#              tags$h3('Habitat (Acres)'),
#              textOutput('spawn_hab_need'),
#              textOutput('fry_hab_need'))
#            
# ))
))