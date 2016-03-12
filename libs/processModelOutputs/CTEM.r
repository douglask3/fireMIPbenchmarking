process.CTEM <- function(files, varName, startYear,
                        layers, layersIndex, combine,
                        vegVarN = 'landCoverFrac') {

    brickLevels <- function()
        lapply(1:9, function(i) brick.gunzip(file, level = i, nl = max(layers)))


    ## Open variable
    file = findAfile(files, varName)
    if (is.null(file)) return(NULL)
    dat0 = brickLevels()

    ## Open frac cover
    file = findAfile(files, vegVarN)
    veg0 = brickLevels()

    mask = is.na(dat0[[1]][[1]])
    for (i in 2:length(dat0)) mask = mask + is.na(dat0[[i]][[1]])

    test = mask == 10
    mask[ test] = NaN
    mask[!test] = 1

    noNaN <- function(dat) {
        dat[is.na(dat)] = 0
        return(dat)
    }

    combineLevels <- function(i) {
        cat(i, ' ')

        dat = noNaN(dat0[[1]][[i]]) * veg0[[1]][[i]]
        for (j in 2:9) dat = dat + noNaN(dat0[[j]][[i]]) * veg0[[j]][[i]]

        dat[is.na(mask)] = NaN
        dat = convert_pacific_centric_2_regular(dat)
        return(dat)
    }
    dat = layer.apply(layers, combineLevels)

    makeLayer <- function(i) {
        layers = which(i == layersIndex)
        dat = dat[[layers]]
        dat = combineLayers(dat, combine)
        return(dat)
    }

    dat = combineRawLayers(dat, layersIndex)
    return(dat)
}
