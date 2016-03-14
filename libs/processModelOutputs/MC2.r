process.MC2 <- function(files, varName, startYear,
                        layers, layersIndex, combine) {
    brickLevels <- function()
        lapply(1:40, function(i) brick.gunzip(file, level = i, nl = max(layers)))

    file = findAfile(files, varName)
    if (is.null(file)) return(NULL)

    dat0 = brickLevels()
    dat = dat0[[1]][[1]]

    combineLayers <- function(i) {
        dat = dat0[[1]][[i]]
        for (j in dat0[-1]) dat = dat + j[[i]]
        return(dat)
    }

    dat = memSafeFunction(layers, combineLayers)
    browser()
    return(dat)
}

combineRawLayers <- function(dat, layersIndex) {
    makeLayer <- function(i) {
        layers = which(i == layersIndex)
        dat = dat[[layers]]
        dat = combineLayers(dat, combine)
        return(dat)
    }
    dat = layer.apply(unique(layersIndex), makeLayer)
    return(dat)
}
