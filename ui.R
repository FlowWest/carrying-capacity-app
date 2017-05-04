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
    column(id='controls', width = 3,
      selectInput('stream_reach', 'Reach', 
                  choices = habitat_adults$watershed, selected = 'Merced River',
                  width = '220px'),
      uiOutput('num_adults'),
      tags$h4('Habitat Available (Acres)'),
      div(
        uiOutput('spawn_hab'),
        uiOutput('fry_hab')
      )
    ),
    column(width = 4, class = 'fish',
           div(class = 'fish_sq', 
               tags$img(src = 'spawn.png'), 
               tags$h4('Spawners', style = 'font-weight:bold;'),
               div(tags$h5('Total'), textOutput('num_spawners')),
               div(tags$h5('Available Habitat'), textOutput('spawn_hab_available')),
               div(tags$h5('Needed Habitat'), textOutput('spawn_hab_need')),
               div(tags$h5('Habitat Limited'), textOutput('spawn_limit')))),
    column(width = 4, class = 'fish', 
           div(class='fish_sq', id='fry_sq', 
               tags$img(src = 'fry.png', style='padding-top:17px;'), 
               tags$h4('Fry', style = 'font-weight:bold;'),
               div(tags$h5('Total'), textOutput('num_fry')),
               div(tags$h5('Available Habitat'), textOutput('fry_hab_available')),
               div(tags$h5('Needed Habitat'), textOutput('fry_hab_need')),
               div(tags$h5('Habitat Limited'), textOutput('fry_limit'))))
  )
))