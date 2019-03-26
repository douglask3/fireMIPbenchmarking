## run from within data
source("cfg.r")

fname = 'data/MODIS250_q_BA.nc'
fnameOut = 'data/benchmarkData/MODIS250_q_BA_regridded0.5.nc'
sample_fname = '../LimFIRE/outputs/fire2000-2014.nc'


dat = brick(fname)
smp = raster(sample_fname)

regridScale <- function(r) {
    r = raster::resample(r, smp)
    r = r / (raster::area(r) * 1000 * 1000)
    return(r)
}

memSafeFile.initialise('temp/')
    dat2 = layer.apply(dat, memSafeFunction, regridScale)
    dat2 = writeRaster(dat2, file = fnameOut)
memSafeFile.remove()