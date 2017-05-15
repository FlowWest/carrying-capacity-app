library(tidyverse)
library(readxl)

inps <- read_csv('data-raw/all_inputs.csv')
misc <- inps %>% 
  select(order = Order, watershed = Watershed, adults = init.adult, p.tempMC2025, P.scour.nst, A.HARV, hatch.alloc, YOLO, TISD)

habitat <- read_csv('data-raw/wethab.csv') %>% 
  select(order = Order, watershed = Watershed, spawning = Spawning, fry = Fry, parr = Parr)

egg2frytemp <- read_csv('data-raw/egg2frytemp.csv') %>% 
  select(watershed = Watershed.full, temp_eff = Wet)

degday <- read_csv('data-raw/degdaywet.csv') %>% 
  select(watershed = Watershed, degday = yr1)

fp <- read_csv('data-raw/fp_hab.csv') %>% 
  arrange(order)

reach_habitat <- left_join(habitat, misc) %>% 
  left_join(egg2frytemp) %>% 
  left_join(degday) %>% 
  left_join(fp) 

write_rds(reach_habitat, 'data/reach_habitat.rds')

#from fp excel Mark metadata 
db <- read_csv('data-raw/doubling_goals.csv')

write_rds(db, 'data/doubling_goal.rds')
