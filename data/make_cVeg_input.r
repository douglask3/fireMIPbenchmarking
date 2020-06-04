## run from within data
source("cfg.r")

fname_cvegs = paste0('data/benchmarkData/', c('avitabile_carbon_veg_05.nc', "Carvalhais.cVeg_50.360.720.1-1.nc"))
fname_tree = 'data/benchmarkData/treecover2000-2014.nc'

cut_points = c(20, 40, 60)

tree = brick(fname_tree)
tree = mean(tree)

cutOutTrees <- function(cut_point, fname_cveg) {
    cveg = raster(fname_cveg)
    cveg[tree < cut_point] = NaN
    
    fnameOut = strsplit( fname_cveg, '.nc', fixed = TRUE)[[1]]
    fnameOut = paste0(fnameOut, '-remove', cut_point, 'pc-tree.nc')

    writeRaster.gitInfo(cveg, file = fnameOut, varname = "cVeg",
                        overwrite = TRUE,
                        comment = list("original file" = fname_cveg,
                                       "regridded by" = "Douglas Kelley",
                                       "contact" = "douglas.i.kelley@gmail.com",
                                       "script file" = "data/make_cVeg_input.r",
                                       "note" = paste("avitabile veg carbon for VCF annual average tree cover for Jul2000 - Jun 2014 of greater than", cut_point, "percent")))

}

lapply(fname_cvegs, function(file) lapply(cut_points, cutOutTrees, file))
