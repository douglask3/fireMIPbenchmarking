loadMask <- function(obs, mod, varnN) {
    mod = mod[!sapply(mod, is.null)]

    filename = paste(c(temp_dir, varnN, names(mod), '.nc'), collapse = '-')
    if(file.exists(filename)) return(raster(filename))

    mod = lapply(mod, function(i) sum(i))
    obs = sum(obs)
    mod = layer.apply(mod, function(i) raster::resample(i, obs))

    mask = sum(mod) + obs
    mask = is.na(mask)

    mask = writeRaster(mask, filename = filename)
    return(mask)
}

remask <- function(obs, mod0, mask, varnN) {
    ## if no mask to apply, return as is
    if (is.null(mask) || (is.character(mask) && mask == "NULL"))
        return(list(obs, mod))

    ## if mask has been applied and stored in cache, return cache
    present = !sapply(mod0, is.null)
    mod = mod0[present]

    filename_obs = paste(temp_dir, filename.noPath(mask, TRUE)       , 'obsRemasked.nc', sep = '-')
    filename_mod = paste(temp_dir, sapply(mod, filename.noPath, TRUE), 'modRemasked.nc', sep = '-')
    filenames    = c(filename_obs, filename_mod)

    if (files.exist(filenames)) {
        obs = stack(filename_obs)
        mod0[present] = lapply(filename_mod, stack)
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

    obs = memSafeFunction(obs, resample, TRUE)
    mod = lapply(mod, memSafeFunction, resample)

    c(obs, mod) := cropBothWays(obs, mod)

    obs = writeRaster(obs, filename_obs, overwrite = TRUE)
    mod = mapply(writeRaster, mod, filename_mod,
                 MoreArgs = list(overwrite = TRUE))

    memSafeFile.remove()
    mod0[present] = mod
    return(list(obs, mod0))
}
