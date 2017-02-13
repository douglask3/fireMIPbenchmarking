FullNME <- function(obs, mod, name, plotArgs = NULL, mnth2yr = FALSE,
                    byZ = FALSE, nZ = 0, ...) {
    if (!byZ) return(FullNME.spatial(obs, mod, name, mnth2yr, plotArgs, ...))
        else  return(FullNME.InterAnnual(obs, mod, name, plotArgs, nZ, ...))
}

FullNME.spatial <- function(obs, mod, name, mnth2yr, plotArgs, nRRs = 2, ...) {
    obs     = mean.nlayers(obs)
    mod     = mean.nlayers(mod)
    weights = area(obs)

    if (mnth2yr) {obs = obs * 12; mod = mod * 12}
    score   = NME (obs, mod, weights)

    if (!is.null(plotArgs))
        c(figNames, metricMap) := do.call(plotNME.spatial, c(obs, mod, name, plotArgs, ...))
    else {figNames = NULL; metricMap =  NULL}

    null    = null.NME(obs, w = weights, n = nRRs)
	
    return(list(score, null, figNames, metricMap))
}

FullNME.site <- function(obs, mod, name, plotArgs = NULL, mnth2yr = FALSE,
                    byZ = FALSE, nZ = 0, ...) {

    x     = obs$lon
    y     = obs$lat
    obs   = obs[,3]

    rmod  = mod
    mod   = mean (mod)
    mod   = mod[cellFromXY(mod, cbind(x,y))]

    score = NME (obs, mod)

    if (!is.null(plotArgs))
        c(figName, metricMap) := do.call(plotNME.site, c(list(x), list(y), list(obs), rmod,
                                         list(score), name, plotArgs, ...))

    null    = null.NME(obs, n = nRRs)
    return(list(score, null, figName, metricMap))
}

FullNME.InterAnnual <- function(obs, mod, name, plotArgs = NULL, nZ = 1,
                                nRRs = 2, ...) {
    ## Convert brick layers to ts
    calAnnual <- function(i) sum.raster(i * area(i), na.rm = TRUE)
    calIAV <- function(x) unlist(layer.apply(x, calAnnual))

    c(obs, mod) := lapply(list(obs, mod), calIAV)

    ## Convert ts to annual ts
    convert2annual  <- function(i, d) sum(d[(nZ*(i-1)+1):(nZ*i)])
    convert2Iannual <- function(d)
        sapply(1:floor(length(d)/nZ),convert2annual,d)

        if (nZ > 1) c(obs, mod) :=  lapply(list(obs, mod), convert2Iannual)

    score = NME (obs, mod)
    null  = null.NME(obs, n = nRRs)

    if (!is.null(plotArgs))
        c(figName, metricMap) := do.call(plotNME.InterAnnual, list(obs, mod, name, plotArgs, ...))

    return(list(score, null, figName, metricMap))
}
