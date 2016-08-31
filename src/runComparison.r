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
    c(obs, mod) := remask(obs, mod, mask, name)
    scores = comparison(mod, obs, name, info)
    
    #comparisonOutput(scores, name)
    return(scores)
}

comparisonOutput <- function(scores, name) {
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


remask <- function(obs, mod0, mask, varnN) {
    ## if no mask to apply, return as is
    if (is.null(mask) || (is.character(mask) && mask == "NULL"))
        return(list(obs, mod))

    ## if mask has been applied and stored in cache, return cache
    present = !sapply(mod0, is.null)
    mod = mod0[present]

    filename_obs = paste(temp_dir, filename.noPath(mask, TRUE)       , 'obsRemasked.nc', sep = '-')
    filename_mod = paste(temp_dir, sapply(mod, filename.noPath, TRUE), 'modRemasked.nc', sep = '-')
    filenames    = c(filename_obs, filename_mod)

    if (files.exist(filenames)) {
        obs = stack(filename_obs)
        mod0[present] = lapply(filename_mod, stack)
        return(list(obs, mod0))
    }

    ## otherwise mask files
    memSafeFile.initialise('temp/')

    resample <- function(i, remask = FALSE) {
        if (is.null(i)) return(i)
        i = raster::resample(i, mask)
        if (remask) i[mask == 1] = NaN
        return(i)
    }

    obs = memSafeFunction(obs, resample, TRUE)
    mod = lapply(mod, memSafeFunction, resample)

    c(obs, mod) := cropBothWays(obs, mod)

    obs = writeRaster(obs, filename_obs, overwrite = TRUE)
    mod = mapply(writeRaster, mod, filename_mod,
                 MoreArgs = list(overwrite = TRUE))

    memSafeFile.remove()
    mod0[present] = mod
    return(list(obs, mod0))
}



loadMask <- function(obs, mod, varnN) {
    mod = mod[!sapply(mod, is.null)]

    filename = paste(c(temp_dir, varnN, names(mod), '.nc'), collapse = '-')
    if(file.exists(filename)) return(raster(filename))

    mod = lapply(mod, function(i) sum(i))
    obs = sum(obs)
    mod = layer.apply(mod, function(i) raster::resample(i, obs))

    mask = sum(mod) + obs
    mask = is.na(mask)

    mask = writeRaster(mask, filename = filename)
    return(mask)
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
