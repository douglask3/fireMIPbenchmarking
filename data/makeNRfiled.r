## run from within data

library(raster)

fname = 'benchmarkData/firesize_niels.txt'
fnameOut = 'benchmarkData/NRfire'
dat = read.csv(fname, sep = '\t')

rasterizeCol <- function(i) {
    dat[,i] = dat[,i] #/ dat[, 'gridsize']
    r = rasterFromXYZ(dat[, c(1,2,i)])
    fnameOut = paste(fnameOut, '-',colnames(dat)[i], '.nc', sep ='')
    writeRaster.gitInfo(r, fnameOut, overwrite = TRUE)
}

rs = lapply(3:4, rasterizeCol)
