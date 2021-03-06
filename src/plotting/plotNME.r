

plotNME.spatial <- function(obs, mod, ...) {
	
    c(f1, map1) := plotNME.spatial.stepN(mod, obs, 1, ...)

    mod = removeMean(mod, obs)
    c(f2, map2) := plotNME.spatial.stepN(mod, obs, 2, ...)

    mod = removeVar(mod, obs)
    c(f3, map3) := plotNME.spatial.stepN(mod, obs, 3, ...)
	
    return(list(c(f1, f2, f3), c(map1, map2, map3)))
}

plotNME.spatial.gradient <- function(obs, modm , ...) {
	browser()
}

plotNME.spatial.stepN <- function(mod, obs, step, name, cols, dcols, metricCols = NMEmap_cols, 
                                  limits, dlimits, metricLimits = NULL, 
								  figOut = TRUE, plotObs = TRUE, denomNormFun = sum.raster, diff1 = NULL, diff2 = NULL, ...) {

    stepN   = paste("step", step, sep = '')
    if (figOut) { 
		figName = setupPlotStandardMap(paste(name, stepN, sep = '-'), 2, 2)
		labs = c('obs', 'mod', 'mod - obs', paste('NME relative contributions -', stepN), 'vs null mods')
		add_legend = TRUE
	} else {
		labs = rep('', 5)
		add_legend = FALSE
	}
	
	if (is.null(diff1)) diff1 = mod - obs
	if (is.null(diff2)) NMEs = mapNME(mod, obs, denomNormFun) else NMEs = diff2
	
	if(plotObs) plotStandardMap(obs, labs[1], limits, cols, add_legend = add_legend)
    plotStandardMap( mod, labs[2], limits, cols, add_legend = add_legend)
	if (!figOut) mtext(name, side = 2, line = -1)
    plotStandardMap(diff1, labs[3], dlimits, dcols, add_legend = add_legend)
	
    plotStandardMetricMap(NMEs, labs[4], c(0.1, 0.2, 0.5, 1, 2, 5, 20), cols = cols, add_legend = add_legend)
    plotStandardMetricMap(NMEs, labs[5], metricLimits, cols = metricCols, add_legend = add_legend)

    if (figOut) dev.off.annotate(paste(name, stepN))
	else figName = NULL 
    return(c(figName, NMEs))
}

mapNME <- function(mod, obs, denomNormFun = sum.raster) {
	Area = raster::area(obs,na.rm = TRUE)
    mnObs = sum(values(obs*raster::area(obs)), na.rm = TRUE) /
            sum(values(Area), na.rm = TRUE)

	denom = abs(obs - mnObs)
	denom = denom * Area
	denom = denomNormFun(denom, na.rm = TRUE) / denomNormFun(Area, na.rm = TRUE)
	
	
    NMEs  = abs(mod - obs) / denom
	return(NMEs)
}



plotNME.site <- function (x, y, obs, mod, score, name, cols, limits,
                          figOut = TRUE, addLegend = TRUE, ...) {

    if (figOut) {
		figName = setupPlot(name, 1, 2, mar = c(0,0,0,0), oma = c(2,0,0,0),
                            height2width = 0.5, scaleWidth = 6)
		labs = c('mod')
	} else {
		figName = NULL
		labs = c('')
	}
	mod = mean(mod)
    plotStandardMap(mod, labs, limits, cols, add_Legend = addLegend)
	
	plotNME.site.points(x, y, obs, addLegend)
	
    mar = par("mar")
    mar[2] = mar[2] + 2
	if (!figOut) mar[c(1,4)] = mar[c(1,4)] + 3
    par(mar = mar)
	
	if (addLegend) xaxt = 's' else xaxt = 'n'
    plot(score, xaxt = xaxt)
	
    if (figOut) dev.off.annotate(name)
    return(list(figName,"NaN"))
}

plotNME.site.points <- function(x, y, obs, addLegend = TRUE,
	                            limits = quantile(obs, seq(20,80,20)/100), pch = c(25, 6, 21, 2, 24)) {
	robs   = cut_results(obs, limits)

	for (i in sort(unique(robs))) {
		test = robs==i
		xi   = x[test]
		yi   = y[test]
		pchi = pch[i]
		points(xi, yi, pch = pchi, bg = 'black')
	}
	if (addLegend)
		legend(x = 'bottomleft', title = 'obs qunatile', pch = pch, pt.bg = 'black',
			   c('0-20%', '20-40%', '40-60%', '60-80%', '80-100%'))
}


plotNME.InterAnnual <- function(obs, mod, name, x, plotMe = TRUE, 
                                ObsCol = 'blue', ModCol = 'red', ...) {

    if (plotMe)
		figName = setupPlot(name, 1, 1, scaleWidth = 10)
	else figName = NULL
	
    x = x[[1]][1:length(obs)]
    if (plotMe) plot (range(x), range(c(obs, mod)), xlab = 'year', ylab = '', type = 'n')

    lines(x, obs, col = ObsCol)
    lines(x, mod, col = ModCol)
	NMEs = abs(mod-obs)/sum(abs(obs - mean(obs)))
    if (plotMe){
		legend('bottom', c('obs', 'mod'), col = c('blue','red'), lty = 1, bty = 'n')
		dev.off.annotate(name, y = 1.03)
	}
	##metric map1
	
    return(list(figName, NMEs))
}
