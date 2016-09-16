process.orchidee <- function(files, varName, levels, startYear,
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

    index = unique(floor(yearsIndex)) + 1900
    index = apply(sapply(index, grepl, files), 1, sum)!=0

    files = files[index]

    brickLevels <- function(file) {
        openLevel <- function(i) brick.gunzip(file, level = i, nl = nl)
        dat = openLevel(1)
        for (i in 2:12) dat = dat + openLevel(i)
        return(dat)
    }

    dat = lapply(files, brickLevels)

    dat = mapply(function(i, j) i[[j]], dat, lyersIndex)
    dat = layer.apply(dat, function(i) i)

    dat = combineRawLayers(dat, layersIndex, combine)
    return(dat)
}
