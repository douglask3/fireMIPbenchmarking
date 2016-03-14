runComparisons <- function(comparisonList) {
    memSafeFile.remove()
    outs = mapply(runComparison, comparisonList, names(comparisonList))
    browser()
}

runComparison <- function(info, name) {

    componentID <- function(name) strsplit(name,'.', TRUE)[[1]]

    varnN = which( Model.Variable[[1]][1,] == componentID(name)[1])
    obsTemporalRes = Model.Variable[[1]][3, varnN]

    simLayers = layersFrom1900(info$obsStart, obsTemporalRes, info$obsLayers)

    obs   = openObservation(info$obsFile, info$obsVarname, info$obsLayers)
    mod   = openSimulations(name, varnN, simLayers)
    c(masks, mnames) := loadMask()

    compareWithMask <- function(mask, mname) {
    ## Regrid if appripriate
        memSafeFile.initialise('temp/')

            if (is.raster(obs)) {
                c(obs, mod) := remask(obs, mod, mask)
                c(obs, mod) := cropBothWays(obs, mod)
            } else obs = list(obs)

            name  = paste(name, '-mask', mname, sep ='')
            files = comparison(mod, obs, name, info)
        memSafeFile.remove()
        return(files)
    }
    files = mapply(compareWithMask, masks, mnames)
    comparisonOutput(files, mnames, name)
    browser()
    return(comps)
}

comparisonOutput <- function(files, mnames, name) {
    dat = lapply(files,read.csv, row.names = 1)

    modNames = Model.plotting[,1]
    mskNames = substr(mnames,2, nchar(mnames)-1)

    mskOrder = sapply(modNames, function(i) which(mskNames == i))
    addition = setdiff(1:length(mskNames),mskOrder)
    names(addition) = mskNames[addition]
    mskOrder = c(mskOrder, addition)

    tab4Col <- function(i, tname) {
        col = sapply(dat, function(j) j[,i])
        col = col[,mskOrder]

        anotateMin <- function(j, sym = '*') {
            index = which(as.numeric(j)==min(as.numeric(j), na.rm = TRUE))

            j[index] = paste(j[index], sym, sep = '')
            return(j)
        }
        anotateMin <- function(j) {
            j[j == "N/A"] = NA
            if (all(is.na(j))) return(rep(FALSE, length(j)))
            index = as.numeric(j)== min(as.numeric(j), na.rm = TRUE)
            index[is.na(index)] = FALSE
            return(index)
        }

        col1 = t(apply(col, 1, anotateMin))
        col2 =   apply(col, 2, anotateMin)

        col[col1] = paste(col[col1], '*', sep = '')
        col[col2] = paste(col[col2], '+', sep = '')

        colnames(col) = names(mskOrder)
        rownames(col) = modNames

        file = paste(outputs_dir, name, tname, 'allMasks', '.csv', sep = '')
        write.csv(col, file)
        cat(gitFullInfo(), file = file, append = TRUE)
    }
    mapply(tab4Col, 1:ncol(dat[[1]]), colnames(dat[[1]]))
}

remask <- function(obs, mod, mask) {
    resample <- function(i) {
        if (is.null(i)) return(i)
        return(raster::resample(i, mask))
    }
    obs = memSafeFunction(obs, resample)

    mod = lapply(mod, memSafeFunction, resample)

    if (mask_type == 'all') obs[is.na(mask)] = NaN
    else browser()

    return(list(obs, mod))
}

loadMask <- function() {
    if (mask_type == 'all') {
        files = list.files.patternPath(outputs_dir.modelMasks,
                                       full.names = TRUE)
        names = lapply(files, function(i) strsplit(i, outputs_dir.modelMasks)[[1]][2])
        names = sapply(names, function(i) strsplit(i, '.nc')[[1]][1])


        mask  = lapply(files, raster)
    } else browser()

    return(list(mask, names))
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
    }
    if (is.null(comp)) return(NULL)
    file =  outputScoves(comp, name, info)
    return(file)
}
