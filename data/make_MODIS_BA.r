## run from within data
source("cfg.r")

fname = 'data/MODIS250_q_BA.nc'
fnameOut = 'data/benchmarkData/MODIS250_q_BA_regridded0.5.nc'
sample_fname = 'data/benchmarkData/Fire_GFEDv4_Burnt_fraction_0.5grid9.nc'

dat = brick(fname)
smp = raster(sample_fname)

regridScale <- function(r) {
    r = raster::resample(r, smp)
    r = r / (raster::area(r) * 1000 * 1000)
    return(r)
}

memSafeFile.initialise('temp/')
    dat2 = layer.apply(dat, memSafeFunction, regridScale)
    dat2 = writeRaster.gitInfo(dat2, file = fnameOut,
                               overwrite = TRUE,
                               comment = list("original file" = "MODIS250_q_BA.nc",
                                              "original CDI" = "Climate Data Interface version 1.9.5 (http://mpimet.mpg.de/cdi)",
                                              "regridded by" = "Douglas Kelley",
                                              "contact" = "douglas.i.kelley@gmail.com",
                                              "script file" = "data/make_MODIS_BA.r"))
memSafeFile.remove()
