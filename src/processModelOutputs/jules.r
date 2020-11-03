process.jules <- function(files, varName, levels, startYear, layers, ...) {
    files0 = files
    
    if (noFileWarning(files, varName)) return(NULL)
    
    if (all(grepl('Monthly',files)) || all(grepl('monthly',files))) nm = 12 else nm = 1
   
    index = unique(ceiling((layers-1)/nm)[-1])
    if (varName == "c_veg") index = 8:16
    if (varName == "lai") {
        #index = 11:14
        #layers = 1:12
    } else {
        layers = layers - ((min(index))*nm)
    }
    
    files = files[index]
     
    layers = layers - ((min(index))*nm)
    
    if (layers[1] <=0) layers = layers - min(layers) + 1
    if (noFileWarning(files, varName)) return(NULL)
    # browser()
    #dat = lapply(as.list(1:12), process.jules.level, files, varName, layers, ...)
    dat = lapply(levels, process.jules.level, files, varName, layers, ...)
    
    if(length(dat) == 0 || all(sapply(dat, is.null))) return(NULL)
    return(dat)
}

process.jules.level <- function(level, files, varName,
                                layers, layersIndex, combine) {
    
    r = layer.apply(files, process.jules.file, level, varName)
    if (is.null(r)) return(NULL)
    
    if (tail(layers, 1) == (nlayers(r)+1)) layers = head(layers, -1)
    r = r[[layers]]
    r = combineRawLayers(r, layersIndex, combine)
    return(r)
}

process.jules.file <- function(file, level, varNames) {	
    nc = nc_open(file)
    vars = names(nc$var)
    varNames  = strsplit(varNames, ';')[[1]]


    getVar <- function(var) {
        var = nc$var[[which(vars == var)]]
        dat = ncvar_get( nc, var)
        return(dat)
    }
    openVarN <- function(varName) {
        if (all(vars != varName)) {
            noFileWarning(c(), varName)
            return(NULL)
        }	
        dat = getVar(varName)
    }
    
    dat = openVarN(varNames[1])
    if (length(varNames) > 1) for (i in varNames[-1]) dat = dat + openVarN(i)
    #dat = sapply(varNames, openVarN)

    lat = getVar("latitude")
    lon = getVar("longitude")
    tim = getVar("time_bounds")
	
    l = length(lat)
    
    multiLayer <- function(mn, leveli = level) {
        mdat = dat[, leveli, mn]
        if (!is.null(dim(mdat)))
            mdat = apply(mdat,1 , sum)
        return(mdat)
    }
	
    singleLayer <- function(mn) dat[, mn]
   	
    monthizeData <- function(mn, FUN, ...) {
        mdat = FUN(mn, ...)
        r = rasterFromXYZ(cbind(lon, lat, mdat))
        return(r)
    }
    
    if (length(dim(dat)) == 1) r = rasterFromXYZ(cbind(lon, lat, dat)) 
    else if (length(dim(dat)) == 2) r = layer.apply(1:12, monthizeData, singleLayer)
    else if (length(dim(dat)) == 3) {
        if (varNames != "landCoverFrac") {
            openWeightLayer <- function(fracLevel, varLevel) {
                frac = process.jules.file(file, fracLevel, "landCoverFrac")
                r = layer.apply(1:12, monthizeData, multiLayer, varLevel)
                frac * r / 100
	    }
            ri = mapply(openWeightLayer, list(1, 2, 3:5, 6:8, 9), 1:5)
            r = ri[[1]] + ri[[2]] + ri[[3]] + ri[[4]] + ri[[5]]				
        } else r = layer.apply(1:12, monthizeData, multiLayer)
    } else browser()
    
    return(r)
}
