process.default <- function(files, varName, levels, ...) 
    dat = layer.apply(levels, process.default.level, files, varName, ...)

process.default.level <- function(levels, files, varName, startYear,
                        layers, layersIndex, combine, amIMC2 = FALSE) {
	
    file = findAfile(files, varName)
    if (is.null(file)) return(NULL)
	

	if (max(layers) > nlayers(stack(file))) {
		if (amIMC2) layers = layers[layers < nlayers(stack(file))]
		else stop('layers exceed file length', file)	#
	}
    
	if (is.na(levels)) dat = brick.gunzip(file)[[layers]]
        else dat = lapply(levels, function(i) brick.gunzip(file, level = i)[[layers]])

        dat = layer.apply(dat, combineRawLayers, layersIndex, combine)
	dat = convert_pacific_centric_2_regular(dat)
	
    return(dat)
}

combineRawLayers <- function(dat, layersIndex, combine) {

    makeLayer <- function(i) {
        layers = which(i == layersIndex)
	#if (length(layers) == 1 && layers == nlayers(dat)) return(NULL)	
        dat = dat[[layers]]
        dat = combineLayers(dat, combine)
        return(dat)
    }
    if (nlayers(dat) == 1) return(dat)
    dat = layer.apply(unique(layersIndex), makeLayer)
    return(dat)
}
