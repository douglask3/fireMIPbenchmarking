process.LPJ <- function(files, varName, levels, ...) {
    
    if (varName == "lai") dat = process.LPJ.LAI(files, varName, ...)
	else if (all(is.na(levels)))
	    dat = process.default(files, varName, levels, ...)
	else dat = layer.apply(levels, process.LPJ.level, files, varName, ...)
    return(dat)	
}

process.LPJ.LAI <- function(files, varName, startYear, layers, ...) {
    levels = 'all'
        	
    c(lai, nVtypes) := process.LPJ.level(levels, files, varName, startYear, layers, ...)
    c(frac, nVtypes) := process.LPJ.level(levels, files, "landCoverFrac", startYear, layers, ...)
   
    LAI = process.laiFracRelayers(lai, frac, layers, nVtypes) 
    return(LAI)
}

process.laiFracRelayers <- function(lai, frac, layers, nVtypes) {
    lai = lai * frac
    nlay = nlayers(lai) / nVtypes
	
    combineVtypes <- function(vn) sum(lai[[(1 + (vn - 1) * nVtypes):(vn*nVtypes)]])
    lai = layer.apply(1:nlay, combineVtypes)
	
    index = layers - layers[1] + 1
    lai = layer.apply(index, function(i) lai[[i]])
    return(lai)
}
	

process.LPJ.level <- function(levels, files, varName, startYear,
                        layers, layersIndex, combine, nr = 360) {
	
    processLayers = unique(layers)
    brickLevels <- function()
        lapply(1:nr, function(i) brick.gunzip(file, level = i)[[processLayers]])
    
   
    file = findAfile(files, varName)
    if (noFileWarning(files, varName)) return(NULL)
	
    
    dat = brickLevels()
    nc =  nrow(dat[[1]])
    if (levels == "all") {
        nlevelJump = ncol(dat[[1]])
	levels = 1
	combine = NULL
    } else nlevelJump = 1
    
    r = brick(xmn = -180, xmx = 180, ymn = -90, ymx = 90,
                   nrows = nr, ncols = nc, nl = nlevelJump)

    buildCell <- function(lat, layer, level) {
	 out = getValuesBlock(t(dat[[lat]][[layer]]), row = level, nrow = nlevelJump)
	return(rev(out))		
    }
	
    buildLayer <- function(...) {
        for (i in 1:nr) r[nr - i + 1, ] = buildCell(i, ...)	
        return(r)
    }
	
    buildLevels <- function(i, ...) {
	out = layer.apply(1:nlayers(dat[[1]]), buildLayer, i, ...)
        if (!is.null(combine)) out = combineLayers(out, combine)
	return(out)
    }	
	
    dat = layer.apply(levels, buildLevels)
	
    if (is.null(combine)) return(c(dat, nlevelJump)) 
	
    dat = combineLayers(dat, 'sum')
	
    return(dat)
}
