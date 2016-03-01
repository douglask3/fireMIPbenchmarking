mapComparison <- function(obs, mod, name, ...) {

    ## Set up and arrange data
    index = !sapply(mod, is.null)

    cropOutAntarctic <- function(dat) crop(dat, extent(c(-180, 180, -60, 90)))

    obs        = cropOutAntarctic(obs)
    mod[index] = lapply(mod[index], cropOutAntarctic)

    findAndFixNonNAmod <- function(dat) {
        if (any(is.na(values(dat)))) return(dat)
        dat[dat==0] = NaN
        return(dat)
    }

    mod[index] = lapply(mod[index], findAndFixNonNAmod)

    obs        = is.na(obs)
    mod        = lapply(mod, is.na)


    ## Set up plot
    plotDims   = standardPlotDims(length(mod) + 1)


    makePlot <- function(mod, fname) {
        pdf(fname, height = plotDims[2]*3, width = plotDims[1]*5)

        ## Plot
            par(mfrow = standardPlotDims(length(mod) + 1),
                mar = rep(0,4), oma = c(0, 0, 3, 0))

            plotMaskMap <- function(dat, col, name) {
                if (length(dat) == 0) plot.new() else {
                    plot_raster_from_raster(dat, limits = 0.5, col = c(col, 'white'),
                                            quick = TRUE, add_legend = FALSE)
                }
                mtext(name, line = -2)
            }

            plotMaskMap(obs, 'grey', 'GFED observations')

            mapply(plotMaskMap, mod, Model.plotting[, 2], Model.plotting[, 1])
        dev.off.gitWatermark(x = 0.85, y = 0.05, srt = 0, cex = 1.5)
    }

    makePlot(mod, 'figs/maskMaps.pdf')

    mod[index]  = lapply(mod[index], raster::resample, obs)

    modi = mod
    modi[index] = lapply(modi[index], function(i) i > 0.5 | obs == 0)
    makePlot(modi, 'figs/maskMaps2.pdf')

    modi = mod
    modi[index] = lapply(modi[index], function(i) (i < 0.5) | obs != 0)
    makePlot(modi, 'figs/maskMaps3.pdf')

    
    browser()
}
