## run from within data
source("cfg.r")

fname_cveg = 'data/benchmarkData/avitabile_carbon_veg_05.nc'
fname_tree = 'data/benchmarkData/treecover2000-2014.nc'
fnameOut = 'data/benchmarkData/avitabile_carbon_veg_05-remove'

cut_points = c(20, 40, 60)

cveg = raster(fname_cveg)
tree = brick(fname_tree)
tree = mean(tree)

cutOutTrees <- function(cut_point) {
    cveg[tree < cut_point] = NaN
    fnameOut = paste0(fnameOut, cut_point, 'pc-tree.nc')
    writeRaster.gitInfo(cveg, file = fnameOut, varname = "burnt_area",
                        overwrite = TRUE,
                        comment = list("original file" = "avitabile_carbon_veg_05.nc",
                                       "regridded by" = "Douglas Kelley",
                                       "contact" = "douglas.i.kelley@gmail.com",
                                       "script file" = "data/make_cVeg_input.r",
                                       "note" = paste("avitabile veg carbon for VCF annual average tree cover for Jul2000 - Jun 2014 of greater than", cut_point, "percent")))

}

lapply(cut_points, cutOutTrees)
