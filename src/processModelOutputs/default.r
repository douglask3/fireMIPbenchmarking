process.default <- function(files, varName, levels, ...)
   dat = layer.apply(levels, process.default.level, files, varName, ...)


process.default.level <- function(levels, files, varName, startYear,
                        layers, layersIndex, combine) {

    file = findAfile(files, varName)
    if (is.null(file)) return(NULL)

    if (is.na(levels)) dat = brick.gunzip(file)
        else dat = lapply(levels, function(i) brick.gunzip(file, level = i))

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
