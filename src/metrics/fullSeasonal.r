FullSeasonal <- function(obs, mod, name,
                         plotArgs, yearLength = 12, nRRs = 2, ...) {
    weights = raster::area(obs[[1]])
	
	obs   = climateologize(obs, yearLength)
	mod   = climateologize(mod, yearLength)
	
    score = MPD(obs, mod, w = weights, ncycle = yearLength)
    null  = null.MPD(obs, w = weights, ncycle = yearLength, n = nRRs)
	
	
	if (outputMetricFiles) FullSeasonal.outputFile(obs, mod, score, name)

    if (!is.null(plotArgs) & plotArgs & plotModMetrics)
        c(figNames, metricMap) := plotSeasonal(obs, mod, name, score, ...)
	else
		figNames = metricMap = NULL
    return(list(score, null, figNames))
}

FullSeasonal.outputFile <- function(obs, mod, score, name) {

	outFname <- function(nm)		
			fname  = paste(outputs_dir, nm, '-fullSeasonal', '.nc', sep = '')
			
	
	comment <- function(fname0) {
				list(history = 
						paste('Calculated from project temp file:' , fname0,
		                      '. NOTE: this temp file may have been calculated in an early',
							  ' git revision than the one stated here. Delete "', fname0,
							  '" in "', temp_dir, '" before generating files to insure up-to-date',
							  ' climatology calculation. This file may have been generated as',
							  ' part of a chain of temp files, so deleting the individual file',
							  ' wont do.'),
					   Contact = ContactDetails)
	}
	writeNcOut <- function(fname0, ...) writeRaster.gitInfo(..., comment = comment(fname0))
	
	individualClimPhaseConc <- function(r, extraName, FUN, mask) {
		fname0 = filename(r)
		if (fname0 == "") fname0 = filename(r[[1]])
		
		outFnamei <- function(nm)		
			outFname(paste(extraName, nm, sep = '-'))
		
		writeNcOuti <- function(...) writeNcOut(fname0, ...)
		
		## Climatology
		fname = outFnamei('Climatology')
		if (!file.exists(fname)) writeNcOuti(r, fname, zname = 'time', zunit = 'month')
		
		fnameP = outFnamei('Phase')
		fnameC = outFnamei('Concentration')
		
		## Phase and concentration
		if (any(!file.exists(fnameP, fnameC))) {
			PC = PolarConcentrationAndPhase(r, phase_units='months')
			writeNcOuti(PC[[1]], fnameP)
			writeNcOuti(PC[[2]], fnameC)
		} else  PC = layer.apply(c(fnameP, fnameC), raster)
		
		return(list(PC, fname0))
	}
	extraNames0 = strsplit(name, 'model-')[[1]]
	extraNames  = paste(extraNames0, c('observation', 'simulation'), sep = '-')
	extraNames  = paste(extraNames, 'mask', extraNames0[1], sep = '-')
	
	mod[is.na(obs[[1]])] = NaN
	
	c(obs, obsFname) := individualClimPhaseConc(obs, extraNames[1])
	c(mod, modFname) := individualClimPhaseConc(mod, extraNames[2])
	
	## MPD comparison
	cfname = paste(paste(extraNames0, collapse = '_AND_'), 
	               'comparison', 'mask', extraNames0[1], sep = '-')
				   
	
	fname  = paste(cfname, 'MPD_map', sep = '-')
	fname = outFname(fname)
	if (!file.exists(fname)) {
		MPD = mapSeasonal.phse(mod[[1]], obs[[1]])[[2]]
		writeNcOut(paste(obsFname, ' AND ', modFname), MPD, fname)
	}
	
	## NME conc comparison
	fname  = paste(cfname, 'NME_concentration_map', sep = '-')
	fname = outFname(fname)
	if (!file.exists(fname)) {
		NME = mapNME(mod[[2]], obs[[2]])
		writeNcOut(paste(obsFname, ' AND ', modFname), NME, fname)
	}	
	
}


climateologize <- function(r, yearLength = 12) {
	fname = filename.noPath(r, noExtension=TRUE)
	if (fname == "") fname = filename.noPath(r[[1]], noExtension=TRUE)
	fname = paste(temp_dir,fname, '-climatology.nc', sep = '')
	
	if (file.exists(fname)) return(stack(fname))
	out = r[[1:yearLength]]

	nlayers = nlayers(r)
	scaling = floor(nlayers / yearLength)
	nlayers = scaling * yearLength
	
	
	for (i in 1:nlayers) {
		j = baseN(i, yearLength)
		out[[j]] = out[[j]] + r[[i]] / scaling
	}
	out = writeRaster.gitInfo(out, fname)
	return(out)
	
}

baseN <- function(i, N = 12) {
	i = i - N *floor(i / N)
	i[i == 0] = N
	return(i)
}
