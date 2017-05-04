library(magrittr)
library(stringr)

grandtab <- readxl::read_excel('data/GrandTab 1975-2015.xlsx')

reaches <- readRDS('data/reach_habitat.rds') %>% 
  filter(!is.na(adults), adults > 0) %>% 
  extract2(2)


gt <- filter(grandtab, !is.na(Count))

t1 <- gt %>% 
  mutate(year = as.numeric(str_extract(Year, '[0-9]+'))) %>% 
  filter(River %in% reaches, `Count Type` == 'In-River')

write_rds(t1, 'data/grandtab.rds')

