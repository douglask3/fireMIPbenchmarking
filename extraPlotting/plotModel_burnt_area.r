source("cfg.r")
source("cfg/Variable.fire.r")
graphics.off()
filename_dat = 'temp/spatial_fire_variables2.Rd'
openOnly = TRUE
names = 'fire'
comparisons = list(c("GFED4s.Spatial", "GFED4.Spatial","meris.Spatial", "MCD45.Spatial", "MODIS.Spatial"))
res = NULL
e_lims = c(1.0,1.0)

commonLayers = list(109:144, 109:144, 1:36, 61:96,  61:96)

limits = GFED4s.Spatial$plotArgs$limits * 100
cols = GFED4s.Spatial$plotArgs$cols
pnames = c("GFED4s", "GFED4", "Fire CCI41", "MCD45", "Fire CCI51")

doMean <- function(rs, layers = NULL) {
    if (is.null(layers)) mean12 <- function(r) mean(r)
        else {
            mean12 <- function(r) {
                layers = layers[layers < nlayers(r)]
                mean(r[[layers]])
            }
        }
    rout = mean12(rs[[1]])
    rout = addLayer(rout, layer.apply(rs[[2]], mean12))
    return(rout)
}

if (!file.exists(filename_dat)) {
    source('run.r')
    out0 = out
    out = lapply(out0, doMean)
    outc = mapply(doMean, out0, commonLayers)
    save(out0, outc, out, file = filename_dat)
} else load(filename_dat)

layers2list <- function(r) 
    lapply(layer.apply(r, function(r) c(r)), function(i) i[[1]])

plot_dataset <- function(rs, name) {
    fname = paste('figs/Spatial_BurntArea-', name, '.png')
    
    if (is.raster(rs)) rs = layers2list(rs)

    FUN <- function(r, txt) {
        if (nlayers(r) > 1) {
            e = sd.raster(r)
            r = mean(r)
        } else e = NULL
        plotStandardMap(r * 12 * 100, limits = limits, 
                        e = e, e_polygon = FALSE, ePatternRes = 50, 
			ePatternThick = 0.5, limits_error = e_lims,
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

mapply(plot_dataset, out, pnames)
obs = layer.apply(outc, function(i) i[[1]])
mod = layers2list(outc[[1]][[-1]])

out = c(obs, mod)
plot_dataset(out, 'combined')


