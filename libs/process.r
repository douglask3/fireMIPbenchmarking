process.RAW <- function(varInfo, modInfo, rawInfo, layers) {

    c(modLayers, layersIndex) :=
        calculateLayersFromOpening(varInfo, modInfo, layers, rawInfo[[3]])

    tempFile = paste(c(temp_dir, '/RAW', rawInfo[c(1,3)], modInfo,
                     min(layers), '-', max(layers), '.nc'), collapse = '')

    if (modInfo[1] == "NULL") return(NULL)

    if (file.exists(tempFile)) dat = brick(tempFile)
    else {
        cat(paste('\nOpening raw data for', rawInfo[[1]], 'for',
                  varInfo[[1]], 'comparison\n'))
        dir   = paste(data_dir.ModelOuutputs, rawInfo[[1]], experiment, sep = '/')
        files = list.files(dir, full.names = TRUE, recursive = TRUE)

        memSafeFile.initialise('temp/')
            dat = rawInfo[[2]](files, varName = modInfo[1],
                               startYear = rawInfo[[3]], modLayers, layersIndex,
                               combine = varInfo[4])

            if (!is.null(dat)) dat = writeRaster(dat, tempFile, overwrite = TRUE)
        memSafeFile.remove()
    }
    return(dat)
}

calculateLayersFromOpening <- function(varInfo, modInfo, layers, startYear) {
    varTime = varInfo[3]; modTime = modInfo[3]

    FUN = paste(varTime, '2', modTime, sep = '')
    if (!exists(FUN, mode = 'function')) stop("unknown timestep combinations")

    FUN = match.fun(FUN)
    return(FUN(layers, startYear))
}

 Daily2Daily  <- function(...) Monthly2Monthly(..., n = 365)
Annual2Annual <- function(...) Monthly2Monthly(..., n = 1  )

Monthly2Monthly <- function(layers, start, n = 12) {
    ModLayers = layers - n * (start - 1900) + 1
    return(list(ModLayers, layers))
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

Monthly2Annual <- function(layers, start) {
    browser()
}


Daily2Monthly <- function(layers, start) {
    browser()
}

Daily2Annual <- function(layers, start) {
    browser()
}

Annual2Monthly <- function(layers, start) {
    browser()
}


Annual2Daily <- function(layers, start) {
    browser()
}

process.CLM <- function(files, varName, startYear,
                        layers, layersIndex, combine) {

    file = findAfile(files, varName)
    if (is.null(file)) return(NULL)

    dat = brick.gunzip(file)
    nr = nrow(dat)

    layer = raster(xmn = 0, xmx = 360, ymn = -90, ymx = 90,
                   nrows = nr, ncols = nlayers(dat))

    makeLayer <- function(i) {
        layers = which(i == layersIndex)

        openLayer <- function(j) {
            layer[] = getValuesBlock(dat, row = 1, nrow = nr, col = j, ncol = 1)
            return(layer)
        }

        dat = layer.apply(layers, openLayer)
        dat = combineLayers(dat)
        return(writeRaster(dat, memSafeFile(),
               overwrite = TRUE))
    }

    dat = layer.apply(unique(layersIndex), makeLayer)

    return(dat)
}

combineLayers <- function(dat, combine) {
    if (nlayers(dat) > 1 ) dat = match.fun(combine)(dat)
    dat = convert_pacific_centric_2_regular(dat)
    return(dat)
}

findAfile <- function(files, varName, sep = '.', warn = TRUE, returnAll = !warn) {
    if (is.null(varName)) return(NULL)
    varName = paste(varName, sep, sep = '')
    index = which(grepl(varName, files, fixed = TRUE))
    if (warn && multiNoFileWarnings(index, varName)) return(NULL)
    files = files[index]
    if (!returnAll) files = files[1]
    return(files)
}

multiNoFileWarnings <- function(...) {
    oneFileWarning(...)
    noFileWarning(...)
}

oneFileWarning <- function(x, varName)
    if (length(x) > 1) warning(paste('None-unique file for ', 'CLM',
                               ' - variable:', varName ,
                               '. First file selected', sep = ''))


noFileWarning <- function(x, varName) {
    if (length(x) == 0) {
        warnings(paste('No file found for ', 'CLM', ' - variable:', varName,
                       '. Model ignored for this variable'))
        return(TRUE)
    }
    return(FALSE)
}

process.CTEM <- function(files, varName, startYear,
                        layers, layersIndex, combine) {
    file = findAfile(files, varName)
    if (is.null(file)) return(NULL)

    dat = brick.gunzip(file)
    dat = dat[[layers]]

    makeLayer <- function(i) {
        layers = which(i == layersIndex)
        dat = dat[[layers]]
        dat = combineLayers(dat)
        return(dat)
    }

    dat = combineRawLayers(dat, layersIndex)
    return(dat)
}

combineRawLayers <- function(dat, layersIndex) {
    makeLayer <- function(i) {
        layers = which(i == layersIndex)
        dat = dat[[layers]]
        dat = combineLayers(dat)
        return(dat)
    }
    dat = layer.apply(unique(layersIndex), makeLayer)
    return(dat)
}

process.orchidee <- function(files, varName, startYear,
                        layers, layersIndex, combine) {
    files = findAfile(files, varName, '_', FALSE)
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
