openSimulations <- function(name, varnN,  ...)
    mapply(openSimulation,  Model.Variable[-1], Model.RAW,
           MoreArgs = list(name, varnN, ...))


openSimulation <- function(modInfo, rawInfo, name, varnN, layers) {
    varInfo = Model.Variable[[1]][,varnN]
    modInfo = modInfo[,varnN]
    dat = process.RAW(varInfo, modInfo, rawInfo, layers)
    return(dat)
}

componentID <- function(name) strsplit(name,'.', TRUE)[[1]]
