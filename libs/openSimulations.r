openSimulations <- function(name, ...) {
    varnN = which( Model.Variable[[1]][1,] == componentID(name)[1])

    dat = mapply(openSimulation,  Model.Variable[-1], Model.RAW,
                 MoreArgs = list(name, varnN, ...))

    browser()
}


openSimulation <- function(modInfo, rawInfo, name, varnN, layers) {
    varInfo = Model.Variable[[1]][,varnN]
    modInfo = modInfo[,varnN]

    tempName = paste(c(temp_dir, '/', name, varInfo, modInfo, layers, '.nc'),
                     collapse = '')

    if (file.exists(tempName)) return(brick(tempName))

    dat = process.RAW(modInfo, varInfo, rawInfo, layers)
    browser()
}

componentID <- function(name) strsplit(name,'.', TRUE)[[1]]
