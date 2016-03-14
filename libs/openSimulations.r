openSimulations <- function(name, varnN,  ...)
    mapply(openSimulation,  Model.Variable[-1], Model.RAW,
           MoreArgs = list(name, varnN, ...))


openSimulation <- function(modInfo, rawInfo, name, varnN, layers) {
    varInfo = Model.Variable[[1]][,varnN]
    modInfo = modInfo[,varnN]
    dat = openModel(varInfo, modInfo, rawInfo, layers)
    return(dat)
}

openModel <- function(varInfo, modInfo, rawInfo, layers) {
    c(modLayers, layersIndex) :=
        calculateLayersFromOpening(varInfo, modInfo, layers, rawInfo[[3]])

    tempFile = paste(c(temp_dir, '/processed', rawInfo[c(1,3)], modInfo,
                     min(layers), '-', max(layers), '.nc'), collapse = '')

    if (modInfo[1] == "NULL") return(NULL)

    if (file.exists(tempFile)) dat = brick(tempFile)
    else dat = process.RAW(rawInfo, varInfo, modInfo, modLayers, layersIndex, tempFile)
    
    return(dat)
}
