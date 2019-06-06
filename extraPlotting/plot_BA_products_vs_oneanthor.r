source("cfg.r")
reds9 = c('#FFFBF7', '#F7EBDE', '#EFDBC6', '#E1CA9E', '#D6AE6B', '#C69242', '#B57121', '#9C5108', '#6B3008')
#files = c(GFED4  = "Fire_GFEDv4_Burnt_fraction_0.5grid9.nc",
#          GFED4s = "GFED4s_v2.nc",
#          MCD45  = "MCD45.nc",
#          meris  = "meris_v2.nc",
#          MODIS  = "MODIS250_q_BA_regridded0.5.nc")
MODIS  = "data/benchmarkData/MODIS250_q_BA_regridded0.5.nc"
labs = paste0(letters[1:4], ') ',  names(files)[-1])
#files = paste0('data/benchmarkData/', files)

dat = list(GFED = gfed_ba, GERADO = gerado_ba, GFED4s = gfed4s_ba, MCD45 = mcd45_ba, MERIS = meris_ba, FIRE_CCI5.1 = 12*mean(brick(MODIS)[[1:108]]))

labs = paste0(letters[1:5], ') ',  names(dat)[-1])
#dat = mapply(function(i, offset) brick(i)[[offset + (1:12)]], files, c(54+60, 36+60, 60, 0, 60))


mask = layer.apply(dat, function(i) all(i == 0))
mask = all(mask == 1)

mask = any(addLayer(mask, layer.apply(dat, function(i) any(is.na(i)))))

vdat = lapply(dat, function(i) i[mask == 0])


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
    
    legend('topleft', legend  = name, bg = 'white', box.col = 'transparent', inset = 0.01,
           cex = 1.2)
}
graphics.off()
png('figs/BA_product_scatters.png', width = 7, height = 7*1.5, units = 'in', res = 300)
par(mfrow = c(3,2), mar = rep(1, 4), oma = c(4, 4, 0, 0))



mapply(plotScatter, vdat[-1], c(F, F, F, T, T), c(T, F, T, F, T),labs, MoreArgs = list(i = vdat[[1]]))
mtext.units(outer = TRUE, side = 1, line = 1.33, paste('GFED4', 'Burnt Area (% ~month-1~)'), font = 2)
mtext.units(outer = TRUE, side = 2, line = 1, 'Alternative dataset Burnt Area (% ~month-1~)', font = 2)
dev.off()
