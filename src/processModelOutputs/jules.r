process.jules <- function(files, varName, levels, ...) {
    
	if (noFileWarning(files, varName)) return(NULL)

	dat = lapply(levels, process.jules.level, 
					          files, varName, ...)
    return(dat)
}

process.jules.level <- function(level, files, varName, startYear,
                        layers, layersIndex, combine) {
	r = layer.apply(files, process.jules.file, level, varName)
	
	r = r[[layers]]
	
	r = combineRawLayers(r, layersIndex, combine)
	
	return(r)
}
#process.CTEM.level <- function(levels, files, varName) {

process.jules.file <- function(file, level, varName) {
	
	nc = nc_open(file)
	vars = names(nc$var)
	
	getVar <- function(var) {
		var = nc$var[[which(vars == var)]]
		dat = ncvar_get( nc, var)
		return(dat)
	}
	
	dat = getVar(varName)
	lat = getVar("latitude")
	lon = getVar("longitude")
	tim = getVar("time_bounds")
	
	l = length(lat)
	
	multiLayer <- function(mn) dat[, level, mn]	
	singleLayer <- function(mn)mdat = dat[, mn]
	
	monthizeData <- function(mn, FUN) {
		mdat = FUN(mn)
		mdat = apply(mdat,1 , sum)
		r = rasterFromXYZ(cbind(lon, lat, mdat))
		return(r)
	}
	
	if (length(dim(dat)) == 2) FUN = singleLayer
		else if (length(dim(dat)) == 3) FUN = multiLayer
		else browser()
	
	r = layer.apply(1:12, monthizeData, FUN)
	
	return(r)
}