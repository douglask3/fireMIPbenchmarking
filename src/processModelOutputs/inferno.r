process.INFERNO <- function(files, varName, ...) {
    file = findAfile(files, varName)
	if (noFileWarning(file, varName)) return(NULL)
	
    if(length(nc_open(file)$dim)== 3) dat = process.default(files, varName, ...)
        else dat = process.CTEM(files, varName, ..., vegVarN = "LandCoverFrac")
    return(dat)
}
