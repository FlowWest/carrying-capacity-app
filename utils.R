# Size for Territory
# Used the mid-point for each size class for the territory size calculations
# Territory Size as function of Length (cm) (Grant and Kramer 1990)
# Estimates the area (m^2) that a fish of a given length would need to occupy 
# to grow and survive. Adapted from Grant and Kramer 1990.
# @param L Length (cm) of a juvenile salmon.

territory_needs <- function() {
  territory <- function(L) {
    return(10 ^ (2.61 * log(L, base = 10) - 2.83))
  }
  
  territory_size <- rep(0,3)
  territory_size[1] <- territory(mean(c(3.75,4.2))) #spawning
  territory_size[2] <- territory(mean(c(4.2,7.4))) #fry
  territory_size[3] <- territory(mean(c(7.4,11))) #parr
  
  return(territory_size)
}

