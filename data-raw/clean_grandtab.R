library(tidyverse)
library(stringr)

reaches <- read_rds('data/reach_habitat.rds') %>% 
  filter(!is.na(adults), adults > 0, watershed != "San Joaquin River") %>% 
  pull(watershed)

#new data from jessica goes back further
grandtab <- read_csv('data-raw/grandtab.csv', skip = 3)

gt <- grandtab %>% 
  mutate(watershed = ifelse(RIVER == 'Sacramento River Main Stem', 'Upper Sacramento River', RIVER)) %>% 
  filter(watershed %in% reaches, DATA_COLLECTION_TYPE %in% c('In-River Count', 'Hatchery')) %>% 
  mutate(DATA_COLLECTION_TYPE = replace(DATA_COLLECTION_TYPE, DATA_COLLECTION_TYPE == 'In-River Count', 'Natural')) %>% 
  select(year = YEAR, watershed, count = ESTIMATE, run = RUN, type = DATA_COLLECTION_TYPE)

write_rds(gt, 'data/grandtab2.rds')

#from fp excel Mark metadata 
db <- read_csv('data-raw/doubling_goals.csv')

write_rds(db, 'data/doubling_goal.rds')
# 
# # clean doubling goals, need to deal with sac
# 
# db <- 'Cosumnes River Fall 3,300 Mokelumne River Fall 9,300 Calaveras River Fall 2,200 Tuolumne River Fall 38,000 Stanislaus River Fall 22,000 Merced River Fall 18,000 Feather River Fall 170,000 Yuba River Fall 66,000 Bear River Fall 450 American River Fall 160,000'
# 
# 
# reach_names <- paste(unlist(str_replace_all(db, ',', '') %>% 
#   str_extract_all('[A-z]+'))[seq(1,30, by = 3)], 'River')
# 
# db_count <- as.numeric(unlist(str_replace_all(db, ',', '') %>% 
#   str_extract_all('[0-9]+')))
# 
# doubling <- data_frame(watershed = reach_names, run = 'Fall', goal = db_count)
# 
# misc <- data_frame(watershed = c('Mill Creek', 'Mill Creek', 'Deer Creek', 'Deer Creek',
#                                  'Butte Creek', 'Butte Creek', 'Big Chico Creek'),
#                    run = rep(c('Fall', 'Spring'), length = 7), 
#                    goal = c(4200, 4400, 1500, 6500, 1500, 2000, 800))
# 
# doublin <- doubling %>% 
#   bind_rows(misc) %>% 
#   bind_rows(data_frame(watershed = rep('Upper Sacramento River', 4), 
#                        run = c('Fall', 'Late-Fall', 'Winter', 'Spring'), 
#                        goal = c(258700, 44550, 110000, 59000)))
# 
# missing_sheds <- reaches[which(!(reaches %in% doublin$watershed))]
# missings <- data_frame(watershed = missing_sheds, run = NA, goal = NA)
# 
# 
# write_rds(bind_rows(doublin, missings), 'data/doubling_goal.rds')
# 
# # clean doubling goals from mark email
# 
# # Doubling Goal Numbers from here: http://www.water.ca.gov/conservationstrategy/docs/app_h.pdf page H-5-7
# # 
# # Cosumnes River Fall 3,300
# # Mokelumne River Fall 9,300
# # Calaveras River Fall 2,200
# # Tuolumne River Fall 38,000
# # Stanislaus River Fall 22,000
# # Merced River Fall 18,000
# # Feather River Fall 170,000
# # Yuba River Fall 66,000
# # Bear River Fall 450
# # American River Fall 160,000
# # 
# # Sacramento River and Tributaries above Red Bluff Diversion Dam
# # Fall 258,700
# # Late-fall 44,550
# # Winter 110,000
# # Spring 59,000
# #
# # Antelope Creek Fall 720
# # 
# # Mill Creek
# # Fall 4,200
# # Spring 4,400
# # 
# # Deer Creek
# # Fall 1,500
# # Spring 6,500
# # 
# # Butte Creek
# # Fall 1,500
# # Spring 2,000
# # 
# # Big Chico Creek Fall 800