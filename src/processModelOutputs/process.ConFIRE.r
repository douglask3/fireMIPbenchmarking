process.ConFIRE <- function(levels, files, varName, startYear,
                        layers, layersIndex, combine) {
						
	files = files[grepl(varName, files)]
	
	if (length(files) > 1) files = files[grepl('-rw', files)]
	if (noFileWarning(files, varName)) return(NULL)
	
	r = brick(files)
	
	return(r)	
}