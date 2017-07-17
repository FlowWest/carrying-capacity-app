library(shiny)
library(tidyverse)
library(forcats)
library(magrittr)
library(visNetwork)
library(shinycssloaders)
library(shinyjs)
library(shinythemes)
library(plotly)
library(DT)
library(RColorBrewer)

source('modules/natal_shed_cc.R', local = TRUE)
source('modules/notes.R', local = TRUE)
source('modules/migrants_cc.R', local = TRUE)
source('helpers.R', local = TRUE)
source('calc_num_fish.R', local = TRUE)

territory <- territory_needs()

habitat_adults <- read_rds('data/reach_habitat.rds') %>% filter(!is.na(adults), adults > 0, watershed != 'San Joaquin River')

grandtab <- read_rds('data/grandtab2.rds') %>% 
  filter(run == 'Fall')

doubling <- read_rds('data/doubling_goal.rds') 

spawners <- read_rds('data/natural_adult_spawners.rds')

flow_notes <- read_rds('data/flow_notes.rds') %>% 
  dplyr::mutate(`Median In-channel Flow` = as.integer(`Median In-channel Flow`),
                `Floodplain Threshold` = as.integer(`Floodplain Threshold`))

fp_accum <- tibble(
  stems = c('Upper-mid Sacramento River', 'Lower-mid Sacramento River',
    'Lower Sacramento River', 'San Joaquin River', 'North Delta', 'South Delta'),
  fp_area_acres = c(912.9, 52.1 * 1/3, 52.1 * 2/3, 931, NA, NA)
)

inps <- readr::read_csv('data/All inputs.csv')

size_lookup <- c('small', 'medium', 'large', 'very large')
names(size_lookup)  <- c('s', 'm', 'l', 'vl')
migr <- readr::read_rds('data/migrants.rds') %>% 
  mutate(size = fct_inorder(size_lookup[size]))

habitat <- read_rds('data/habitat.rds')

# 4046.86 acres to sq meters
# 0.000247105 metersq to acres
