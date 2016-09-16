process.CTEM <- function(files, varName, levels, startYear,
                        layers, layersIndex, combine,
                        vegVarN = 'landCoverFrac', tiles = 1:9) {

    brickLevels <- function()
        lapply(tiles, function(i) brick.gunzip(file, level = i, nl = max(layers)))


    ## Open variable
    file = findAfile(files, varName)
    if (noFileWarning(files, varName)) return(NULL)
    dat0 = brickLevels()

    ## Open frac cover
    if (!is.null(vegVarN)) {
        file = findAfile(files, vegVarN)
        veg0 = brickLevels()
    }

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
        if (is.null(vegVarN)) v1 = 1  else v1 = veg0[[1]][[i]]

        dat = noNaN(dat0[[1]][[i]]) * v1
        for (j in tiles[-1]) {
            if (is.null(vegVarN)) v2 = 1 else v2 = veg0[[j]][[i]]
            dat = dat + noNaN(dat0[[j]][[i]]) * v2
        }
        dat[is.na(mask)] = NaN
        dat = convert_pacific_centric_2_regular(dat)
        return(dat)
    }
    dat = layer.apply(layers, combineLevels)

    dat = combineRawLayers(dat, layersIndex, combine)
    return(dat)
}
