FullMM <- function(obs, mod, name, plotArgs = NULL, extraItem = NULL,
                   itemNames = letters[1:nlayers(obs)], nRRs = 10, ...) {

	sumRasterNoWarn <- function(dat, ...) {
		if (nlayers(dat) == 1) return(dat)
		return(sum(dat))
	}

	addExtraItem <- function(dat, maxval)
		addLayer(dat, maxval - sumRasterNoWarn(dat))

    if (!is.null(extraItem))
        c(obs, mod) := lapply(c(obs, mod), addExtraItem, extraItem)

    obs = layer.apply(obs, function(i) {i[i<0]= NaN; i})

    weights = area(obs)

    names(obs) = itemNames
    names(mod) = itemNames

    score   = MM (obs, mod, weights)
    null    = null.MM(obs, w =  weights, n = nRRs)

    if (!is.null(plotArgs))
        figName = do.call(plotMM, c(obs, mod, name, list(itemNames), plotArgs,
                          ...))

    return(list(score, null, figName))
}

plotMM <- function(obs, mod, name, itemNames, cols, dcols, limits, dlimits) {

    figName = setupPlotStandardMap(name, 4, nlayers(obs))

    plotItems <- function(x, txt, ...) {
        for (i in 1:nlayers(x))
            plotStandardMap(x[[i]], paste(txt, itemNames[i], sep = '-'), ...)
    }

    plotItems(obs      , 'obs'      , limits , cols )
    plotItems(mod      , 'mod'      , limits , cols )
    plotItems(mod - obs, 'mod - obs', dlimits, dcols)

    MMs = sum(abs(obs - mod))
    plotStandardMetricMap(MMs, 'MM realtive contributions')

    dev.off.annotate(name)
    return(figName)
}