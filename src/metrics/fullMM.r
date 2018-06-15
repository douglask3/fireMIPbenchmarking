FullMM <- function(obs, mod, name, plotArgs = NULL, extraItem = NULL,
                   itemNames = letters[1:nlayers(obs)], switchMod = FALSE, nRRs = 10, ...) {

	sumRasterNoWarn <- function(dat, ...) {
		if (nlayers(dat) == 1) return(dat)
		return(sum(dat))
	}
		
	addExtraItem <- function(dat, maxval)
		addLayer(dat, sumRasterNoWarn(dat)[[1]] * -1 + maxval)
	
    if (!is.null(extraItem)) {
		obs = addExtraItem(obs, extraItem)
		mod = addExtraItem(mod, extraItem)
	}
    
	obs = obs[[1:length(itemNames)]]
	mod = mod[[1:length(itemNames)]]
    obs = layer.apply(obs, function(i) {i[i<0]= NaN; i})
	
    weights = raster::area(obs)
	
    names(obs) = itemNames
    names(mod) = itemNames
	
	if (switchMod) mod = mod[[nlayers(mod):1]]

    score   = MM (obs, mod, weights)
    null    = null.MM(obs, w =  weights, n = nRRs)

    if (!is.null(plotArgs))
        figName = do.call(plotMM, c(obs, mod, name, list(itemNames), plotArgs,
                          ...))

    return(list(score, null, figName))
}
