library(shiny)
library(shinythemes)
library(plotly)
library(tidyverse)
library(readr)

habitat_adults <- readRDS('data/reach_habitat.rds') %>% filter(!is.na(adults), adults > 0)
grandtab <- readRDS('data/grandtab.rds')
doubling <- readRDS('data/doubling_goal.rds')