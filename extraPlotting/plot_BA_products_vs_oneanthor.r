source("cfg.r")
reds9 = c('#FFFBF7', '#F7EBDE', '#EFDBC6', '#E1CA9E', '#D6AE6B', '#C69242', '#B57121', '#9C5108', '#6B3008')
files = c(GFED4s = "D:/Laurens22122018/Doug/Documents/work/LimFIRE/outputs/fire2000-2014.nc",
          MODIS  = "data/benchmarkData/MODIS250_q_BA_regridded0.5.nc",
          MODIS  = "data/benchmarkData/MODIS250_q_BA_regridded0.5.nc",
          MODIS  = "data/benchmarkData/MODIS250_q_BA_regridded0.5.nc",
          MODIS  = "data/benchmarkData/MODIS250_q_BA_regridded0.5.nc")
if (F) {          
dat = mapply(function(i, offset) brick(i)[[offset + (1:12)]], files, c(6, 0, 0, 0))
dat[[2]] = dat[[2]]/max.raster(dat[[2]])
dat[[3]] = dat[[2]]
dat[[4]] = dat[[2]]
dat[[5]] = dat[[2]]
dat[[1]] = dat[[1]]

mask = layer.apply(dat, function(i) all(i == 0))
mask = all(mask == 1)

mask = any(addLayer(mask, layer.apply(dat, function(i) any(is.na(i)))))

vdat = lapply(dat, function(i) i[mask == 0])
}

plotScatter <- function(j, i, xaxis, yaxis, name) {
    test = (i + j) > 0
    
    i = log10(i[test]); j = log10(j[test])
    cols = reds9[unlist(mapply(rep, 1:9, 9 + (1:9)^1))]
    cols = densCols(i,j, colramp = colorRampPalette(cols))
    
    plot(c(-5, 0), c(-5, 0), type = 'n', xaxt = 'n', yaxt = 'n', xlab = '', ylab = '')
    
    
    at = seq(-6, 0, 1)
    lat = lapply(at, rep, 2)
    grid_col = make.transparent("black", 0.67)
    
    lapply(lat, lines, y = c(-9E9, 9E9), lty = 2, col = grid_col)
    lapply(lat, lines, x = c(-9E9, 9E9), lty = 2, col = grid_col)
    
    points(j~i, pch = 20, cex = 2, col = cols)
    
    
    lapply(lat, lines, y = c(-9E9, 9E9), lty = 2, col = grid_col)
    lapply(lat, lines, x = c(-9E9, 9E9), lty = 2, col = grid_col)
    
    print(xaxis)
    if (xaxis) axis(1, at = at, labels = 10^(at)*100)
    if (yaxis) axis(2, at = at, labels = 10^(at)*100)
    lines(c(-9E9, 9E9), c(-9E9, 9E9))
    
    legend('topleft', legend  = name, bg = 'white', box.col = 'transparent', inset = 0.02)
}
graphics.off()
par(mfrow = c(2,2), mar = rep(1, 4), oma = c(4, 4, 0, 0))

labs = paste0(letters[1:4], ') ',  names(files)[-1])

mapply(plotScatter, vdat[-1], c(F, F, T, T), c(T, F, T, F),labs, MoreArgs = list(i = vdat[[1]]))
mtext.units(outer = TRUE, side = 1, line = 1.33, paste(names(files)[1], 'Burnt Area (% ~month-1~)'), font = 2)
mtext.units(outer = TRUE, side = 2, line = 1, 'Alternative dataset Burnt Area (% ~month-1~)', font = 2)