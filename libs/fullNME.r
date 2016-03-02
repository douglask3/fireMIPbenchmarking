FullNME <- function(obs, mod, name, plotArgs = NULL, mnth2yr = FALSE,
                    byZ = FALSE, nZ = 0, ...) {

    if (!byZ) return(FullNME.spatial(obs, mod, name, mnth2yr, plotArgs, ...))
        else  return(FullNME.InterAnnual(obs, mod, name, plotArgs, nZ, ...))
}

FullNME.spatial <- function(obs, mod, name, mnth2yr, plotArgs, nRRs = 2, ...) {
    obs     = mean(obs)
    mod     = mean(mod)
    weights = area(obs)

    if (mnth2yr) { obs = obs * 12; mod = mod * 12}

    score   = NME (obs, mod, weights)

    if (!is.null(plotArgs))
        figNames = do.call(plotNME.spatial, c(obs, mod, name, plotArgs, ...))

    null    = null.NME(obs, w = weights, n = nRRs)
    return(list(score, null, figNames))
}


FullNME.site <- function(obs, mod, name, plotArgs, nRRs = 2, ...) {
    x     = obs$lon
    y     = obs$lat
    obs   = obs[,3]

    rmod  = mod
    mod   = mean (mod)
    mod   = mod[cellFromXY(mod, cbind(x,y))]

    score = NME (obs, mod)

    if (!is.null(plotArgs))
        figName = do.call(plotNME.site, c(list(x), list(y), list(obs), rmod,
                           list(score), name, plotArgs, ...))

    null    = null.NME(obs, n = nRRs)
    return(list(score, null, figName))
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
    return(figName)
}


plotNME.spatial <- function(obs, mod, ...) {
	wgthdMean <- function(x)
		sum(values(x * area(x)), na.rm = TRUE) /
			sum(values(area(x, na.rm = TRUE)), na.rm = TRUE)

	wgthdVar  <- function(x) {
		x = abs(x - wgthdMean(x))
		return(wgthdMean(x))
	}

    f1 = plotNME.spatial.stepN(obs, mod, 1, ...)

    mod = mod * wgthdMean(obs) / wgthdMean(mod)
    f2 = plotNME.spatial.stepN(obs, mod, 2, ...)

    mod = mod * wgthdVar(obs) / wgthdVar(mod)
    f3 = plotNME.spatial.stepN(obs, mod, 3, ...)
    return(c(f1, f2, f3))
}

plotNME.spatial.stepN <- function(obs, mod, step, name, cols, dcols,
                                  limits, dlimits) {

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
    return(figName)
}

FullNME.InterAnnual <- function(obs, mod, name, plotArgs = NULL, nZ = 1,
                                nRRs = 2, ...) {
    ## Convert brick layers to ts
    calAnnual <- function(i) sum.raster(i * area(i), na.rm = TRUE)
    calIAV <- function(x) unlist(layer.apply(x, calAnnual))

    c(obs, mod) := lapply(list(obs, mod), calIAV)

    ## Convert ts to annual ts
    convert2annual  <- function(i, d) sum(d[(nZ*(i-1)+1):(nZ*i)])
    convert2Iannual <- function(d)
        sapply(1:floor(length(d)/nZ),convert2annual,d)

    if (nZ > 1) c(obs, mod) :=  lapply(list(obs, mod), convert2Iannual)

    score = NME (obs, mod)
    null  = null.NME(obs, n = nRRs)

    if (!is.null(plotArgs))
        figName = do.call(plotNME.InterAnnual, list(obs, mod, name, plotArgs, ...))

    return(list(score, null, figName))
}

plotNME.InterAnnual <- function(obs, mod, name, x) {

    figName = setupPlot(name, 1, 1, scaleWidth = 10)
    x = x[[1]]
    plot (range(x), range(c(obs, mod)), xlab = 'year', ylab = '', type = 'n')

    lines(x, obs, col = 'blue')
    lines(x, mod, col = 'red')

    legend('bottom', c('obs', 'mod'), col = c('blue','red'), lty = 1, bty = 'n')
    dev.off.annotate(name, y = 1.03)
    return(figName)
}
