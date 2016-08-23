process.orchidee <- function(files, varName, startYear,
                        layers, layersIndex, combine) {
    files0 = files
    files = findAfile(files, varName, '', FALSE)
    if (noFileWarning(files)) return(NULL)

    nl = nlayers(brick.gunzip(files[1]))
    lyersIndex = (layers-1)/nl
    yearsIndex = floor(lyersIndex)
    lyersIndex = (lyersIndex - yearsIndex) * nl
    lyersIndex = split(lyersIndex + 1, yearsIndex)

    index = unique(floor(yearsIndex)) + 1950
    index = apply(sapply(index, grepl, files), 1, sum)!=0
    files = files[index]

    dat = lapply(files, brick.gunzip)

    dat = mapply(function(i, j) i[[j]], dat, lyersIndex)
    dat = layer.apply(dat, function(i) i)

    dat = combineRawLayers(dat, layersIndex)
    return(dat)
}
