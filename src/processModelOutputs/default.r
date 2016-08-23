process.default <- function(files, varName, startYear,
                        layers, layersIndex, combine) {
    file = findAfile(files, varName)
    if (is.null(file)) return(NULL)

    dat = brick.gunzip(file)
    dat = dat[[layers]]

    makeLayer <- function(i) {
        layers = which(i == layersIndex)
        dat = dat[[layers]]
        dat = combineLayers(dat, combine)
        return(dat)
    }

    dat = combineRawLayers(dat, layersIndex)
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
