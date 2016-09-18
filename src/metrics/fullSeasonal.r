FullSeasonal <- function(obs, mod, name,
                         plotArgs, yearLength = 12, nRRs = 2, ...) {
    weights = area(obs[[1]])
    score = MPD(obs, mod, w = weights)
    null  = null.MPD(obs, w = weights, n = nRRs)


    if (!is.null(plotArgs) & plotArgs)
        figNames = plotSeasonal(obs, mod, name, score, ...)
    return(list(score, null, figNames))
}
