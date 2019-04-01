sourceAllLibs('../rasterextrafuns/rasterPlotFunctions/R/')
filename_dat = 'temp/spatial_fire_variables.Rd'
openOnly = TRUE
names = 'fire'
comparisons = list(c("GFED4s.Spatial", "GFED4.Spatial","meris.Spatial", "MCD45.Spatial", "MODIS.Spatial"))
res = NULL

limits = GFED4s.Spatial$plotArgs$limits * 100
cols = GFED4s.Spatial$plotArgs$cols
names = c("GFED4s", "GFED4", "Fire CCI", "MCD45", "MODIS")

doMean <- function(rs) {
    mean12 <- function(r) mean(r[[1:12]])
    rout = mean(rs[[1]][[2]])
    rout = addLayer(rout, layer.apply(rs[[1]][[3]], mean))
    return(rout)
}

if (!file.exists(filename_dat)) {
    source('run.r')
    out = lapply(out, doMean)
    save(out, file = filename_dat)
} else load(filename_dat)

layers2list <- function(r) 
    lapply(layer.apply(r, function(r) c(r)), function(i) i[[1]])

plot_dataset <- function(rs, name) {
    fname = paste('figs/Spatial_BurntArea-', name, '.png')
    
    rs = layers2list(rs)

    FUN <- function(r, txt) {
        plotStandardMap(r * 12 * 100, limits = limits,
                       cols = cols, txt = '', add_legend = FALSE)
        mtext(txt, adj = 0.1)
    }
    png(fname, height = 7.5, width = 6, units = 'in', res = 300)
        lmat = rbind(t(matrix(1:10, nrow = 2)), 11)
        layout(lmat, heights = c(rep(1, 5), 0.3))
        par(mar = c(0, 0, 0.67, 0), oma = c(1, 0, 1, 0))
        txt = c(name, Model.plotting[,1])
        txt = paste0(letters[1:length(txt)], ') ',  txt)
        mapply(FUN, rs, txt)
        add_raster_legend2(dat = rs[[1]], limits = limits, cols = cols, add = FALSE, 
                           plot_loc = c(0.1, 0.9, 0.5, 0.8), transpose = FALSE, 
                           extend_max = TRUE, units = '%', srt = 0, ylabposScling=0.3)
    dev.off()
}

mapply(plot_dataset, out, names)
