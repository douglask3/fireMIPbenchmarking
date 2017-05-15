FullSeasonal <- function(obs, mod, name,
                         plotArgs, yearLength = 12, nRRs = 2, ...) {
    weights = raster::area(obs[[1]])
	
	obs   = climateologize(obs, yearLength)
	mod   = climateologize(mod, yearLength)
    score = MPD(obs, mod, w = weights, ncycle = yearLength)
    null  = null.MPD(obs, w = weights, ncycle = yearLength, n = nRRs)

    if (!is.null(plotArgs) & plotArgs & plotModMetrics)
        c(figNames, metricMap) := plotSeasonal(obs, mod, name, score, ...)
	else
		figNames = metricMap = NULL
    return(list(score, null, figNames))
}

climateologize <- function(r, yearLength = 12) {
	out = r[[1:yearLength]]

	nlayers = nlayers(r)
	scaling = floor(nlayers / yearLength)
	nlayers = scaling * yearLength
	
	
	for (i in 1:nlayers) {
		j = baseN(i, yearLength)
		out[[j]] = out[[j]] + r[[i]] / scaling
	}
	
	return(out)
	
}

baseN <- function(i, N = 12) {
	i = i - N *floor(i / N)
	i[i == 0] = N
	return(i)
}
