notesUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    fluidRow(
      column(width = 10, style = 'padding-left: 30px;',
             tags$h2('Chinook Carrying Capacity Calculator'),
             tags$h4('An interactive tool for estimating how much habitat is required for Chinook salmon in Central 
                     Valley watersheds during the adult and juvenile life stages.'),
             tags$br(),
             tags$p('Users can select watersheds within the Central Valley that produce Chinook salmon, and the 
                    calculator will return initial spawners, resulting fry, available habitat, river flow required 
                    to support habitat type, and whether the watershed is habitat limited for a specific life stage.
                    Users can toggle between in-channel and floodplain habitat and can change the amount of habitat 
                    available or the number of potential spawners. Documentation on the sources for these input values 
                    for the model is available', 
                    tags$a(href = 'https://s3-us-west-2.amazonaws.com/carrying-capacity/CoarseResolutionPlanningTool+Report.pdf',
                           'here.', target = '_blank')), 
             tags$br(),
             tags$p('Each watershed has a range of “Model Simulated Number of Natural Spawners” used over the twenty-year
                  period modeled: initial year, maximum, minimum, and mean. Natural Spawners are returning adults 
                  swimming towards the watershed at the Golden Gate Bridge. Actual spawners in the watershed could be 
                  greater or less than the Natural Spawners based on the combined effects of mortality, straying, and
                  proximity to a hatchery.'),
             tags$br(),
             tags$p('Spawning pairs that successfully reach the watershed require 133 square feet of spawning habitat 
                  (12.4 square meters) to form a redd. Total spawning habitat in each watershed is presented in acres 
                  (43,560 square feet or 4,047 square meters per acre). If there are more spawners than available 
                  habitat, the watershed is considered “habitat limited” and additional spawners will not produce 
                  additional juveniles.'),
             tags$br(),
             tags$p('Each successful spawning pair will produce juveniles at a rate that varies by watershed. Factors 
                  influencing juvenile production include fecundity, temperatures, probability of scour, and probability 
                  of dewatering.'),
             tags$br(),
             tags$p('Maximum habitat requirement in the watersheds occurs when the maximum number of fish are present, 
                  typically immediately after emergence. Territory requirements for small juvenile salmon 
                  (fork length < 42 mm) is approximately 0.5 square feet per fish (0.05 square meter per fish). If 
                  there are more fish than habitat available, a watershed is considered “habitat limited.” Territory 
                  requirements are assumed to be the same for both in-channel and floodplain, although the model assumes
                  that fish will preferentially fill floodplain habitat first, in-channel habitat second, with any 
                  remaining juveniles migrating downstream out of the watershed. The model allows juveniles to occupy 
                  floodplain habitat if threshold flows occur, which vary monthly according to historical hydrology in 
                  any modeled year.'),
             tags$br(),
             tags$p('Grand Tab escapement estimates and the CVPIA fall run doubling goal for each watershed are presented
                  in order to provide context for modeling output. Future iterations of the salmon population model will
                  develop estimates for additional species. '),
             tags$br(),
             tags$p('The amount of in-channel habitat is calculated using a median flow value for each watershed. 
                  Floodplain habitat is assumed to be activated when flows exceed a threshold value. The threshold 
                  value is a flow that occurs on a 2-year frequency and is sustained for 14 continuous days. Median
                  flows and floodplain thresholds in cubic feet per second are presented in the following table.'),
             tags$br(),
             tableOutput(ns('flow_notez')),
             tags$br(),
             tags$a(href = 'http://www.water.ca.gov/conservationstrategy/docs/app_h.pdf', 'CVFPP Appendix H', target = '_blank')
      )))
}

notes <- function(input, output, session) {
  
  output$flow_notez <- renderTable({
    flow_notes
  })
}