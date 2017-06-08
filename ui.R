shinyUI(fluidPage(
  titlePanel('', windowTitle = 'Chinook Carrying Capacity'),
  theme = shinytheme('cosmo'),
  tags$header(includeCSS('styles.css')),
  # title + branding
  fluidRow(
    column(width = 12, id = 'title',
           tags$a(tags$img(src = 'greylogo.png', width = '200px'), href = 'https://www.flowwest.com', 
                  target = '_blank'),
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
                 radioButtons(inputId = 'ic_fp', label = NULL, choices = c('in channel', 'flood plain', 'both')),
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
           tabsetPanel(
             tabPanel(title = 'Calculator',
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
                      )
             ),
             tabPanel(
               title = 'Notes',
               fluidRow(
                 column(width = 10,
                        tags$h3('Calculator Details'),
                        tags$p('For each watershed in the salmon population model, 
                    the calculator returns available spawning and rearing 
                    habitat. Documentation on the sources for these 
                    values is available here.'),
                        tags$p('Each watershed also has a range of returning adults 
                    used over the twenty-year period modeled, including: 
                    initial year, maximum, minimum, and mean. Returning adults
                    are potential spawners swimming towards the watershed at 
                    the Golden Gate Bridge. Actual spawners in the watershed 
                    could be greater or less than the returning adults based 
                    on the combined effects of mortality, straying, and 
                    hatchery effects. Documentation here.'),
                        tags$p('Spawning pairs that successfully reach the watershed 
                    require 133 square feet of spawning habitat. Total 
                    spawning habitat in each watershed is presented in acres. 
                    If there are more spawners than available habitat, the 
                    watershed is considered “Habitat Limited.” If a watershed 
                    is Habitat Limited, then additional spawners will not 
                    produce additional juveniles.'),
                        tags$p('Each successful spawning pair will produce juveniles 
                    at a rate that varies by watershed. Factors influencing
                    juvenile production include fecundity, temperatures, 
                    probability of scour, and probability of dewatering. 
                    Documentation here.'),
                        tags$p('Maximum habitat requirement in the watersheds occurs 
                    when the maximum number of fish are present, typically 
                    immediately after emergence. Territory requirements for 
                    small juvenile salmon (fork length < 42 mm) is approximately
                    0.5 square feet per fish. If there are more fish than
                    habitat available, a watershed is considered “habitat limited.”'),
                        tags$p('Grand Tab escapement estimates and the CVPIA doubling
                    goal for each watershed are presented in order to provide 
                    context for modeling output.'),
                        tags$p('App created and maintained by', 
                               tags$a('Sadie Gill', href = 'mailto:sgill@flowwest.com', target = '_blank'))))
               
             )
           ))
    
  )
))