#from carrying capacity app
habitat_adults <- read_rds('raw-data/reach_habitat.rds')


delta_hab <- data_frame(watershed = c("North Delta", 'South Delta'),
                        habitat_acres = c(532615, 1092652) * 0.000247105) # from SIT Model meters2


# 4046.86 acres to sq meters
# 0.000247105 metersq to acres

#use fry habitat
hab <- habitat_adults %>% 
  dplyr::select(watershed, habitat_acres = fry) %>% 
  dplyr::bind_rows(delta_hab) %>% 
  dplyr::filter(watershed %in% c('Upper-mid Sacramento River', 'Lower-mid Sacramento River',
                                 'Lower Sacramento River', 'San Joaquin River', 'North Delta', 'South Delta'))

readr::write_rds(hab, 'data/habitat.rds')
