
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
    column(id='controls', width = 3,
      selectInput('stream_reach', 'Reach', 
                  choices = habitat_adults$watershed, selected = 'Merced River',
                  width = '220px'),
      uiOutput('num_adults'),
      tags$h3('Habitat Available (Acres)'),
      uiOutput('spawn_hab'),
      uiOutput('fry_hab')
    ),
    column(width = 9,
           div(id='spawn_sq',
               div(tags$img(src = 'spawn.png'), tags$h5('Spawners', style = 'font-weight:bold;')),
               div(tags$h5('Total', style = 'font-weight:bold;'), textOutput('num_spawners')),
               div(tags$h5('Available Habitat', style = 'font-weight:bold;'), textOutput('spawn_hab_available')),
               div(tags$h5('Needed Habitat', style = 'font-weight:bold;'), textOutput('spawn_hab_need'))),
           div(id='fry_sq',
               div(tags$img(src = 'fry.png'), tags$h5('Fry', style = 'font-weight:bold;')),
               div(tags$h5('Total', style = 'font-weight:bold;'), textOutput('num_fry')),
               div(tags$h5('Available Habitat', style = 'font-weight:bold;'), textOutput('fry_hab_available')),
               div(tags$h5('Need Habitat', style = 'font-weight:bold;'), textOutput('fry_hab_need')))
           )
  )
))