FullNMDE <- function(obs, mod, name, plotArgs = NULL, mnth2yr = FALSE,  scale_fact = 1,...) {
    
	obs     = mean.nlayers(obs)
	mod     = mean.nlayers(mod)
	weights = raster::area(obs)
	
	if (mnth2yr) {obs = obs * 12; mod = mod * 12}
	
	
	score = NMDE(obs, mod, weights, scale_fact = scale_fact)
	null  = null.NMDE(obs, w = weights, n = nRRs)
	
	if (!is.null(plotArgs) && plotModMetrics)
        c(figNames, metricMap) := do.call(plotNME.spatial.gradient, c(obs, mod, name, plotArgs, ...))
    else figNames = metricMap =  NULL
	
	return(list(score, null, figNames, metricMap))
}