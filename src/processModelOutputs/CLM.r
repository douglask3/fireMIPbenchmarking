process.CLM <- function(files, varName, levels, ...) {
    if (is.na(levels)) dat = process.CLM.default(files, varName, ...)
        else dat = layer.apply(levels, process.CLM.level, files, varName, ...)
}

process.CLM.level <- function(levels, files, varName, startYear,
                        layers, layersIndex, combine) {

    brickLevels <- function()
        lapply(1:96, function(i) brick.gunzip(file, level = i, nl = max(layers)))
    file = findAfile(files, varName)
    if (noFileWarning(files, varName)) return(NULL)

    dat = brickLevels()

    nc = nlayers(dat[[1]])
    nr = length(dat)

    r = raster(xmn = 0, xmx = 360, ymn = -90, ymx = 90,
                   nrows = nr, ncols = nc)

    buildCell <- function(lat, lon, layer, level)
        getValuesBlock(dat[[lat]][[lon]], row = level, nrow = 1, col = layer, ncol = 1)

    buildLayer <- function(...) {
        for (i in 1:nr) for (j in 1:nc) r[nr - i + 1, j] = buildCell(i, j, ...)
        return(r)
    }
    buildLevels <- function(i, ...)
        combineLayers(layer.apply(layers, buildLayer, i, ...), combine)

    dat = layer.apply(levels, buildLevels)
    dat = combineLayers(dat, 'sum')
    return(dat)
}


process.CLM.default <- function(files, varName, startYear,
                        layers, layersIndex, combine) {

    file = findAfile(files, varName)
    if (noFileWarning(file, varName)) return(NULL)

    dat = brick.gunzip(file)
    nr = nrow(dat)

    layer = raster(xmn = 0, xmx = 360, ymn = -90, ymx = 90,
                   nrows = nr, ncols = nlayers(dat))

    makeLayer <- function(i) {
        layers = layers[which(i == layersIndex)]
        openLayer <- function(j) {
			if (j > ncol(dat)) stop("looking for a time-slide outside time dimesion.\n",
			                         "Have you set the start/end years correctly for CLM?")
            layer[] = getValuesBlock(dat, row = 1, nrow = nr, col = j, ncol = 1)
            return(layer)
        }

        dat = layer.apply(layers, openLayer)
        dat = combineLayers(dat, combine)
        return(writeRaster(dat, memSafeFile(),
               overwrite = TRUE))
    }
    dat = layer.apply(unique(layersIndex), makeLayer)
    dat = convert_pacific_centric_2_regular(dat)
    return(dat)
}
