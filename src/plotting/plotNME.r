plotNME.spatial <- function(obs, mod, ...) {
	wgthdMean <- function(x)
		sum(values(x * area(x)), na.rm = TRUE) /
			sum(values(area(x, na.rm = TRUE)), na.rm = TRUE)

	wgthdVar  <- function(x) {
		x = abs(x - wgthdMean(x))
		return(wgthdMean(x))
	}

    c(f1, map1) := plotNME.spatial.stepN(obs, mod, 1, ...)

    mod = mod * wgthdMean(obs) / wgthdMean(mod)
    c(f2, map2) := plotNME.spatial.stepN(obs, mod, 2, ...)

    mod = mod * wgthdVar(obs) / wgthdVar(mod)
    c(f3, map3) := plotNME.spatial.stepN(obs, mod, 3, ...)
    return(list(c(f1, f2, f3), c(map1, map2, map3)))
}

plotNME.spatial.stepN <- function(obs, mod, step, name, cols, dcols,
                                  limits, dlimits, ...) {

    stepN   = paste("step", step, sep = '')
    figName = setupPlotStandardMap(paste(name, stepN, sep = '-'), 2, 2)

    mapply(plotStandardMap, c(obs, mod), c('obs','mod'), MoreArgs = list(limits, cols))
    plotStandardMap(mod - obs, 'mod - obs', dlimits, dcols)

    mnObs = sum(values(mod*area(mod)), na.rm = TRUE) /
            sum(values(area(mod,na.rm = TRUE)), na.rm = TRUE)

    NMEs  = abs(mod - obs) / abs(obs - mnObs)

    stepN = paste("step", step, sep = ' ')
    plotStandardMetricMap(NMEs, paste('NME realtive contributions -', stepN))

    dev.off.annotate(paste(name, stepN))
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
