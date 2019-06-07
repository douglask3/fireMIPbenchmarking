openObservation <- function(file, varname,...) {
    obs_dir = data_dir.BenchmarkData
    if (length(varname)==1 && varname == 'csv') {
        dat = try(openCsvInputs(file = file, dir = obs_dir, ...), silent = TRUE)
    } else {
        dat = try(openRasterInputs(file = file, varname = varname,
                                   dir = obs_dir, check4mask = TRUE, ...), silent = TRUE)
    }
	
    if (!class(dat) == "try-error") return(dat)
}

openCsvInputs <- function(file, layerID = NULL, scaling = NULL, dir) {
    file = paste(dir, file, sep="")
    dat = read.csv(file)
    if (!is.null(scaling)) browser()
    return(dat)
}

openRasterInputs <- function(file, varname = "", layerID = NULL, scaling = NULL, 
                             dir, check4mask = FALSE) {
	
    if (is.null(varname)) varname = ""
    fname = paste(dir, file, sep = "")
    
    openVar <- function(varn, fnamei, sumT = TRUE) {
	if (is.numeric(varn)) {
	    dat = brick(fnamei)[[varn]]
	    dat = sum(dat)[[1]]
	} else dat = brick(fnamei, varname = varn)
	dat = convert_pacific_centric_2_regular(dat)
	if (sumT) dat = sum(dat)
	return(dat)
    }
	
    openVars <- function(varns, ..., sumT = FALSE) {
	varn = strsplit(varns, ';')[[1]]
    
	dat = layer.apply(varn, openVar, ...)
	if (sumT) dat = sum(dat)
        return(dat)
    }
    
    if (length(file) > 1) dat = layer.apply(fname, openVars, varns = varname)
    else if (length(varname) > 1) dat = layer.apply(varname, function(i) openVar(fname, varn = i))
    else dat = openVar(varname, fname, FALSE)
     
    if (nlayers(dat) > length(fname) && !is.null(layerID)) {
        if(is.list(layerID))
            dat = layer.apply(layerID, function(i) mean(dat[[i]]))
        else dat = dat[[layerID]]
    }	
	
    if (check4mask) {
        tempFname = paste(c(temp_dir, filename.noPath(file, TRUE), varname, range(layerID), "_maskRemoval.nc"), collapse = "")
	tempFname= paste(strsplit(tempFname, ":")[[1]], collapse = '---')
	if (file.exists(tempFname)) {
	    dat = brick(tempFname)
	} else {
	    if (nlayers(dat) == 1) dat = dat[[1]]
	    dat[dat > 9E9] = NaN
	    dat = writeRaster.gitInfo(dat, tempFname)
	}
    }
    
    if (!is.null(scaling)) dat = scaling(dat)
	
    return(dat)
}
