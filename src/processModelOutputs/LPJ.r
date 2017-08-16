process.LPJ <- function(files, varName, levels, ...) {
	if (all(is.na(levels))) dat = process.default(files, varName, levels, ...)
		else dat = layer.apply(levels, process.LPJ.level, files, varName, ...)
	return(dat)	
}

process.LPJ.level <- function(levels, files, varName, startYear,
                        layers, layersIndex, combine, nr = 360) {
	
	 brickLevels <- function()
        lapply(1:nr, function(i) brick.gunzip(file, level = i)[[layers]])
	file = findAfile(files, varName)
    if (noFileWarning(files, varName)) return(NULL)
	
	dat = brickLevels()
	
    nc =  nrow(dat[[1]])

    r = raster(xmn = -180, xmx = 180, ymn = -90, ymx = 90,
                   nrows = nr, ncols = nc)

    buildCell <- function(lat, layer, level) {
		out = getValuesBlock(t(dat[[lat]]), row = level, nrow = 1)
		return(rev(out))		
	}
	
    buildLayer <- function(...) {
        for (i in 1:nr) r[nr - i + 1, ] = buildCell(i, ...)
        return(r)
    }
	
    buildLevels <- function(i, ...)
        combineLayers(layer.apply(layers, buildLayer, i, ...), combine)

    dat = layer.apply(levels, buildLevels)
    dat = combineLayers(dat, 'sum')
	return(dat)
}
