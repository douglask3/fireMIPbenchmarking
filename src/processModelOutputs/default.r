process.default <- function(files, varName, levels, startYear,
                        layers, layersIndex, combine) {
    file = findAfile(files, varName)
    if (is.null(file)) return(NULL)

    dat = brick.gunzip(file)
    dat = dat[[layers]]
    dat = combineRawLayers(dat, layersIndex, combine)

    return(dat)
}

combineRawLayers <- function(dat, layersIndex, combine) {
    makeLayer <- function(i) {
        layers = which(i == layersIndex)
        dat = dat[[layers]]
        dat = combineLayers(dat, combine)
        return(dat)
    }
    dat = layer.apply(unique(layersIndex), makeLayer)
    return(dat)
}
