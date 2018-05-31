FullNME <- function(obs, mod, name, plotArgs = NULL, mnth2yr = FALSE,
                    byZ = FALSE, nZ = 0, zTrend = FALSE, ...) {
    if (byZ) out = FullNME.InterAnnual(obs, mod, name, plotArgs, nZ, ...)
		else if (zTrend)  out = FullNME.Trend(obs, mod, name, plotArgs, ...)
		else out = FullNME.spatial(obs, mod, name, mnth2yr, plotArgs, ...)
	
	return(out)
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


findRasterTrend <- function(r, obs = TRUE) {
	
	TrendFun <- function(x) {
		fit = lm(x ~ t, data = data.frame(x = x, t = 1:length(x)))
		res = try(summary(fit)[[4]][2, 3:4])
		if (class(res) == "try-error") return(c(-999, 0.0))
		return(res)
	}
		
	findCellTrend <- function(x) {
		if (any(is.na(x))) return(NaN)
		if (min(x) == 0 && max(x) == 0) return(NaN)
		if (min(x) == max(x)) return(0)
		test = TrendFun(x)
		test = try(TrendFun(x), silent = TRUE)
		if (class(test) == "try-error") return(NaN)
		if (obs && test[2] > 0.1) return(NaN)
		return(test[1])
	}
	tempFile = paste(temp_dir, filename.noPath(r[[1]], TRUE), 'trend.nc', sep = '')
	if (file.exists(tempFile)) return(raster(tempFile)) else {
		yrs = floor(nlayers(r) / 12)
		
		r = raster.ma(r) * 12
		
		r[r > 1] = 1
		r[r < 0] = 0
		
		
		nl = nlayers(r)
		r = (r * (nl - 1)  + 0.5) / nl
		
		r = log(r/(1 - r))
		
		v = apply(values(r), 1, findCellTrend)
		r = r[[1]]
		r[] = v
		
		r = writeRaster(r, filename = tempFile)
	}
	return(r)

}

FullNME.Trend <- function(obs, mod, name, ...) {
	obs = findRasterTrend(obs)
	mod = findRasterTrend(mod, obs = FALSE)

	obs[obs == 0] = NaN
	mod[is.na(obs)] = NaN
	
	sigmoid <- function(r) (2/(1+exp(r*(-1))))-1
	
	obs0 = obs
	mod0 = mod
	
	obs = sigmoid(obs)
	mod = sigmoid(mod)
	#mx =  max.raster(obs, na.rm = TRUE)
	#mn =  min.raster(obs, na.rm = TRUE)
	
	#mod[mod > mx] = mx
	#mod[mod < mn] = mn
	
	out = FullNME.spatial(obs, mod, name, mnth2yr = FALSE,  ...)
    return(c(out, obs0, mod0))
}


FullNME.InterAnnual <- function(obs, mod, name, plotArgs = NULL, nZ = 1,
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


