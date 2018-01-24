process.CLM <- function(files, varName, levels, ...) {
	if (varName == 'lai')                 process.CLM.lai(files, varName, ...)
		else if (is.na(levels)) dat = process.CLM.default(files, varName, ...)
        else dat = layer.apply(levels, process.CLM.level, files, varName, ...)
	
}

process.CLM.lai <- function(files, varName, startYear, layers, layersIndex, combine, ...) {
	nVtypes = 17
	levels = 1:nVtypes
	processLayers = unique(layers)
	
	runForLayer <- function(vname = varName) 
		layer.apply(processLayers, function(i) process.CLM.level( levels, files, vname, 
					startYear, i, layersIndex, combine = NULL, ...))
	
	lai = runForLayer()
	lai[is.na(lai)] = 0.0
	frac = runForLayer("landCoverFrac")
	
	lai = process.laiFracRelayers(lai, frac, layers, nVtypes)
	lai = convert_pacific_centric_2_regular(lai)
	return(lai)
}


process.CLM.level <- function(levels, files, varName, startYear,
                        layers, layersIndex, combine, nr = 96) {
	
    brickLevels <- function()
        lapply(1:nr, function(i) brick.gunzip(file, level = i, nl = max(layers)))
    file = findAfile(files, varName) 	
    if (noFileWarning(files, varName)) return(NULL)

    dat = brickLevels()
    nc  = nlayers(dat[[1]])
	
    r = raster(xmn = 0, xmx = 360, ymn = -90, ymx = 90,
                   nrows = nr, ncols = nc)

    buildCell <- function(lat, layer, level) 
		dat[[lat]][level, layer]

    buildLayer <- function(...) {
        for (i in 1:nr) r[nr - i + 1, ] = buildCell(i, ...)
        return(r)
    }
	
    buildLevels <- function(i, ...) {
		dat = layer.apply(layers, buildLayer, i, ...)
        if (!is.null(combine)) dat = combineLayers(dat, combine)
		return(dat)
	}

    dat = layer.apply(levels, buildLevels)
    if (!is.null(combine)) dat = combineLayers(dat, 'sum')
	
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
