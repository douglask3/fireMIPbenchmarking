wgthdMean <- function(x, ...) {
	if (is.raster(x)) FUN = wgthdMean.raster
	else FUN = wgthdMean.default
	return(FUN(x, ...))
}

wgthdMean.raster <- function(x, w = raster::area(x, na.rm = TRUE))
	sum(values(x * w), na.rm = TRUE) /
		sum(values(w), na.rm = TRUE)

#wgthdVar.raster   <- function(x, ...) {
#	x = abs(x - wgthdMean.raster(x, ...))
#	return(wgthdMean.raster(x, ...))
#}

wgthdMean.default <- function(x, w = rep(1, length(x)))
	sum(x * w, na.rm = TRUE) / sum(w, na.rm = TRUE)

wgthdVar   <- function(x, ...) {
	x = abs(x - wgthdMean(x, ...))
	return(wgthdMean(x, ...))
}

#removeMean.raster <- function(mod, obs)
#	mod - wgthdMean.raster(mod) + wgthdMean.raster(obs)

#removeVar.raster <- function(mod, obs)
#	mod * wgthdVar.raster(obs) / wgthdVar.raster(mod)
	
	
removeMean <- function(mod, obs, ...)
	mod - wgthdMean(mod) + wgthdMean(obs)

removeVar <- function(mod, obs, ...)
	mod * wgthdVar(obs, ...) / wgthdVar(mod, ...)

removeMeanVar <- function(mod, obs, ...) {
	mod = removeVar(mod, obs, ...)
	mod = removeMean(mod, obs, ...)
	return(mod)
}