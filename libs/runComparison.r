runComparisons <- function(comparisonList) {
    memSafeFile.remove()
    outs = mapply(runComparison, comparisonList, names(comparisonList))
    browser()
}

runComparison <- function(info, name) {
    varnN = which( Model.Variable[[1]][1,] == componentID(name)[1])
    obsTemporalRes = Model.Variable[[1]][3, varnN]

    simLayers = layersFrom1900(info$obsStart, obsTemporalRes, info$obsLayers)

    obs   = openObservation(info$obsFile, info$obsVarname, info$obsLayers)
    mod   = openSimulations(name, varnN, simLayers)
    masks = loadMask()

    compareWithMask <- function(mask) {
    ## Regrid if appripriate
        memSafeFile.initialise('temp/')

            if (is.raster(obs)) {
                c(obs, mod) := remask(obs, mod, mask)
                c(obs, mod) := cropBothWays(obs, mod)
            } else obs = list(obs)

            comps = comparison(mod, obs, name, info)
        memSafeFile.remove()
        return(comps)
    }
    comps = lapply(masks, compareWithMask)

    return(comps)
}

remask <- function(obs, mod, mask) {
    resample <- function(i) {
        if (is.null(i)) return(i)
        return(raster::resample(i, mask, filename = memSafeFile()))
    }
    obs = raster::resample(obs, mask)
    mod = lapply(mod, resample)

    if (mask_type == 'all') obs[is.na(mask)] = NaN
    else browser()

    return(list(obs, mod))
}

loadMask <- function() {
    if (mask_type == 'all') {
        files = list.files.patternPath(outputs_dir.modelMasks,
                                       full.names = TRUE)
        mask  = lapply(files, raster)
    } else browser()

    return(mask)
}

layersFrom1900 <- function(start, res, layers) {
    layers = layers - min(layers)
    diff = start - 1900
         if (res == "Annual" ) diff
    else if (res == "Monthly") diff = diff * 12
    else if (res == "Dailys" ) diff = diff * 365

    return(layers + diff)
}



comparison <- function(mod, obs, name, info) {
    if (is.True(info$allTogether)) { # Does this comparison require all models to be passed at the same time
        comp = do.call(info$ComparisonFun,
                       c(obs, list(mod), name, list(info$plotArgs),
                         info$ExtraArgs))
    } else { # or each model individually
        
        index = !(sapply(mod, is.null))

        comp = rep(list(NULL), length(mod))
        comp[index] = lapply(mod[index], function(i)
                      do.call(info$ComparisonFun,
                              c(obs, i, name, list(info$plotArgs),
                                info$ExtraArgs)))
        browser()
    }

    return(comp)
}
