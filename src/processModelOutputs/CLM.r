process.CLM <- function(files, varName, startYear,
                        layers, layersIndex, combine) {

    file = findAfile(files, varName)
    
    if (noFileWarning(files, varName)) return(NULL)

    dat = brick.gunzip(file)
    nr = nrow(dat)

    layer = raster(xmn = 0, xmx = 360, ymn = -90, ymx = 90,
                   nrows = nr, ncols = nlayers(dat))

    makeLayer <- function(i) {
        layers = which(i == layersIndex)

        openLayer <- function(j) {
            layer[] = getValuesBlock(dat, row = 1, nrow = nr, col = j, ncol = 1)
            return(layer)
        }

        dat = layer.apply(layers, openLayer)
        dat = combineLayers(dat, combine)
        return(writeRaster(dat, memSafeFile(),
               overwrite = TRUE))
    }

    dat = layer.apply(unique(layersIndex), makeLayer)

    return(dat)
}
