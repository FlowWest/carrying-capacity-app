calc_num_fish <- function(adults, retQ, SCDELT, hatch.alloc, TISD, YOLO, 
                     p.tempMC2025, A.HARV, P.scour.nst, egg.tmp.eff, degday, spawn, order) {
  cc.aloc <- (c(rep(1, 15), 0, 0, 2, 2, 2, 0, 0, 3, 0, rep(0, 7)) / 24)[[order]]
  oth.aloc <- (c(rep(1, 15), 0, 0, 1, 1, 1, 0, 0, 1, 0, rep(1, 6), 0) / 25)[[order]]
  
  gates.clsd <- 26
  
  # number of wild fish expected to stray
  stray <- Ad.Stray(wild = 1,
                    pctQnatl = retQ,
                    SCDLT = SCDELT,
                    CrxChn = gates.clsd) * adults
  
  prop.nat.stray <- Ad.Stray(wild = 1,
                             pctQnatl = retQ,
                             SCDLT = SCDELT,
                             CrxChn = gates.clsd)
  ##
  nat.adult <- adults - stray +
    sum(stray * SCDELT) * cc.aloc +
    sum(stray * (1 - SCDELT)) * oth.aloc
  
  ## allocate hatchery fish returning from ocean to watersheds
  ## for stochas inps$hatch.alloc should come from Direclet dist.
  hatch.adult <- hatch.alloc * qunif(0.5, 80000, 150000)
  
  ###Let's try it out now
  ### calculate transition month
  
  tils.ove <- 1
  yolo.ovr <- 0
  
  T.mo <- 2
  ## are tisdale or yolo bypasses overtopped?
  BPovrT <- tils.ove * TISD + yolo.ovr * YOLO
  BPovrT <- ifelse(BPovrT > 0, 1, 0)
  
  ###### Adult en route survival using function
  adult_en_route <- Adult.S(aveT23 = p.tempMC2025, BPovrT, harvest = A.HARV)
  
  ### here's the adults that made it to spawning grounds
  nat.adult <- adult_en_route * nat.adult
  hatch.adult <- adult_en_route * hatch.adult
  
  #### all adult on spawning grounds
  init.adult <- nat.adult + hatch.adult
  
  # proportion natural adults
  prop.nat <- nat.adult / (adults + 0.0001)
  eg2fr <- egg2fry(prop.nat = prop.nat, scour = P.scour.nst, tmp.eff = egg.tmp.eff)
  
  spawn_hab <-  spawn
  
  ### prespawn survival
  pre.spawn.S <- Adult.PSS(DegDay = degday)
  
  num_fry <- spawnfun(escapement = init.adult,
           s_adult_inriver = pre.spawn.S,
           sex_ratio = 0.5,
           spawn_hab = spawn * 4046.86,
           redd_size = 12.4,
           prob_scour = P.scour.nst,
           s_egg_to_fry = eg2fr,
           fecund = 5522)
  
  return(list(spawners = init.adult * pre.spawn.S, fry = num_fry))
}
