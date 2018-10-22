loadMask <- function(obs, mod, res, varnN) {
    mod = mod[!sapply(mod, is.null)]
	
    filename = paste(c(temp_dir, varnN, names(mod), '.nc'), collapse = '-')
    if(file.exists(filename)) return(raster(filename))
	mod0 = mod
	
	sumFun <- function(r) {
		r = sum(r)[[1]]
		maskSize = sum(is.na(r[]))/length(r)
		if (maskSize < 0.1) r = sum(r, na.rm = TRUE)
		return(r)
	}
	
    mod = lapply(mod, sumFun)
	
    if (is.raster(obs)) obs = sum(obs)
        else {
            obs = raster(ncol = 720, nrow = 360)
            obs[] = 1
        }
		
	if (nlayers(obs) == 1) obs = obs[[1]]
	if (is.na(res))
		obs = raster::resample(obs, mod[[1]])
		
    mod = layer.apply(mod, function(i) {
                if (nlayers(i) == 1) i = i[[1]]
                raster::resample(i, obs)
            })
    if (nlayers(obs) == 1) obs = obs[[1]]
	
    mask = sum(mod) + obs

    mask = is.na(mask)
	
	if (!is.na(res)) {
		fact =  res/res(mask)
		if (any(fact != 1.0)) {
			if (fact[1] == fact[2]) {
				fact = fact[1]
				if (fact > 1 && as.integer(fact) == fact) mask = raster::aggregate(mask, fact = fact)
				else if (fact < 1 && as.integer(1/fact) == (1/fact)) mask = raster::disaggregate(mask, fact = 1/fact)
				else browser()
			} else {
				browser()
			}
		}
	}
	
	mask = writeRaster(mask, filename = filename)
    return(mask)
}

remask <- function(obs, mod0, mask, res) {
    ## if no mask to apply, return as is
	
    if (is.null(mask) || (is.character(mask) && mask == "NULL"))
        return(list(obs, mod0))

    ## if mask has been applied and stored in cache, return cache
    #present = !sapply(mod0, is.null)
    #mod = mod0[present]
	
    if (is.raster(obs))
        filename_obs = paste(temp_dir, filename.noPath(mask, TRUE), 'obsRemasked', res, '.nc', sep = '-')
    else
        filename_obs = c()
    #filename_mod = paste(temp_dir, sapply(mod, filename.noPath, TRUE), 'modRemasked', res, '.nc', sep = '-')
    filenames    = c(filename_obs)#, filename_mod)
	
    if (files.exist(filenames)) {
        #mod0[present] = lapply(filename_mod, stack)
		if (is.raster(obs)) obs = stack(filename_obs)
        return(list(obs, mod0))
    }

    ## otherwise mask files
    memSafeFile.initialise('temp/')

    resample <- function(i, remask = FALSE) {
        if (is.null(i)) return(i)
        i = raster::resample(i, mask)
        if (remask) i[mask == 1] = NaN
        return(i)
    }

    #mod = lapply(mod, memSafeFunction, resample)
	
    if (is.raster(obs)) {
        obs = memSafeFunction(obs, resample, TRUE)
        #c(obs, mod) := cropBothWays(obs, mod)
        obs = writeRaster(obs, filename_obs, overwrite = TRUE)
    }
	#browser()
    #mod = mapply(writeRaster, mod, filename_mod,
    #             MoreArgs = list(overwrite = TRUE))

    memSafeFile.remove()
    #mod0[present] = mod
    return(list(obs, mod0))
}
