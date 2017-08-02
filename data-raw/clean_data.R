library(tidyverse)
library(readxl)

cc.aloc <- c(rep(1, 15), 0, 0, 2, 2, 2, 0, 0, 3, 0, rep(0, 7)) / 24
oth.aloc <- c(rep(1, 15), 0, 0, 1, 1, 1, 0, 0, 1, 0, rep(1, 6), 0) / 25

inps <- read_csv('data-raw/all_inputs.csv')
misc <- inps %>% 
  select(order = Order, watershed = Watershed, adults = init.adult, p.tempMC2025, 
         P.scour.nst, A.HARV, hatch.alloc, SCDELT, YOLO, TISD) %>%
  mutate(cc_aloc = cc.aloc, oth_aloc = oth.aloc)

habitat <- read_csv('data-raw/wethab.csv') %>% 
  select(order = Order, watershed = Watershed, spawning = Spawning, fry = Fry, parr = Parr)

egg2frytemp <- read_csv('data-raw/egg2frytemp.csv') %>% 
  select(watershed = Watershed.full, temp_eff = Wet)

degday <- read_csv('data-raw/degdaywet.csv') %>% 
  select(watershed = Watershed, degday = yr1)

fp <- read_csv('data-raw/fp_hab.csv') %>% 
  arrange(order)

retQ <- read_csv('data-raw/Wet return flow.csv') %>% 
  select(watershed = Watershed.full, retQ = y1)

reach_habitat <- left_join(habitat, misc) %>% 
  left_join(egg2frytemp) %>% 
  left_join(degday) %>% 
  left_join(fp) %>% 
  left_join(retQ)

write_rds(reach_habitat, 'data/reach_habitat.rds')

#from fp excel Mark metadata 
db <- read_csv('data-raw/doubling_goals.csv')

write_rds(db, 'data/doubling_goal.rds')
