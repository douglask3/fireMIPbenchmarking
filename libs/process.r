process.RAW <- function (rawInfo, varInfo, modLayers, layersIndex) {
    cat(paste('\nOpening raw data for', rawInfo[[1]], 'for',
              varInfo[[1]], 'comparison\n'))
    dir   = paste(data_dir.ModelOutputs, rawInfo[[1]], experiment, sep = '/')
    files = list.files(dir, full.names = TRUE, recursive = TRUE)

    memSafeFile.initialise('temp/')
        dat = rawInfo[[2]](files, varName = modInfo[1],
                           startYear = rawInfo[[3]], modLayers, layersIndex,
                           combine = varInfo[4])

        dat = scaleMod(dat, varInfo[2], modInfo[2])

        if (!is.null(dat)) dat = writeRaster(dat, tempFile, overwrite = TRUE)
    memSafeFile.remove()
}

################################################################################
## Layer Indexing Funs                                                        ##
################################################################################
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

    ModLayers = floor(layers / 12)
    ModLayers = ModLayers - start + 1900

    return(list(ModLayers, layers))
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


################################################################################
## Scaling Funs                                                               ##
################################################################################
scaleMod <- function(dat, obs, mod) {
    if (mod == "Ha") {
        dat = covertFromHa2Frac(dat)
        mod = 1
    }
    scale = as.numeric(obs)/as.numeric(mod)

    if (scale != 1) {
        scaleMod <- function(i)
            writeRaster(i * scale, file = memSafeFile())
        dat = layer.apply(dat, scaleMod)
    }
    return(dat)
}

covertFromHa2Frac <- function(dat) {
    a = area(dat) * 100
    dat = memSafeFunction(dat, '/', a)
    return(dat)
}
