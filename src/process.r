process.RAW <- function (rawInfo, varInfo, modInfo, modLayers, layersIndex, scling,
                         outFile) {
    cat(paste('\nOpening raw data for', rawInfo[[1]], 'for',
              varInfo[[1]], 'comparison\n'))

    dir   = paste(data_dir.ModelOutputs, rawInfo[[1]], experiment, sep = '/')
    files = list.files(dir, full.names = TRUE, recursive = TRUE)
    levels = findModelLevels(modInfo[5])
	
    memSafeFile.initialise('temp/')
        dat = rawInfo[[2]](files, varName = modInfo[1], levels = levels,
                           startYear = rawInfo[3], modLayers, layersIndex,
                           combine = varInfo[5])
		
        if (!is.null(dat)) {
			dat = memSafeFunction(dat, '*', scling) 
            dat = writeRaster(dat, outFile, overwrite = TRUE)
            #if (is.list(dat) && length(dat)) dat = dat[[1]]
		}
		 
    memSafeFile.remove()

    return(dat)
}

findModelLevels <- function(levels) {
    if (is.na(levels) || levels == 'NA' || levels == 'NaN') return(NaN)
    levels = strsplit(levels, ';')[[1]]

    findRange <- function(j) {
        j = strsplit(j, ':')[[1]]
        j = as.numeric(j)

        ln = length(j)
        if (ln > 3) warning('incorrect levels definition. Check your cfg file')
        if (ln > 1) j = j[1]:j[2]

        return(j)
    }

    findItemLevels <- function(i) {
        if (substr(i, 1, 1) == '-') {
            i = substr(i, 2, nchar(i))
            neg = TRUE
        } else neg = FALSE

        i = strsplit(i, ',')[[1]]
        i = unlist(lapply(i, findRange))
        if (neg) i = -i
        return(i)
    }
    levels = lapply(levels, findItemLevels)
    return(levels)
}

