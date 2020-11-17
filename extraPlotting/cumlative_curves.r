
graphics.off()
source("cfg.r")
load("data/gfed4s_fcc_gfed4_fordoug.RData")
load("data/mcd45_fordoug.RData")
load("data/meris_fordoug.RData")

BAs = list(GFED4 = gfed_ba, GFED4s = gfed4s_ba,
           "GERADO" = gerado_ba, "MCD45" = mcd45_ba, "MERIS" = meris_ba, "FIRE_CCI5.1" = fcci_modis)
cols =  make_col_vector(c('#1b9e77','#d95f02','#7570b3'), ncols = 5)#'c("blue", "red")
#cols = lighten(cols, c(-0.3, 0.3, -0.3, 0.3, -0.45))
cols = c("black", cols)

varss = list("Burnt area (%)" = BAs,
             "Tree cover (%)" = c(gfed4s_tree, gfed4s_tree, mcd45_tree, mcd45_tree, meris_tree, gfed4s_tree),
             "Non-tree cover(%)" = c(gfed4s_nontree, gfed4s_nontree, mcd45_nontree, mcd45_nontree, meris_nontree, gfed4s_nontree))
             varss[["Total veg cover  (%)"]] =  mapply('+', varss[[1]], varss[[2]])#c(gfed4s_tree + gfed4s_nontree, gfed4s_tree + gfed4s_nontree))


bins = list(seq(0, 1, 0.01), seq(0, 81, 1), seq(0, 100, 1), seq(0, 100, 1))
scales = rep(1, 4)
logs = rep('', 4)
logit_squish <- function(x) {
    x = (x*999 + 0.5) /1000
    x = log(x/(1-x))
}
cummalitivePlot <- function(vars, name, bin, scale, yaxis = FALSE, yaxis2 = FALSE,
                            cummm = TRUE, poly = FALSE, log = '', logit = FALSE, diffFrom1st = TRUE, ...) {
    if (logit) yrange = c(-7.7, 7.7) else yrange = c(0, 1)
    vars = lapply(vars, function(i) i * scale)
   
    plot(range(bins), yrange, type = 'n', xaxt ='n', yaxt = 'n', log = log,
         xlab = '', ylab = '', xlim = c(bin[1], tail(bin, 1)), ...)
    axis(1)
    mtext(side = 1, line = 2.3, name)
    if (logit) {
        labs = c(0, 1, 10, 50, 90, 99, 100)
        at = logit_squish(labs/100) 
    } else {
        labs = seq(0, 100, 20)
        at = labs/100
    }
    if (!yaxis) labs[] = ' '
    axis(2, at = at, labels = labs)
        
    
    if (diffFrom1st) {
        labs = c(-10, -5, 0, 5, 10)
        at = 0.5+(labs/100)*4
        
        lines(c(-9E9, 9E9), rep(at[3], 2), lty = 2)
        if (!yaxis2) labs[] = ' '
        axis(4, at = at, labels = labs)
    }
    
    
    cummalitiveLine <- function(var, BA, col, ...) {
        cummalitivePoint <- function(b1, b2) {
            
            if (b1 > b2) c(b1, b2) := c(b2, b1)
            test = var > b1 & var < b2
            sum(BA[test] * raster::area(BA)[test], na.rm = TRUE)
        }
        if (cummm) bin1 =  rep(bin[1], length(bin)-1)
        else bin1 = bin[-1]
        y = mapply(cummalitivePoint, bin1, head(bin, -1))
        y = y/max(y)
        x = bin[-1]
        if (logit) y = logit_squish(y)
        
        if (diffFrom1st) {  
            if (col == cols[1]) curve1 <<- y
                else y = 0.5 + (y - curve1) * 4
        }
        
        lines(x, y, col = col, xpd = TRUE, lwd = 2, ...)
        if (cummm && poly)
            polygon(c(x, rev(x)), c(y, rep(-10, length(y))), col = make.transparent(col, 0.95), border = NA)
    }    
    
    if (poly) index = 1:3 else index = 1
    for (i in index) {
        mapply(cummalitiveLine, vars, BAs, cols)
        #mapply(cummalitiveLine, rev(vars), rev(BAs), rev(cols), lty = 2)
    }
}

doThePlot <- function(fname, ...) {
    png(fname, height = 7, width = 9, units = 'in', res = 300)
        layout(rbind(1:2, 3:4, 5), heights = c(1, 1, 0.3))
        par(mar = c(3.5, 0.5, 0, 0.5), oma = c(0, 3.4, 1, 3.4))
        mapply(cummalitivePlot, varss, names(varss), bins, scales, c(T, F, T, F), c(F, T, F, T), log = logs, MoreArgs = list(...))
        mtext(side = 2, line = 2.3, "Cummulative burnt area (%)", outer = TRUE)
        mtext(side = 4, line = 2.3, "Difference from GFED4 (%)", outer = TRUE)
        plot.new()
        legend('top', col = cols, lwd = 2, legend = names(BAs), horiz = TRUE)
    dev.off()
}
#doThePlot("figs/bot_cummlative_BA_Diff.png", cummm = FALSE)    
#doThePlot("figs/cummlative_BA_Diff.png")
#doThePlot("figs/cummlative_BA.png", diffFrom1st = FALSE)

varss = list("Burnt area (%)" = BAs,
             "Cropland cover (%)" = c(gfed4s_crop, gfed4s_crop, mcd45_crop, mcd45_crop, meris_crop, gfed4s_crop),
             "Pasture cover(%)" = c(gfed4s_pasture, gfed4s_pasture, mcd45_pasture, mcd45_pasture, meris_pasture, gfed4s_pasture),
             "Population Density (pop/km2)" =  c(gfed4s_popd, gfed4s_popd, mcd45_popd, mcd45_popd, meris_popd, gfed4s_popd))

scales[2:3] = 100
bins[[4]] = 10^(seq(-5, 3, 0.01))
logs[4] = 'x'
#doThePlot("figs/cummlative_BA_Human_Diff.png")

varss = list("Burnt area (%)" = BAs,
             "Cropland cover (%)" = c(gfed4s_crop, gfed4s_crop, mcd45_crop, mcd45_crop, meris_crop, gfed4s_crop),
             "Pasture cover(%)" = c(gfed4s_pasture, gfed4s_pasture, mcd45_pasture, mcd45_pasture, meris_pasture, gfed4s_pasture),
             "Population Density (pop/km2)" =  c(gfed4s_popd, gfed4s_popd, mcd45_popd, mcd45_popd, meris_popd, gfed4s_popd))

scales[2:3] = 100
bins[[4]] = 10^(seq(-5, 3, 0.01))
logs[4] = 'x'

