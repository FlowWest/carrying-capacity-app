
shinyUI(fluidPage(
  titlePanel('', windowTitle = 'Chinook Carrying Capacity'),
  theme = 'styles.css',
  # title + branding
  fluidRow(
    column(width = 12,
           div(id = 'title',
               tags$img(src = 'logo.png', width = '250px'),
               tags$h1('Chinook Carrying Capacity'))
    )), 
  fluidRow(
    column(width = 3,
           selectInput('stream_reach', 'Select Reach', 
                       choices = habitat_adults$watershed, selected = 'Merced River',
                       width = '220px'),
           uiOutput('num_adults'),
           tags$h5('Available Habitat (Acres)', style = 'font-weight:bold; width:400px;'),
           div(id = 'size_hab',
               uiOutput('spawn_hab'),
               uiOutput('fry_hab')
           )
    ),
    column(width = 9,
           tags$h3('Habitat Needed (Acres)'),
           tags$h4('Spawning'),
           textOutput('num_spawners'),
           textOutput('spawn_hab_need'),
           tags$h4('Fry'),
           textOutput('num_fry'),
           textOutput('fry_hab_need')
))))