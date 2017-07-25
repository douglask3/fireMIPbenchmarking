runComparisons <- function(comparisonList) {
    try(memSafeFile.remove(), silent = TRUE)
    outs = mapply(runComparison, comparisonList, names(comparisonList), SIMPLIFY = FALSE)
    ## outputs all?
}

runComparison <- function(info, name, mod = NULL) {
    if(is.null(info$noMasking)) info$noMasking = FALSE
    componentID <- function(name) strsplit(name,'.', TRUE)[[1]]

    varnN = which( Model.Variable[[1]][1,] == componentID(name)[1])
    obsTemporalRes = Model.Variable[[1]][3, varnN]
    if (is.null(info$obsLayers)) obsLayers = 1 else obsLayers = info$obsLayers
    simLayers = layersFrom1900(Model.Variable[[1]][4,varnN],
                               obsTemporalRes, obsLayers)
    
    obs   = openObservation(info$obsFile, info$obsVarname, info$obsLayers)
    if (is.null(mod))
		mod   = openSimulations(name, varnN, simLayers)
	
    mask  = loadMask(obs, mod, name)	
    c(obs, mod) := remask(obs, mod, mask, name)
	
	obs = scaleMod(obs, Model.Variable[[1]], varnN)
	mod = mapply(scaleMod, mod, Model.Variable[-1], MoreArgs = list(varnN))
    
	if (openOnly) return(list(obs, mod))
	
	scores = comparison(mod, obs, name, info)
    return(list(scores, obs, mod))
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
        if (!is.raster(obs)) obs = list(obs)
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
	
	plotVarAgreement(mod, obs, name, info, scores, comp)
    try(mapMetricScores(comp, name, info))
	
    return(scores)
}
