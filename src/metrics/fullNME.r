FullNME <- function(obs, mod, name, plotArgs = NULL, mnth2yr = FALSE,
                    byZ = FALSE, nZ = 0, ...) {
    if (!byZ) return(FullNME.spatial(obs, mod, name, mnth2yr, plotArgs, ...))
        else  return(FullNME.InterAnnual(obs, mod, name, plotArgs, nZ, ...))
}

FullNME.spatial <- function(obs, mod, name, mnth2yr, plotArgs, nRRs = 2, ...) {
	
    obs     = mean.nlayers(obs)
    mod     = mean.nlayers(mod)
    weights = raster::area(obs)

    if (mnth2yr) {obs = obs * 12; mod = mod * 12}
    score   = NME (obs, mod, weights)

    if (!is.null(plotArgs) && plotModMetrics)
        c(figNames, metricMap) := do.call(plotNME.spatial, c(obs, mod, name, plotArgs, ...))
    else figNames = metricMap =  NULL

    null    = null.NME(obs, w = weights, n = nRRs)
	
    return(list(score, null, figNames, metricMap))
}

FullNME.site <- function(obs, mod, name, plotArgs = NULL, mnth2yr = FALSE,
                    byZ = FALSE, nZ = 0, ...) {

    x     = obs$lon
    y     = obs$lat
    obs   = obs[,3]

    rmod  = mod
    mod   = mean(mod)	
    mod   = mod[cellFromXY(mod, cbind(x,y))]
	
    score = NME (obs, mod)

    if (!is.null(plotArgs) && plotModMetrics)
        c(figName, metricMap) := do.call(plotNME.site, c(list(x), list(y), list(obs), rmod,
                                         list(score), name, plotArgs, ...))
	else figName = metricMap =  NULL
	
    null    = null.NME(obs, n = nRRs)
    return(list(score, null, figName, metricMap))
}

FullNME.InterAnnual <- function(...) {
	out2 = FullNME.InterAnnual.Trend(...)
	out1 = FullNME.InterAnnual.globalAverage(...)
}

findRasterTrend <- function(r) {
	
	regFun <- function(x) {
		fit = betareg(x ~ t, data = data.frame(x = x, t = 1:length(x)))
		res = try(summary(fit)[[1]][[1]][2,][3:4])
		if (class(res) == "try-error") return(c(-999, 0.0))
		return(res)
	}
		
	findCellTrend <- function(x) {
		if (any(is.na(x))) return(NaN)
		if (min(x) == max(x)) return(0)
		
		test = try(regFun(x), silent = TRUE)
		if (class(test) == "try-error") return(NaN)
		#if (test[2] > 0.1) return(NaN)
		return(test[1])
	}
	tempFile = paste(temp_dir, filename.noPath(r[[1]], TRUE), 'trend.nc', sep = '')
	if (file.exists(tempFile)) return(raster(tempFile)) else {
		yrs = floor(nlayers(r) / 12)
		r = layer.apply(1:yrs, function(y) sum(r[[((y-1)*12 + 1):(y*12)]]))
		
		r = aggregate(r, 8)
		r[r > 1] = 1
		r[r < 0] = 0
		nl = nlayers(r)
		r = (r * (nl - 1)  + 0.5) / nl

		v = apply(values(r), 1, findCellTrend)
		r = r[[1]]
		r[] = v
		r = writeRaster(r, filename = tempFile)
	}
	return(r)

}

FullNME.InterAnnual.Trend <- function(obs, mod, name, plotArgs = NULL, nZ = 1,
                                nRRs = 2, ...) {
	
	
	obsT = findRasterTrend(obs)
	modT = findRasterTrend(mod)
	browser()
	
}


FullNME.InterAnnual.globalAverage <- function(obs, mod, name, plotArgs = NULL, nZ = 1,
                                nRRs = 2, ...) {
	
    ## Convert brick layers to ts
    calAnnual <- function(i) sum.raster(i * raster::area(i), na.rm = TRUE)
    calIAV <- function(x) unlist(layer.apply(x, calAnnual))

    c(obs, mod) := lapply(list(obs, mod), calIAV)

    ## Convert ts to annual ts
    convert2annual  <- function(i, d) sum(d[(nZ*(i-1)+1):(nZ*i)])
    convert2Iannual <- function(d)
        sapply(1:floor(length(d)/nZ),convert2annual,d)

    if (nZ > 1) c(obs, mod) :=  lapply(list(obs, mod), convert2Iannual)

    score = NME (obs, mod)
    null  = null.NME(obs, n = nRRs)

    if (!is.null(plotArgs) && plotModMetrics)
        c(figName, metricMap) := do.call(plotNME.InterAnnual, list(obs, mod, name, plotArgs, ...))
	else figName = metricMap =  NULL
	
    return(list(score, null, figName, metricMap))
}


