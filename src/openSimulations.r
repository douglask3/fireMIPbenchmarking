openSimulations <- function(name, varnN,  ...)
    mapply(openSimulation,  Model.Variable[-1], Model.RAW,
           MoreArgs = list(name, varnN, ...))


openSimulation <- function(modInfo, rawInfo, name, varnN, layers) {
    varInfo = Model.Variable[[1]][,varnN]
    if (varnN > ncol(modInfo)) varnN = ncol(modInfo)
    modInfoi = modInfo = modInfo[,varnN]
	
	operators = c('*', '%', '-', '+')
	FUNs      = c(function(i, dats) dats[[1]][[i]] * dats[[2]][[i]],
				  function(i, dats) dats[[1]][[i]] / dats[[2]][[i]],
				  function(i, dats) dats[[1]][[i]] + dats[[2]][[i]],
				  function(i, dats) dats[[1]][[i]] - dats[[2]][[i]])
	
	testMultiVar = lapply(operators, grep, modInfoi[1], fixed = TRUE)
	
	if (length(unlist(testMultiVar)) > 0) {
		tempFile = paste(c(temp_dir, '/processed', '---', varInfo[1], '-', rawInfo[[1]], modInfo[1], 1, modInfo[-(1:2)],
                     min(layers), '-', max(layers), '.nc'), collapse = '')
		if (file.exists(tempFile)) dat = return(brick(tempFile))
		else {
			operateSim <- function(op, FUN) {
				splitInfo <- function(info) {
					if (is.character(info) && length(grep('&', info)) > 0)
						info = strsplit(info, '&')[[1]]
					return(info)
				}
				modVar   = strsplit(modInfoi[1], op, fixed = TRUE)[[1]]
				if (length(modVar) == 1) return(NULL)
				scling   = splitInfo(modInfoi[2])
				yrstart  = splitInfo(modInfoi[3])
				timestep = splitInfo(modInfoi[4])
				
				openDat <- function(mv, sc, ys, ts) {
					modInfo[1] = mv
					modInfo[2] = sc
					modInfo[3] = ys
					modInfo[4] = ts
					dat = openModel(varInfo, modInfo, rawInfo, layers)
					return(dat)
				}
				
				dats = mapply(openDat, modVar, scling, yrstart, timestep)
				dat = memSafeFunction(1:nlayers(dats[[1]]), FUN, dats)
				dat = writeRaster(dat, filename = memSafeFile())
				return(dat)
			}
			dat = mapply(operateSim, operators, FUNs)
			dat = dat[!sapply(dat, is.null)][[1]]
			dat = writeRaster.gitInfo(dat, tempFile)
		}
		
	} else dat = openModel(varInfo, modInfo, rawInfo, layers)	
    
    return(dat)
}

openModel <- function(varInfo, modInfo, rawInfo, layers) {
    if (modInfo[1] == "NULL") return(NULL)
	
    c(modLayers, layersIndex, scling) :=
        calculateLayersFromOpening(varInfo, modInfo, layers, as.numeric(modInfo[3]))
	
	rinfo = paste(strsplit(rawInfo[[1]], '/')[[1]], collapse = '---')
    tempFile = paste(c(temp_dir, '/processed', '-', varInfo[1], '-', rinfo, modInfo[1], 1, modInfo[-(1:2)],
                     min(layers), '-', max(layers), '.nc'), collapse = '')
	tempFile = gsub(':', '---', tempFile)
    if (file.exists(tempFile)) dat = brick(tempFile)
    else dat = process.RAW(rawInfo, varInfo, modInfo,
                           modLayers, layersIndex, scling, tempFile)
	
    return(dat)
}


################################################################################
## Layer Indexing Funs                                                        ##
################################################################################
calculateLayersFromOpening <- function(varInfo, modInfo, layers, startYear) {
    varTime = varInfo[3]; modTime = modInfo[4]

    FUN = paste(varTime, '2', modTime, sep = '')
    if (!exists(FUN, mode = 'function')) stop("unknown timestep combinations")
    print(FUN)
    FUN = match.fun(FUN)
    return(FUN(layers, as.numeric(startYear)))
}

 Daily2Daily  <- function(...) Monthly2Monthly(..., n = 365)
Annual2Annual <- function(...) Monthly2Monthly(..., n = 1  )

Monthly2Monthly <- function(layers, start, n = 12) {
    ModLayers = layers - n * (start - 1900) + 1
    return(list(ModLayers, layers, 1))
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

    return(list(ModLayers, ModLayersindex, 30))
}

Monthly2Annual <- function(layers, start) {

    ModLayers = floor(layers / 12)
    ModLayers = ModLayers - start + 1900 +1

    return(list(ModLayers, layers, 1/12))
}


Daily2Monthly <- function(layers, start) {
    browser()
}

Daily2Annual <- function(layers, start) {
    browser()
}

Annual2Monthly <- function(layers, start) {
    ModLayers =  unlist(lapply(layers, function(i) i * 12 + 1:12))
    ModLayersindex = rep(layers, each = 12)

    ModLayers = ModLayers - 12 * (start - 1900)

    return(list(ModLayers, ModLayersindex, 12))
}


Annual2Daily <- function(layers, start) {
    browser()
}
