scaleMod <- function(dat, modInfo, varnN, obsInfo = NULL) {
	if (is.null(dat)) return(dat)
	modInfo = modInfo[2, varnN]
	if (is.null(obsInfo)) obsInfo = 1 else obsInfo = obsInfo[2, varnN] 
	
    if (modInfo == "Ha") {
        dat = covertFromHa2Frac(dat)
        modInfo = 1
    }
	
    scale = as.numeric(obsInfo)/as.numeric(modInfo)
	
	if (is.raster(dat)) {
		fname = strsplit(filename.noPath(dat[[1]]), ".nc")[[1]][1]
		fname = paste(temp_dir, fname, scale, '.nc', sep = "")
		if (file.exists(fname)) return(stack(fname))
	}
	
    if (scale != 1) {
        scaleMod <- function(i)
            writeRaster(i * scale, file = memSafeFile())
		if (is.raster(dat))
			dat = layer.apply(dat, scaleMod)
		else dat[,-(1:2)] = dat[,-(1:2)] * scale
    }
	if (is.raster(dat))
		dat =  writeRaster.gitInfo(dat, fname, overwrite = TRUE)
    return(dat)
}

covertFromHa2Frac <- function(dat) {
    a = area(dat) * 100
    dat = memSafeFunction(dat, '/', a)
    return(dat)
}
