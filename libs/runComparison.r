runComparisons <- function(comparisonList) {
    outs = mapply(runComparison, comparisonList, names(comparisonList))
    browser()
}

runComparison <- function(info, name) {
    varnN = which( Model.Variable[[1]][1,] == componentID(name)[1])
    obsTemporalRes = Model.Variable[[1]][3, varnN]

    simLayers = layersFrom1900(info$obsStart, obsTemporalRes, info$obsLayers)

    obs = openObservation(info$obsFile, info$obsVarname, info$obsLayers)
    mod = openSimulations(name, varnN, simLayers)

    ## Regrid if appripriate
    if (is.raster(obs)) c(obs, mod) := cropBothWays(obs, mod)
        else obs = list(obs)

    comps = comparison(mod, obs, info)

    return(comps)
}

layersFrom1900 <- function(start, res, layers) {
    layers = layers - min(layers)
    diff = start - 1900
         if (res == "Annual" ) diff
    else if (res == "Monthly") diff = diff * 12
    else if (res == "Dailys" ) diff = diff * 365

    return(layers + diff)
}

comparison <- function(mod, obs, info) {
    lapply(mod, function(i)
           do.call(info$ComparisonFun,
                   c(obs, i, name, list(info$plotArgs), info$ExtraArgs)))
}
