memSafeFile <- function () 
{
    if (!exists("memSafeFile.Count")) 
        memSafeFile.initialise()
    memSafeFile.Count <<- memSafeFile.Count + 1
    fname = paste(memSafeFile.filename, memSafeFile.Count, memSafeFile.ext, 
        sep = ".")
	if (file.exists(fname)) {
		return(memSafeFile())
	} else return(fname)
}