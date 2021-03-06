plotSeasonal <- function(obs, mod, ...) {
    obs = PolarConcentrationAndPhase.memStore(obs)
    mod = PolarConcentrationAndPhase.memStore(mod)
	
    c(f1, mm1) := plotSeasonal.phse(mod[[1]], obs[[1]], ...)
    c(f2, mm2) := plotSeasonal.conc(mod[[2]], obs[[2]], ...)
	
    return(list(c(f1, f2), c(mm1, mm2)))
}


plotSeasonal.conc <- function(mod, obs, name, ...) {

    cols    = SeasonConcCols
    dcols   = SeasonConcDcols
    limits  = SeasonLimits
    dlimits = SeasonDlimits

    plotNME.spatial(obs, mod, name, cols, dcols,
			        limits = limits, dlimits = dlimits, ...)
}

mapSeasonal.phse <- function(mod, obs) {

	dif.phase = dif.abs = mod - obs

    dif.abs[dif.abs < (-6)] = dif.abs[dif.abs <(-6)] + 6
    dif.abs[dif.abs >   6 ] = dif.abs[dif.abs >  6 ] - 6
	
	dif.phase = acos(cos(dif.phase))
	
	return(list(dif.abs, dif.phase))
}

plotSeasonal.phse <- function(mod, obs, step, name,
							  cols = SeasonPhaseCols, dcols = SeasonPhaseDcols, metricCols = MPDmap_cols, 
						      limits = SeasonPhaseLimits, dlimits = SeasonPhaseDlimits, 
							  metricLimits = NULL,
						      figOut = TRUE, plotObs = TRUE, ...) {

    if (figOut) {
		figName = setupPlotStandardMap(name, 2, 3, width = c(0.1, 1, 1))	
		SeasonLegend(limits[[1]], cols[[1]], dat = obs)
		labs = c('obs', 'mod', 'mod - obs', 'MPD relative contributions')
		add_legend = TRUE
	} else {
		labs = rep('', 4)
		figName= NULL
		add_legend = FALSE
	}
	
	if (plotObs) plotStandardMap(obs, labs[1], limits, cols, add_legend = FALSE)
	
	plotStandardMap(mod, labs[2], limits, cols, add_legend = FALSE)
	if (!figOut) mtext(name, side = 2, line = -1)
	
	c(dif.abs, dif.phase) := mapSeasonal.phse(mod, obs)
    
    if (add_legend) SeasonLegend(limits[[2]], cols[[2]], dat = dif.abs)

    plotStandardMap(dif.abs,  labs[3], dlimits, dcols, add_legend = FALSE)

    plotStandardMetricMap(dif.phase, labs[4], metricLimits, cols = metricCols, add_legend = add_legend)

    if (figOut) dev.off.annotate(name)
	
	return(c(figName, dif.phase))
}
