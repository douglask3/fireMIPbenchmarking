## run from within data

library(raster)

fname = 'benchmarkData/firesize_niels.txt'
fnameOut = 'benchmarkData/NRfire'
dat = read.csv(fname, sep = '\t')

rasterizeCol <- function(i, areaTest) {
    dat[,i] = dat[,i] #/ dat[, 'gridsize']
    r = rasterFromXYZ(dat[, c(1,2,i)])
	if (areaTest) r = r / raster::area(r)
	
    fnameOut = paste(fnameOut, '-',colnames(dat)[i], '.nc', sep ='')
    writeRaster.gitInfo(r, fnameOut, overwrite = TRUE)
}

rs = mapply(rasterizeCol, 3:4, c(F, T))
