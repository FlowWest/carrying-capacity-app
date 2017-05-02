
inps <- read_csv('data/all_inputs.csv')
misc <- inps %>% 
  select(order = Order, watershed = Watershed, adults = init.adult, SCDELT, p.tempMC2025, P.scour.nst, A.HARV, hatch.alloc, YOLO, TISD)

habitat <- read_csv('data/wethab.csv') %>% 
  select(order = Order, watershed = Watershed, spawning = Spawning, fry = Fry, parr = Parr)

retQ <- read_csv('data/wetretq.csv') %>% 
  select(watershed = Watershed.full, retQ = y1)

egg2frytemp <- read_csv('data/egg2frytemp.csv') %>% 
  select(watershed = Watershed.full, temp_eff = Wet)

degday <- read_csv('data/degdaywet.csv') %>% 
  select(watershed = Watershed, degday = yr1)

reach_habitat <- left_join(habitat, misc) %>% 
  left_join(egg2frytemp) %>% 
  left_join(degday) %>% 
  left_join(retQ)

write_rds(reach_habitat, 'data/reach_habitat.rds')
gates <- read_csv('data/gates.csv')[, 1:3]