process.RAW <- function(varInfo, modInfo, rawInfo, layers) {

    c(modLayers, layersIndex) :=
        calculateLayersFromOpening(varInfo, modInfo, layers, rawInfo[[3]])

    tempFile = paste(c(temp_dir, '/RAW', rawInfo[c(1,3)], modInfo,
                     min(layers), '-', max(layers), '.nc'), collapse = '')
    if (file.exists(tempFile)) dat = brick(tempFile)
    else {

        dir = paste(data_dir.ModelOuutputs, rawInfo[[1]], experiment, sep = '/')
        files = list.files(dir, full.names = TRUE)

        memSafeFile.initialise('temp/')
            dat = rawInfo[[2]](files, varName = modInfo[1],
                               startYear = rawInfo[[3]], modLayers, layersIndex,
                               combine = varInfo[4])

            dat = writeRaster(dat, tempFile, overwrite = TRUE)
        memSafeFile.remove()
    }
    return(dat)
}

calculateLayersFromOpening <- function(varInfo, modInfo, layers, startYear) {
    varTime = varInfo[3]; modTime = modInfo[3]
    FUN = paste(varTime, '2', modTime, sep = '')
    if (!exists(FUN, mode = 'function')) stop("unknown timestep combinations")

    FUN = match.fun(FUN, startYear)
    return(FUN(layers, startYear))
}

Monthly2Daily <- function(layers, start) {
    monthN = layers %% 12 + 1
    ModLayers = c()
    ModLayersindex = c()

    for (i in 1:length(layers)) {
        ModLayer = 365 * floor(layers[i]/12)
        mn = monthN[i]
        if (mn > 1) ModLayer = ModLayer + sum(month_length[(mn - 1):1])
        ModLayer = (ModLayer+1):(ModLayer + month_length[mn])
        ModLayers = c(ModLayers, ModLayer)

        ModLayer = rep(layers[i], length.out = length(ModLayer))

        ModLayersindex = c(ModLayersindex, ModLayer)
    }

    ModLayers = ModLayers - 365 * (start - 1900)

    return(list(ModLayers, ModLayersindex))
}

Monthly2Annual <- function(layers) {
    browser()
}


Daily2Monthly <- function(layers) {
    browser()
}

Daily2Annual <- function(layers) {
    browser()
}

Annual2Monthly <- function(layers) {
    browser()
}


Annual2Daily <- function(layers) {
    browser()
}

process.CLM <- function(files, varName, startYear,
                        layers, layersIndex, combine) {
    print('clm')
    index = which(grepl(varName, files))
    if (multiNoFileWarnings(index)) return(NULL)

    dat = brick.gunzip(files[index[1]])
    nr = nrow(dat)

    layer = raster(xmn = 0, xmx = 360, ymn = -90, ymx = 90,
                   nrows = nr, ncols = nlayers(dat))

    makeLayer <- function(i) {
        layers = which(i == layersIndex)

        openLayer <- function(j) {
            layer[] = getValuesBlock(dat, row = 1, nrow = nr, col = j, ncol = 1)
            layer = convert_pacific_centric_2_regular(layer)
            return(layer)
        }

        dat    = layer.apply(layers, openLayer)
        return(writeRaster(match.fun(combine)(dat), memSafeFile(),
               overwrite = TRUE))
    }

    dat = layer.apply(unique(layersIndex), makeLayer)

    return(dat)
}

multiNoFileWarnings <- function(x) {
    if (length(x) > 1) warning(paste('None-unique file for ', 'CLM',
                               ' - variable:', varName ,
                               '. First file selected', sep = ''))

    if (length(x) == 0) {
        warnings(paste('No file found for ', 'CLM', ' - variable:', varName,
                       '. Model ignored for this variable'))
        return(TRUE)
    }
    return(FALSE)
}

process.CTEM <- function(dir, varName, startYear, layers) {
    browser()

}

process.inferno <- function(dir, varName, startYear, layers) {
    browser()

}

process.jsbach <- function(dir, varName, startYear, layers) {
    browser()

}

process.lpj <- function(dir, varName, startYear, layers) {
    browser()

}

process.orchidee <- function(dir, varName, startYear, layers) {
    browser()

}
