mapComparison <- function(obs, mod, name, ...) {

    ## Set up and arrange data
    index = !sapply(mod, is.null)
    fname = 'maskComparison'

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


    makePlot <- function(mod, fnamei) {
        return()
        fname = paste(figs_dir, fname, fnamei, '.pdf', sep ='-')
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

    makePlot(mod, 'ModelMasks')
    mod[index]  = lapply(mod[index], raster::resample, obs)

    compare2mask <- function(mask, fnamei) {
        fnames = paste(fname, fnamei, c('outside', 'inside'), sep = '-')

        modi = mod
        modi[index] = lapply(modi[index], function(i) i > 0.5 | mask == 0)
        makePlot(modi, fnames[1])

        modi = mod
        modi[index] = lapply(modi[index], function(i) (i < 0.5) | mask != 0)
        makePlot(modi, fnames[2])
    }

    compare2mask(obs, 'vsObs')

    dat    = lapply(c(obs, mod), '>', 0.5)
    names(dat) = c('Observations', Model.plotting[, 1])

    common = layer.apply(dat, function(i) i)
    common = sum(common) > 0

    compare2mask(common, 'vsCommon')

    CommonArea <- function(i, j, areaWeighted = FALSE) {
        i[is.na(i)] = 1
        j[is.na(j)] = 1
        i0 = i
        i = i == j

        if (areaWeighted) {
            a = area(i)
            nEqual = sum.raster(a * i)
            nTotal = sum.raster(a)
        } else {
            nEqual = sum.raster(i)
            nTotal = length(i[])
        }
        return(round(100 * nEqual/nTotal, 2))
    }
    CommonAreas <- function(fname,...) {
        tab = sapply(dat, function(...) sapply(dat, CommonArea, ...), ...)
        for (i in 2:nrow(tab)) for (j in 1:(i-1)) tab[i,j] = 100 - tab[i,j]

        fname = paste(outputs_dir, 'CommonAreas',fname, '.csv', sep = '-')
        write.csv(tab, fname)
        cat(gitFullInfo(), file = fname, append = TRUE)
    }
    CommonAreas('pc_of_cells')
    CommonAreas('pc_of_area', areaWeighted = TRUE)
}
