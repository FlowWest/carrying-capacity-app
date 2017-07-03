library(shiny)
library(shinythemes)
library(plotly)
library(tidyverse)
library(readr)

source('modules/natal_shed_cc.R')
source('modules/notes.R')
source('helpers.R', local = TRUE)
source('calc_num_fish.R', local = TRUE)

territory <- territory_needs()

habitat_adults <- read_rds('data/reach_habitat.rds') %>% filter(!is.na(adults), adults > 0)
grandtab <- read_rds('data/grandtab.rds')
doubling <- read_rds('data/doubling_goal.rds')
spawners <- read_rds('data/natural_adult_spawners.rds')
flow_notes <- read_rds('data/flow_notes.rds') %>% 
  dplyr::mutate(`Median In-channel Flow` = as.integer(`Median In-channel Flow`),
                `Floodplain Threshold` = as.integer(`Floodplain Threshold`))
