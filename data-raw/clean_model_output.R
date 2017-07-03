# SIT model output i wrote to rds after running wet scenario, added output for
# fill functions and after growth and survival
a <- read_rds('data/wet_results.rds')

before <- a$beforeG #before growth
after <- a$afterG

# make index for all combinations of months and locations
i <- rep(1:8, 9)
j <- rep(1:9, each = 8)

m <- rep(1:8, 2)
k <- rep(10:11, each = 8)

# grab migration values for all location months
t1 <- map2(i, j, function(x, y) {before[[x]][[y]]$migr})

t11 <- map2(m, k,  function(x, y) {before[[x]][[y]]$out2ocean})

# make index to group all months for each location
start <- seq(1, 72, by = 8)
end <- lead(seq(1, 72, by = 8)) - 1
end[9] <- 72

t2 <- map2(start, end, function(x, y) {
  temp <- t1[x:y]
  }) %>% 
  map(data.frame, stringsAsFactors = FALSE)


# assign each group to location
# upsac <- t2[[1]] %>% 
#   tidyr::gather(size, count) %>% 
#   dplyr::mutate(order = rep(1:15, 32),
#                 month = rep(1:8, each = 60),
#                 size = forcats::fct_inorder(rep(rep(c('s', 'm', 'l', 'vl'), each = 15), 8)))
# 
# lomid <- t2[[3]] %>% 
#   tidyr::gather(size, count) %>% 
#   dplyr::mutate(order = rep(18:20, 32),
#                 month = rep(1:8, each = 12),
#                 size = forcats::fct_inorder(rep(rep(c('s', 'm', 'l', 'vl'), each = 3), 8)))
# 
# sj <- t2[[8]] %>% 
#   tidyr::gather(size, count) %>% 
#   dplyr::mutate(order = rep(28:30, 32),
#                 month = rep(1:8, each = 12),
#                 size = forcats::fct_inorder(rep(rep(c('s', 'm', 'l', 'vl'), each = 3), 8)))
# 
# dl <- t2[[7]] %>% 
#   tidyr::gather(size, count) %>% 
#   dplyr::mutate(order = rep(25:27, 32),
#                 month = rep(1:8, each = 12),
#                 size = forcats::fct_inorder(rep(rep(c('s', 'm', 'l', 'vl'), each = 3), 8)))

upsac_fish <- t2[[2]] %>% 
  tidyr::gather(size, count) %>% 
  dplyr::mutate(order = rep(1:15, 32),
                month = rep(1:8, each = 60),
                size = forcats::fct_inorder(rep(rep(c('s', 'm', 'l', 'vl'), each = 15), 8)),
                location = 'Upper-mid Sacramento River')

lowmid_fish <- t2[[4]] %>% 
  tidyr::gather(size, count) %>% 
  dplyr::mutate(order = rep(1:20, 32),
                month = rep(1:8, each = 80),
                size = forcats::fct_inorder(rep(rep(c('s', 'm', 'l', 'vl'), each = 20), 8)),
                location = 'Lower-mid Sacramento River')

lowsac_fish <- t2[[6]] %>% 
  tidyr::gather(size, count) %>% 
  dplyr::mutate(order = rep(1:23, 32),
                month = rep(1:8, each = 92),
                size = forcats::fct_inorder(rep(rep(c('s', 'm', 'l', 'vl'), each = 23), 8)),
                location = 'Lower Sacramento River')

sj_fish <- t2[[9]] %>% 
  tidyr::gather(size, count) %>% 
  dplyr::mutate(order = rep(28:30, 32),
                month = rep(1:8, each = 12),
                size = forcats::fct_inorder(rep(rep(c('s', 'm', 'l', 'vl'), each = 3), 8)),
                location = 'San Joaquin River')


north_dl <- data.frame(t11[1:8], stringsAsFactors = FALSE) %>% 
  tidyr::gather(size, count) %>% 
  dplyr::mutate(order = rep(1:31, 32),
                month = rep(1:8, each = 124),
                size = forcats::fct_inorder(rep(rep(c('s', 'm', 'l', 'vl'), each = 31), 8)),
                location = 'North Delta')

south_dl <- data.frame(t11[9:16], stringsAsFactors = FALSE) %>% 
  tidyr::gather(size, count) %>% 
  dplyr::mutate(order = rep(1:31, 32),
                month = rep(1:8, each = 124),
                size = forcats::fct_inorder(rep(rep(c('s', 'm', 'l', 'vl'), each = 31), 8)),
                location = 'South Delta')

migrants <- dplyr::bind_rows(upsac_fish, lowmid_fish, lowsac_fish, sj_fish, north_dl, south_dl)

dplyr::select(inps, order = Order, watershed = Watershed) %>% 
  dplyr::left_join(migrants) %>% 
  readr::write_rds('data/migrants.rds')

upsac_fish %>% 
  ggplot(aes(x = forcats::fct_inorder(month.abb[month]), y = count, fill = size)) +
  geom_col() +
  theme_minimal()

lowmid_fish %>% 
  ggplot(aes(x = forcats::fct_inorder(month.abb[month]), y = count, fill = size)) +
  geom_col() +
  theme_minimal()

lowsac_fish %>% 
  ggplot(aes(x = forcats::fct_inorder(month.abb[month]), y = count, fill = size)) +
  geom_col() +
  theme_minimal()

north_dl %>% 
  ggplot(aes(x = forcats::fct_inorder(month.abb[month]), y = count, fill = size)) +
  geom_col() +
  theme_minimal()

south_dl %>% 
  ggplot(aes(x = forcats::fct_inorder(month.abb[month]), y = count, fill = size)) +
  geom_col() +
  theme_minimal()
