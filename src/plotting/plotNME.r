plotNME.spatial <- function(obs, mod, ...) {
	wgthdMean <- function(x)
		sum(values(x * area(x)), na.rm = TRUE) /
			sum(values(area(x, na.rm = TRUE)), na.rm = TRUE)

	wgthdVar  <- function(x) {
		x = abs(x - wgthdMean(x))
		return(wgthdMean(x))
	}

    c(f1, map1) := plotNME.spatial.stepN(mod, obs, 1, ...)

    mod = mod * wgthdMean(obs) / wgthdMean(mod)
    c(f2, map2) := plotNME.spatial.stepN(mod, obs, 2, ...)

    mod = mod * wgthdVar(obs) / wgthdVar(mod)
    c(f3, map3) := plotNME.spatial.stepN(mod, obs, 3, ...)
    return(list(c(f1, f2, f3), c(map1, map2, map3)))
}

plotNME.spatial.stepN <- function(mod, obs, step, name, cols, dcols, metricCols = NMEmap_cols, 
                                  limits, dlimits, metricLimits = NULL, 
								  figOut = TRUE, plotObs = TRUE, ...) {

    stepN   = paste("step", step, sep = '')
    if (figOut) { 
		figName = setupPlotStandardMap(paste(name, stepN, sep = '-'), 2, 2)
		labs = c('obs', 'mod', 'mod - obs', paste('NME relative contributions -', stepN))
		add_legend = TRUE
	} else {
		labs = rep('', 4)
		add_legend = FALSE
	}
	
	if(plotObs) plotStandardMap(obs, labs[1], limits, cols, add_legend = add_legend)
    plotStandardMap( mod, labs[2], limits, cols, add_legend = add_legend)
	if (!figOut) mtext(name, side = 2, line = -1)
    plotStandardMap(mod - obs, labs[3], dlimits, dcols, add_legend = add_legend)
	

    mnObs = sum(values(mod*area(mod)), na.rm = TRUE) /
            sum(values(area(mod,na.rm = TRUE)), na.rm = TRUE)

    NMEs  = abs(mod - obs) / abs(obs - mnObs)
	

    plotStandardMetricMap(NMEs, labs[4], metricLimits, cols = metricCols, add_legend = add_legend)

    if (figOut) dev.off.annotate(paste(name, stepN))
	else figName = NULL
    return(c(figName, NMEs))
}


plotNME.site <- function (x, y, obs, mod, score, name, cols, limits, nRRs = 2,
                          ...) {

    figName = setupPlot(name, 1, 2, mar = c(0,0,0,0), oma = c(2,0,0,0),
                        height2width = 0.5, scaleWidth = 6)

    plotStandardMap(mod, 'mod', limits, cols)

    limits = quantile(obs, seq(20,80,20)/100)
    robs   = cut_results(obs, limits)
    pch    = c(25, 6, 21, 2, 24)

    for (i in sort(unique(robs))) {
        test = robs==i
        xi   = x[test]
        yi   = y[test]
        pchi = pch[i]
        points(xi, yi, pch = pchi, bg = 'black')
    }
    legend(x = 'bottomleft', title = 'obs qunatile', pch = pch, pt.bg = 'black',
           c('0-20%', '20-40%', '40-60%', '60-80%', '80-100%'))

    mar = par("mar")
    mar[2] = mar[2] + 2
    par(mar = mar)
    plot(score)
    dev.off.annotate(name)
	##metric map1
	
    return(list(figName,"NaN"))
}


plotNME.InterAnnual <- function(obs, mod, name, x) {

    figName = setupPlot(name, 1, 1, scaleWidth = 10)
    x = x[[1]][1:length(obs)]
    plot (range(x), range(c(obs, mod)), xlab = 'year', ylab = '', type = 'n')

    lines(x, obs, col = 'blue')
    lines(x, mod, col = 'red')
	NMEs = abs(mod-obs)/sum(abs(obs - mean(obs)))
    legend('bottom', c('obs', 'mod'), col = c('blue','red'), lty = 1, bty = 'n')
    dev.off.annotate(name, y = 1.03)
	##metric map1
	
    return(list(figName, NMEs))
}
