plotSeasonal <- function(obs, mod, ...) {
    obs = PolarConcentrationAndPhase(obs, phase_units = "months")
    mod = PolarConcentrationAndPhase(mod, phase_units = "months")
	
    f1 = plotSeasonal.phse(obs[[1]], mod[[1]], ...)
    f2 = plotSeasonal.conc(obs[[2]], mod[[2]], ...)
	
    return(c(f1, f2))
}

plotSeasonal.conc <- function(obs, mod, name, score, ...) {

    cols    = c('white', 'black')
    dcols   = c('green', 'white', 'red')
    limits  = c(0, 0.2, 0.4, 0.6, 0.8)
    dlimits = c(-0.2, -0.1, -0.05, 0.05, 0.1, 0.2)

    plotNME.spatial(obs, mod, name, cols, dcols, limits, dlimits, ...)
}

plotSeasonal.phse <- function(obs, mod, name, score, ...) {

    figName = setupPlotStandardMap(name, 2, 3, width = c(0.1, 1, 1))

    limits      = list(  0:11,
                       c(-5.5:5.5))
    cols        = list(c('blue','cyan','red', 'orange', 'blue'),
                       c("#660066","#0000FF",'white','#FF0000', "#660066"))

    #c(obs, mod) := lapply(c(obs, mod), {function(i) i[i<0] = i[i<0] + 12; i})
    SeasonLegend(limits[[1]], cols[[1]], dat = obs)

    mapply(plotStandardMap, c(obs, mod), c('obs','mod'),
           MoreArgs = list(limits[[1]], cols[[1]], add_legend = FALSE))

    dif = mod = mod - obs

    mod[mod < (-6)] = mod[mod <(-6)] + 6
    mod[mod >   6 ] = mod[mod >  6 ] - 6

    SeasonLegend(limits[[2]], cols[[2]], dat = mod)

    plotStandardMap(mod,  'mod - obs', limits[[2]], cols[[2]],
                 add_legend = FALSE)

    dif = acos(cos(dif))

    plotStandardMetricMap(dif, 'MPD realtive contributions')

    dev.off.annotate(name)
    return(figName)
}
