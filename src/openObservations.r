openObservation <- function(file, varname,...) {
    obs_dir = data_dir.BenchmarkData
    if (length(varname)==1 && varname == 'csv') {
        dat = try(openCsvInputs(file = file, dir = obs_dir, ...), silent = TRUE)
    } else {
        dat = try(openRasterInputs(file = file, varname = varname,
                                   dir = obs_dir, ...), silent = TRUE)
    }

    if (!class(dat) == "try-error") return(dat)
}

openCsvInputs <- function(file, scaling = NULL, dir) {
    file = paste(dir, file, sep="")
    return(read.csv(file))
}

openRasterInputs <- function(file, varname = "", layerID = NULL, scaling = NULL, dir) {
    if (is.null(varname)) varname = ""

    fname = paste(dir, file, sep="")
    dat = layer.apply(varname, function(i) brick(fname, varname = i))

    if (!is.null(layerID)) {
        if(is.list(layerID))
            dat = layer.apply(layerID, function(i) mean(dat[[i]]))
        else dat = dat[[layerID]]
    }
    
    if (!is.null(scaling)) dat = scaling(dat)

    return(dat)
}
