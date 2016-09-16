process.RAW <- function (rawInfo, varInfo, modInfo, modLayers, layersIndex,
                         outFile) {
    cat(paste('\nOpening raw data for', rawInfo[[1]], 'for',
              varInfo[[1]], 'comparison\n'))

    dir   = paste(data_dir.ModelOutputs, rawInfo[[1]], experiment, sep = '/')
    files = list.files(dir, full.names = TRUE, recursive = TRUE)

    memSafeFile.initialise('temp/')
        dat = rawInfo[[2]](files, varName = modInfo[1], levels = modInfo[5],
                           startYear = rawInfo[3], modLayers, layersIndex,
                           combine = varInfo[5])

        if (!is.null(dat)) dat = scaleMod(dat, varInfo[2], modInfo[2])
        if (!is.null(dat)) dat = writeRaster(dat, outFile, overwrite = TRUE)
    memSafeFile.remove()

    return(dat)
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
