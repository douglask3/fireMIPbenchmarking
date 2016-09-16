process.RAW <- function (rawInfo, varInfo, modInfo, modLayers, layersIndex,
                         outFile) {
    cat(paste('\nOpening raw data for', rawInfo[[1]], 'for',
              varInfo[[1]], 'comparison\n'))

    dir   = paste(data_dir.ModelOutputs, rawInfo[[1]], experiment, sep = '/')
    files = list.files(dir, full.names = TRUE, recursive = TRUE)
    levels = findModelLevels(modInfo[5])
    
    memSafeFile.initialise('temp/')
        dat = rawInfo[[2]](files, varName = modInfo[1], levels = modInfo[5],
                           startYear = rawInfo[3], modLayers, layersIndex,
                           combine = varInfo[5])

        if (!is.null(dat)) dat = scaleMod(dat, varInfo[2], modInfo[2])
        if (!is.null(dat)) dat = writeRaster(dat, outFile, overwrite = TRUE)
    memSafeFile.remove()

    return(dat)
}

findModelLevels <- function(levels) {
    
    levels = strsplit(levels, ';')[[1]]#
    
    findRange <- function(j) {
        j = strsplit(j, ':')[[1]]
        j = as.numeric(j)
        
        ln = length(j)
        if (ln > 3) warning('incorrect levels definition. Check your cfg file')
        if (ln > 1) j = j[1]:j[2]
        
        return(j)
    }
    
    findItemLevels <- function(i) {   
        if (substr(i, 1, 1) == '-') {
            i = substr(i, 2, nchar(i))
            neg = TRUE
        } else neg = FALSE
        
        i = strsplit(i, ',')[[1]]
        i = sapply(i, findRange)
        if (neg) i = -i
        return(i)
    }
    levels = lapply(levels, findModelLevels)
    return(levels)
}

################################################################################
## Scaling Funs                                                               ##
################################################################################
scaleMod <- function(dat, obs, mod) {
    if (mod == "Ha") {
        dat = covertFromHa2Frac(dat)
        mod = 1
    }
    scale = as.numeric(obs)/as.numeric(mod)

    if (scale != 1) {
        scaleMod <- function(i)
            writeRaster(i * scale, file = memSafeFile())
        dat = layer.apply(dat, scaleMod)
    }
    return(dat)
}

covertFromHa2Frac <- function(dat) {
    a = area(dat) * 100
    dat = memSafeFunction(dat, '/', a)
    return(dat)
}
