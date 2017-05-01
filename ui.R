
shinyUI(fluidPage(
  titlePanel('', windowTitle = 'Chinook Carrying Capacity'),
  theme = 'styles.css',
  # title + branding
  fluidRow(
    column(width = 12,
           div(id = 'title',
             tags$img(src = 'logo.png', width = '250px'),
             tags$h1('Chinook Carrying Capacity')))
  ), 
  fluidRow(
    column(width = 12,
           div(style = 'display:inline-flex;',
             selectInput('stream_reach', 'Select Reach', 
                         choices = habitat_adults$watershed, selected = 'Merced River',
                         width = '250px'),
             div(
               tags$h5('Available Habitat (Acres)', style = 'font-weight:bold; width:400px;'),
               div(id = 'size_hab',
                 uiOutput('spawn_hab'),
                 uiOutput('fry_hab'),
                 uiOutput('parr_hab')
               )
             ),
             uiOutput('num_adults')
           
             ))
  ), # controls
  fluidRow(), # return values
  fluidRow() # graph
))