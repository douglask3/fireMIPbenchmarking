graphics.off()

map_cols = c('#ffffcc','#ffeda0','#fed976','#feb24c','#fd8d3c','#fc4e2a',
             '#e31a1c','#bd0026','#800026')
map_limits = c(0, 1, 2, 5, 10, 20, 50)

openOnly = TRUE
names = 'fire'
comparisons = list(c("GFED4s.Spatial"))
res = NULL
source("run.r")

qs = c(0, 0.2, 0.3, 0.35, 0.4, 0.43, 0.45, 0.49, 0.5, 0.51, 0.55, 0.57, 0.6, 0.65, 0.7, 0.9, 1) 
qs = c(0, 0.3, 0.4, 0.45, 0.5,  0.55, 0.6, 0.7,  1)
ba_sample = seq(0, 1.5, 0.01)

RUN <- function() {
    extent = extent(extentc)
    
    outCropMask <- function(r, mask = NULL, layers = 1:156, allLayers = FALSE) {
        layers = layers[layers < nlayers(r)]
        
        r = raster::crop(r[[layers]], extent)
        
        if (is.null(mask)) return(r)
        if (any(res(r) != res(mask))) r = raster::resample(r, mask)
        v = r[mask]
        
        if (allLayers) q = hist(apply(v, 1, max), ba_sample, plot = FALSE)$density
        else q = apply(v, 2, quantile, qs, na.rm = TRUE)
        return(q)
    }
    plotQs <- function(q, col = "black", scale = 100, ...) {
        layers = 1:ncol(q)
        addPolygon <- function(i, border = NA) {
            qi = q[c(i, nrow(q) -i + 1),]*scale
            polygon(c(layers, rev(layers)),  c(qi[1,], rev(qi[2,])),
                    border = border, col = make.transparent(col, 0.98), ...)
        }
        lapply(1:length(qs), addPolygon)
        addPolygon(ceiling(length(qs)/2), border = col)    
    }
    
    aa = 12*mean(outCropMask(out[[1]][[1]], layers = 1:156))

    resampleMask <- function(mask) { 
        mask = raster::resample(mask, out[[1]][[1]])
        mask = raster::crop(mask, extent)
        mask = mask > 0.5
    }

    if (is.numeric(mask)) mask = aa > mask
    if (is.list(mask)) mask = (aa > mask[[1]]) & resampleMask(mask[[2]])
    
    mask = resampleMask(mask)
    png(paste0("figs/", fname, ".png"), width = 3*2/3, height = 7*2/3, res = 300, units = 'in')
        par(mar = rep(0,4))        

        plot(extentc[1:2], extentc[3:4], type = 'n', axes = FALSE, xlab = '', ylab = '')
        aa = disaggregate(aa, fact = 5, method = 'bilinear')
        plotStandardMap(aa*100, cols = map_cols,
                        limits = map_limits, txt = '', add = TRUE, add_legend = FALSE)
        add_raster_legend2(dat = aa, cols = map_cols, limits = map_limits, 
                          transpose = F, srt = 0,
                          plot_loc = c(0.1, 0.4, 0.09, 0.127), oneSideLabels=FALSE,
                          extend_max = TRUE, units = '%')
    
    dev.off()

    obs = outCropMask(out[[1]][[1]], mask = mask)
    
    if (!is.null(conFire)) conFire = lapply(conFire, outCropMask, mask = mask)
    sim = lapply(out[[1]][[2]], outCropMask, mask = mask)
       
    obsh = outCropMask(out[[1]][[1]], mask = mask, layers = fSeason, allLayers = TRUE)
    simh = lapply(out[[1]][[2]], outCropMask, mask = mask, layers = fSeason, allLayers = TRUE)

    plotFun <- function(psim = FALSE) {
        TSfun <- function(...) {
            if (!is.null(conFire)) obs_col = 'red' else obs_col = 'black'
            
            plotQs(obs, lwd = 3, col = obs_col)
            if (psim) {
                if (!is.null(conFire)) {
                    #browser()
                    lapply(conFire, plotQs, col = 'orange', lwd = 3, scale = 100)    
                    mapply(plotQs, sim, lty = 2, lwd = 1, col = 'blue')               
                } else {
                    mapply(plotQs, c(sim, rev(sim)),
                           col = c(Model.plotting[,2], rev(Model.plotting[,2])))
                }
            }
            plotQs(obs, lwd = 3, col = obs_col)
        }
        addCandle <- function(x, v, col) {
            v = sqrt(0.5 * v /max(v))
            polygon(x +  0.5 * c(v, rev(-v))/max(v), c(ba_sample, rev(ba_sample)), col = col)
        }        
        fname = paste0("figs/", fname, "-Season-", psim, ".png")
        png(fname, height = 4, width = 12, units = 'in', res = 600)
            #dev.new()
            layout(t(c(1,2)), width = c(0.7, 0.3))
            par(mar = c(3, 0.5, 0.5, 0.5), oma = c(0, 2.5, 0, 0))
            plot(c(0, 156), c(0, ymax), type = 'n', xaxt = 'n', 
                 xlab = '', ylab = '', xaxs = 'i', yaxs = 'i')
            mtext(side =2, 'Burnt area (%)', line = 2)
            axis(1, at = seq(1, 156, by = 12), 2001:2013)    
            
            lapply(1:4, TSfun)    
    
            plot(c(0, length(simh)+1), c(0, 100), type = 'n', axes = FALSE,
                 xlab = '', ylab = '', xaxs = 'i', yaxs = 'i')

            ba_sample = (ba_sample[-1] - diff(ba_sample))*100
    
            addCandle(0.5, obsh, "black")
            if (psim) mapply(addCandle, 0.5 + 1:length(simh), simh, Model.plotting[,2])

            labs = c("GFED4s", rownames(Model.plotting))
            if (!psim) labs[-1] = ''
            text(0.15 + 0:length(simh), y = 100, labs, xpd = NA, srt = 90, adj = 1)
        dev.off()
    }
    plotFun(FALSE)
    plotFun(TRUE)
}


conFire = FALSE
extentc = c(-25, 60, 0, 25)
fname = "SahelMap2"
fSeason = seq(1, 156, by = 12)
mask = 0.5
ymax = 50
#RUN()

fname = "Sahel3"
qs = c(0.25, 0.5, 0.75)
#RUN()

extentc = c(-110, -30, -25, 0)
fname = "SouthernAmericas"
fSeason = seq(8, 156, by = 12)
mask =  raster('../amazon_fires/outputs/amazon_region/treeCoverTrendRegions.nc') == 6
ymax = 20
#RUN()

fname = "SouthernAmericas-ConFire"
qs = c(0.5, 0.5)
ymax = 5
conFire_file = '../amazon_fires/outputs/sampled_posterior_ConFire_solutions-burnt_area_MCD-Tnorm/constant_post_2018_full_2002-attempt2-NewMoist-DeepSoil/model_summary.nc'

conFire = lapply(c(1,seq(5, 95, 5),99), function(qt) layer.apply(1:156, function(i) brick(conFire_file, level = i)[[qt]]))
RUN()
browser()

conFire_file = NULL
qs = c(0.25, 0.5, 0.75)
extentc = c(140, 155, -43, -8)
fSeason = 1:156
fname = "SE_AUS"
mask = raster('../australia_fires/outputs/Australia_region/SE_TempBLRegion.nc') 
mask = mask > 20
mask = list(0.04, mask)
#RUN()


qs = c(0.5)


