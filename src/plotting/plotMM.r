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
