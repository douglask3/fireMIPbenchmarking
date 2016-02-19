runComparisons <- function(comparisonList) {
    outs = mapply(runComparison, comparisonList, names(comparisonList))
    browser()
}

runComparison <- function(info, name) {
    obs = openObservation(info$obsFile, info$obsVarname, info$obsLayers )
    mod = openSimulations(name, info$obsLayers)

    ## Regrid if appripriate
    if (is.raster(obs)) c(obs, mod) := cropBothWays(obs, mod)
        else obs = list(obs)

    comps = comparison(mod, obs, info)

    return(comps)
}

comparison <- function(mod, obs, info) {
    lapply(mod, function(i)
           do.call(info$ComparisonFun,
                   c(obs, i, name, list(info$plotArgs), info$ExtraArgs)))
}
