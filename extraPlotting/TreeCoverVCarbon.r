source("cfg.r")

tree = 'data/benchmarkData/treecover2000-2014.nc'

cveg = paste0('data/benchmarkData/',
              c("avitabile_carbon_veg_05.nc",
                "Carvalhais.cVeg_50.360.720.1-1.nc"))
names(cveg) = c("Avitabile", "Carvalhais")

cols = c("#FBFFF7", "#EBF7DE", "#DBEFC6", "#CAE19E", "#AED66B", "#92C426", "#71B521",
         "#519C08", "#306B08")
cols = cols[unlist(mapply(rep, 1:9, 9 + (1:9)^4))]

tree = mean(brick(tree))

cveg = lapply(cveg, raster)
cveg[[2]] = cveg[[2]]/50
plotFun <- function(cveg, txt = '', x = tree) {
    x0 = x
    x = raster::resample(x0, cveg)
    mask = !is.na(x + cveg)
    x = x[mask]; y = cveg[mask]
    
    cols = densCols(x, y, colramp = colorRampPalette(cols))
    plot(y~x, pch = 20, cex = 2, col = cols, xaxt = 'n', yaxt = 'n')
    grid()
    axis(2)
    mtext(side = 3, txt, line = -1.5, adj = 0.1)
}
png("figs/TreeCoverVsCarbon.png", height = 7, width = 7, units = "in", res = 300)
    par(mfcol = c(2, 2), mar = c(0.5, 0.5, 0.5, 3), oma =  c(3, 3, 0, 0))
    mapply(plotFun, cveg, c("Avitabile", "Carvalhais"))
    axis(1)
    mtext('VCF % cover', side = 1, line = 2.5)
    mtext('Veg Carbon' , side = 2, line = 2.5)

    plotFun(cveg[[2]], x = cveg[[1]])
    axis(1)
    lines(c(0, 9E9), c(0, 9E9), lty = 2)
    mtext(side = 1, line = 2.5, "Avitabile")
    mtext(side = 2, line = 2.5, "Carvalhais")
dev.off.gitWatermark()

