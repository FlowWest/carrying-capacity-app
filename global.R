library(shiny)
library(shinythemes)
library(plotly)
library(tidyverse)
library(readr)

habitat_adults <- readRDS('data/reach_habitat.rds') %>% filter(!is.na(adults), adults > 0)
grandtab <- read_rds('data/grandtab.rds')
doubling <- read_rds('data/doubling_goal.rds')
spawners <- read_rds('data/natural_adult_spawners.rds')

#test
