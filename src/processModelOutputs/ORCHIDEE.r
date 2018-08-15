process.orchidee <- function(files, varName, levels, ...) {
    if (is.na(levels)) dat = process.orchidee.levels(1:12, files, varName, ...)
        else dat = layer.apply(levels, process.orchidee.levels, files, varName, ...)
    return(dat)
}
process.orchidee.levels <- function(levels, files, varName, startYear,
                        layers, layersIndex, combine) {
	
    files0 = files
    files = findAfile(files, varName, '', FALSE)
    if (noFileWarning(files, varName)) return(NULL)
    files1 = files
    nl = nlayers(brick.gunzip(files[1]))
    lyersIndex = (layers-1)/nl
    yearsIndex = floor(lyersIndex)
    lyersIndex = (lyersIndex - yearsIndex) * nl
    lyersIndex = split(lyersIndex + 1, yearsIndex)

    pyear = as.numeric(strsplit(tail(strsplit(files[1], '_')[[1]],1),'.nc')[[1]])
    index = unique(floor(yearsIndex)) + pyear
    index = apply(sapply(index, grepl, files), 1, sum)!=0

    files = files[index]

    brickLevels <- function(file) {
        openLevel <- function(i) brick.gunzip(file, level = i, nl = nl)
        dat = openLevel(levels[1])
        for (i in levels[-1]) dat = dat + openLevel(i)
        return(dat)
    }

    dat = lapply(files, brickLevels)
	
    dat = mapply(function(i, j) i[[round(j)]], dat, lyersIndex)
    dat = layer.apply(dat, function(i) i)
    
    dat = combineRawLayers(dat, layersIndex, combine)
	
    return(dat)
}
