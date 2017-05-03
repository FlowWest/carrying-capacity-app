
shinyUI(fluidPage(
  titlePanel('', windowTitle = 'Chinook Carrying Capacity'),
  theme = 'styles.css',
  # title + branding
  fluidRow(
    column(width = 12, id = 'title',
           tags$img(src = 'greylogo.png', width = '200px'),
           tags$h1('Chinook Carrying Capacity Calculator', id = 'app_name')
    )),
  fluidRow(
    column(id='controls', width = 2,
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
    column(width = 3, class = 'fish',
           div(id='fish_sq', class = 'fish_sq', 
               tags$img(src = 'spawn.png'), 
               tags$h4('Spawners', style = 'font-weight:bold;'),
               div(tags$h5('Total', style = 'font-weight:bold;'), textOutput('num_spawners')),
               div(tags$h5('Available Habitat', style = 'font-weight:bold;'), textOutput('spawn_hab_available')),
               div(tags$h5('Needed Habitat', style = 'font-weight:bold;'), textOutput('spawn_hab_need')),
               div(tags$h5('Habitat Limited', style = 'font-weight:bold;'), textOutput('spawn_limit')))),
    column(width = 3, class = 'fish', 
           div(class='fish_sq',
               tags$img(src = 'fry.png', style='padding-top:17px;'), 
               tags$h4('Fry', style = 'font-weight:bold;'),
               div(tags$h5('Total', style = 'font-weight:bold;'), textOutput('num_fry')),
               div(tags$h5('Available Habitat', style = 'font-weight:bold;'), textOutput('fry_hab_available')),
               div(tags$h5('Need Habitat', style = 'font-weight:bold;'), textOutput('fry_hab_need')),
               div(tags$h5('Habitat Limited', style = 'font-weight:bold;'), textOutput('fry_limit'))))
  )
))