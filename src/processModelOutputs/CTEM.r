process.CTEM <- function(files, varName, levels, ...)
   dat = layer.apply(levels, process.CTEM.level, files, varName, ...)

process.CTEM.level <- function(levels, files, varName, startYear,
                        layers, layersIndex, combine,
                        vegVarN = 'landCoverFrac', tiles = 1:9) {
	
    if (is.na(levels)) levels = tiles
    brickLevels <- function()
        lapply(levels, function(i) brick.gunzip(file, level = i, nl = max(layers)))

    ## Open variable
    file = findAfile(files, varName)
    if (noFileWarning(file, varName)) return(NULL)

    dat0 = brickLevels()
	
    if (grepl('CTEM',file) &  grepl('CLASS-', file)) {
	file = findAfile(files, vegVarN)
        veg0 = brickLevels()[[1]]
	dat0 = lapply(dat0, function(i) {extent(i) = extent(veg0); i})
    }		
	
	#if (grepl('CTEM',file) & !grepl('pft.nc', file)) vegVarN = NULL
	
    ## Open frac cover
    openFrac_test = !is.null(vegVarN) && varName != vegVarN
    if (openFrac_test) {
        file = findAfile(files, vegVarN)
        veg0 = brickLevels()
		mask = !is.na(veg0[[1]][[1]])
    } else mask = NULL

    noNaN <- function(dat) {
        dat[is.na(dat)] = 0
        return(dat)
    }

    combineLevels <- function(i) {
        cat(i, ' ')
	if (grepl('CTEM',file) &  grepl('CLASS-', file)) vi = floor(i/12) else vi = i
        if (openFrac_test) v1 = veg0[[1]][[vi]] else v1 = 1
        
        if (varName == "mrso" && length(dat0) == 1) {
            dat =  noNaN(dat0[[1]][[i]])
        } else {
            dat = noNaN(dat0[[1]][[i]]) * v1
            for (j in 2:(length(levels))) {
                if (openFrac_test) v2 = veg0[[j]][[vi]] else v2 = 1
                dat = dat + noNaN(dat0[[j]][[i]]) * v2
            }
        }
        if (!is.null(mask)) dat[is.na(mask)] = NaN
        dat = convert_pacific_centric_2_regular(dat)
        return(dat)
    }
	
    dat = layer.apply(layers, combineLevels)

    dat = combineRawLayers(dat, layersIndex, combine)
	
    return(dat)
}
