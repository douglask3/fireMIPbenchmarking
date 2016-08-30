runComparisons <- function(comparisonList) {
    try(memSafeFile.remove(), silent = TRUE)
    outs = mapply(runComparison, comparisonList, names(comparisonList))
    ## outputs all?
}

runComparison <- function(info, name) {

    if(is.null(info$noMasking)) info$noMasking = FALSE
    componentID <- function(name) strsplit(name,'.', TRUE)[[1]]

    varnN = which( Model.Variable[[1]][1,] == componentID(name)[1])
    obsTemporalRes = Model.Variable[[1]][3, varnN]

    simLayers = layersFrom1900(Model.Variable[[1]][4,varnN],
                               obsTemporalRes, info$obsLayers)

    obs   = openObservation(info$obsFile, info$obsVarname, info$obsLayers)
    mod   = openSimulations(name, varnN, simLayers)

    mask  = loadMask(obs, mod, name)
    browser()
    c(mod, obs) = remask(mod, obs)

    compareWithMask <- function(mask, mname) {
        obs0 = obs
    ## Regrid if appripriate
        memSafeFile.initialise('temp/')
            if (is.raster(obs)) {
                c(obs, mod) := remask(obs, mod, mask)
                c(obs, mod) := cropBothWays(obs, mod)
            } else obs = list(obs)

            name  = paste(name, '-mask', mname, sep ='')
            scores = comparison(mod, obs, name, info)
        memSafeFile.remove()
        return(scores)
    }

    scores = mapply(compareWithMask, masks, mnames, SIMPLIFY = FALSE)
    comparisonOutput(scores, mnames, name)
    return(scores)
}

comparisonOutput <- function(scores, mskNames, name) {
    #dat = lapply(files,read.csv, row.names = 1)
    modNames = Model.plotting[,1]
    if (length(mskNames)>1)  mskNames = substr(mskNames,2, nchar(mskNames)-1)
    if (length(mskNames) == length(modNames)) {
        mskOrder = sapply(modNames, function(i) which(mskNames == i))
        addition = setdiff(1:length(mskNames),mskOrder)
        names(addition) = mskNames[addition]
        mskOrder = c(mskOrder, addition)
    } else mskOrder = 1:length(mskNames)

    tab4Col <- function(i, tname) {
        col = as.matrix(sapply(scores, function(j) j[,i]))

        if (length(mskOrder ) > 1) col = col[,mskOrder]

        anotateMin <- function(j) {
            if (length(j) == 1) return(FALSE)
            j[j == "N/A"] = NA
            if (all(is.na(as.numeric.start(j)))) return(rep(FALSE, length(j)))
            index = as.numeric.start(j)== min(as.numeric.start(j), na.rm = TRUE)
            index[is.na(index)] = FALSE
            return(index)
        }

        col1 = t(apply(col, 1, anotateMin))
        col2 =   apply(col, 2, anotateMin)

        col[col1] = paste(col[col1], '*', sep = '')
        col[col2] = paste(col[col2], '+', sep = '')

        colnames(col) = names(mskOrder)
        rownames(col) = modNames

        file = paste(outputs_dir, name, tname, 'allMasks', '.csv', sep = '-')
        write.csv(col, file)
        cat(gitFullInfo(), file = file, append = TRUE)
        return(col)
    }
    tabi = mapply(tab4Col, 1:ncol(scores[[1]]), colnames(scores[[1]]),
                 SIMPLIFY = FALSE)
    tab = tabi[[1]]; for (i in tabi[-1]) tab = cbind(tab, i)
    if (length(scores) == 1) colnames(tab) = colnames(scores[[1]])
    return(tab)
}

remask <- function(obs, mod, mask) {
    if (is.null(mask) || (is.character(mask) && mask == "NULL"))
        return(list(obs, mod))

    resample <- function(i) {
        if (is.null(i)) return(i)
        return(raster::resample(i, mask))
    }

    obs = memSafeFunction(obs, resample)
    mod = lapply(mod, memSafeFunction, resample)

    if (mask_type == 'all' || mask_type == 'common')
        obs[is.na(mask)] = NaN
    else browser()

    return(list(obs, mod))
}



loadMask <- function(obs, mod, varnN) {
    mod = mod[!sapply(mod, is.null)]
    filenames = sapply(mod, filename.noPath, noExtension = TRUE)

    
    if(file.exists(filename)) return(raster(filename))

    mod = lapply(mod, function(i) sum(i))
    obs = sum(obs)
    mod = layer.apply(mod, function(i) raster::resample(i, obs))

    mask = sum(mod) + obs
    mask = is.na(mask)

    mask = writeRaster(mask, filename = filename)
    return(mask)
}


loadMask_old <- function(noMask) {
    if (noMask) return(list('NULL', 'noMask'))

    files = list.files.patternPath(outputs_dir.modelMasks,
                                   full.names = TRUE)

    if (mask_type == 'all') {
        names = lapply(files, function(i) strsplit(i, outputs_dir.modelMasks)[[1]][2])
        names = sapply(names, function(i) strsplit(i, '.nc')[[1]][1])
        mask  = lapply(files, raster)
    } else if (mask_type == 'common') {
        names = 'Common'
        file = files[grepl(names, files)]

        if (length(file) == 0) stop("Expecting a common mask, but no mask produced.
                                     Check you data/model outputs are opeing correctly")
        mask = list(raster(file))
    }

    return(list(mask, names))
}

layersFrom1900 <- function(start, res, layers) {
    layers = layers - min(layers)
    diff = as.numeric(start) - 1900
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
        FUN = function(i, j) {
            fname = paste(name, j, sep = 'model-')
            do.call(info$ComparisonFun, c(obs, i, fname, list(info$plotArgs),
                    info$ExtraArgs))
        }

        comp[index] = mapply(FUN, mod[index], names(mod)[index], SIMPLIFY = FALSE)
    }
    if (is.null(comp)) return(NULL)
    scores =  outputScores(comp, name, info)
    return(scores)
}
