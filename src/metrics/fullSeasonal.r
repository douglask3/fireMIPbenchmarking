FullSeasonal <- function(obs, mod, name,
                         plotArgs, yearLength = 12, nRRs = 2, ...) {
    weights = raster::area(obs[[1]])
    score = MPD(obs, mod, w = weights)
	
    null  = null.MPD(obs, w = weights, n = nRRs)


    if (!is.null(plotArgs) & plotArgs & plotModMetrics)
        c(figNames, metricMap) := plotSeasonal(obs, mod, name, score, ...)
	else
		figNames = metricMap = NULL
    return(list(score, null, figNames))
}
