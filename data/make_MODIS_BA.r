## run from within data
source("cfg.r")

fname = 'data/MODIS250_q_BA.nc'
fnameOut = 'data/benchmarkData/MODIS250_q_BA_regridded0.5.nc'
sample_fname = '../LimFIRE/outputs/fire2000-2014.nc'


dat = brick(fname)
smp = raster(sample_fname)

memSafeFile.initialise('temp/')
    dat2 = layer.apply(dat, function(r)  memSafeFunction(r, raster::resample, smp))
    dat2 = writeRaster(dat2, file = fnameOut)
memSafeFile.remove()