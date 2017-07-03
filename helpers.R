pretty_num <- function(num, places = 0) {
  format(round(num, places), big.mark = ',', trim = FALSE)
}

#' Inverse logit link, transforms variables on logit scale to real scale.
#' The inverse logit function (called either the inverse logit or the logistic
#' function) transforms a real number (usually the logarithm of the odds) to a
#' value (usually probability p) in the interval [0,1]. The invlogit function is
#' 1/ (1 + exp(-x)).
#' @name inv.logit
#' @param eta logit value to be back transformed to real scale

### inverse logit link function
inv.logit <- function(eta) {
  return(1 / (1 + exp(-eta)))
}

#' Adult straying function used to determine proportion of adults that wills stray into each watershed/bypass
#' @name Ad.Stray
#' @param wild Boolean value: 1 if  wild fish returning, otherwise 0
#' @param propDLTtrans proportion hatchery fish trucked transported to delta
#' @param propBAYtans proportion hatchery fish trucked transported to bay
#' @param pctQnatl proportion flows at tributary junction coming from natal watershed
#' @param SCDLT Boolean value: 1 if fish returning to S Central delta otherwise 0 
#' @param CrxChn number days cross channel closed
#' @example Ad.Stray(wild = c(1, 1, 1, 0, 0), pctQnatl = c(1, 0.5, 0.25, 0.5, 0.5),
#' SCDLT = c(0, 0, 1, 0, 0), CrxChn = rep(0, 5), propDLTtrans = rep(1, 5), propBAYtans = rep(1, 5))

Ad.Stray <- function(wild, propDLTtrans = 0, propBAYtans = 0, pctQnatl, SCDLT, CrxChn) {
  BT <- 3
  inv.logit(BT +
              -5.5 * wild +
              -1.99 * pctQnatl + 
              -0.174 * SCDLT * CrxChn +
              2.09 * propBAYtans * (1 - wild) +
              2.89 * propDLTtrans * (1 - wild)
  )
}

#' Calculates egg to fry survival
#' @name egg2fry
#' @param prop.nat vector of proportion natural-origin spawners.  
#' Each element represents each watershed/bypass.
#' @param scour vector of probability of redd scouring event.  
#' Each element represents each watershed/bypass.
#' @param tmp.eff the effect of in-stream temperature on egg survival.  
#' Higher number indicate smaller in-stream temperature effects and 
#' lower numbers represent larger in-stream temperature effects.

egg2fry <- function(prop.nat, scour, tmp.eff) {
  inv.logit(0.041 + prop.nat * 0.533 - 0.655 * scour) * tmp.eff
}

#' Adult en route survival function
#' @param aveT23 Boolean value: 1 if ave daily temps > 22degC otherwise 0
#' @param BPovrT Boolean value:1 when Tisdale Bypass and or Yolo Bypass 
#' are overtopped only pertains to Tributaries above bypasses
#' @param harvest harvest rate for each watershed
#' @example Adult.S(aveT23 = c(0, 1, 0, 0), BPovrT = c(0, 0, 1, 0), harvest = c(0, 0, .45, 0))

Adult.S <- function(aveT23, BPovrT, harvest) {
  BA <- 3
  S <- inv.logit(BA -0.26 * aveT23 - 0.019 * BPovrT) - harvest  
  ifelse(S > 0, S, 0)
}

#' Calculates adult prespawn survival, returns ?
#' @name Adult.PSS
#' @param DegDay average degree days (celcius)

Adult.PSS <- function(DegDay) {
  BP <- 3
  inv.logit(BP - 0.000669526 * DegDay)  
}

#' Size for Territory
#' Used the mid-point for each size class for the territory size calculations
#' Territory Size as function of Length (cm) (Grant and Kramer 1990)
#' Estimates the area (m^2) that a fish of a given length would need to occupy 
#' to grow and survive. Adapted from Grant and Kramer 1990.
#' @param L Length (cm) of a juvenile salmon.

territory_needs <- function() {
  territory <- function(L) {
    return(10 ^ (2.61 * log(L, base = 10) - 2.83))
  }
  
  territory_size <- rep(0,3)
  territory_size[1] <- territory(mean(c(3.75,4.2))) 
  territory_size[2] <- territory(mean(c(4.2,7.4)))
  territory_size[3] <- territory(mean(c(7.4,11))) 
  territory_size[4] <- 0
  
  return(territory_size)
}

#' This function estimates how many fry are produced in each watershed/bypass 
#' given how much spawning habitat is present, estimates of egg to fry survival, 
#' fecundity, and redd scour probability. Output is 31x4 matrix.Rows represent 
#' each watershed/bypass and columns represent each size class of juveniles from 
#' smallest to largest. Because this function only estimates how many fry are 
#' produces only the first column should have non-zero numbers.
#' @param escapement Number of adults in each watershed/bypass that make it to the spawning grounds
#' @param s_adult_inriver Adult survival in freshwater during migration.
#' @param sex_ratio Sex ration, defaults to 0.5.
#' @param spawn_hab Amount of spawning habitat in each watershed/bypass.
#' @param redd_size Size (m^2) of the mean redd.
#' @param prob_scour Probability of redds being scoured in each watershed/bypass
#' @param s_egg_to_fry Egg to fry survival in each watershed/bypass.
#' @param fecund Mean fecundity of females.  Defaults to 5522.

spawnfun <- function(escapement, s_adult_inriver, sex_ratio, spawn_hab, redd_size, prob_scour, fecund, s_egg_to_fry) {
  
  spawners <- ((escapement * s_adult_inriver * sex_ratio) > (spawn_hab) / redd_size) * (spawn_hab) / redd_size +
    ((escapement * s_adult_inriver * sex_ratio) <= (spawn_hab)/redd_size) * (escapement * s_adult_inriver * sex_ratio)
  
  newfry <- spawners * (1-prob_scour) * fecund * s_egg_to_fry
  
  return(newfry)
}
