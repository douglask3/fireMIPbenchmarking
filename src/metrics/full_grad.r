FullGrad <- function(obs, mod, name, plotArgs = NULL, mnth2yr = FALSE,...) {
    
	obs     = mean.nlayers(obs)
	mod     = mean.nlayers(mod)
	weights = raster::area(obs)
	
	if (mnth2yr) {obs = obs * 12; mod = mod * 12}
	
	score = NMGE(obs, mod, weights)
	null  = null.NMGE(obs, w = weights, n = nRRs)
	
	if (!is.null(plotArgs) && plotModMetrics)
        c(figNames, metricMap) := do.call(plotNME.spatial.gradient, c(obs, mod, name, plotArgs, ...))
    else figNames = metricMap =  NULL
	
	return(list(score, null, figNames, metricMap))
}