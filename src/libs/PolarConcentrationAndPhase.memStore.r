PolarConcentrationAndPhase.memStore <- function(x, phase_units = "months", ...) {
	fnameIn = filename(x[[1]])
	if (all(layer.apply(x, filename) == fnameIn) && fnameIn != "") {

		fnameOut = strsplit(fnameIn, '.nc', fixed = TRUE)[[1]]
		fnameOut = paste(fnameOut, 'phscnc', '.nc', sep = '-')
		if (file.exists(fnameOut)) return(stack(fnameOut))
		y = PolarConcentrationAndPhase(x, phase_units = phase_units, ...)
		y = writeRaster.gitInfo(y, fnameOut, overwrite = TRUE)
	} else
		y = PolarConcentrationAndPhase(x, phase_units = phase_units, ...)
	
	return(y)
}