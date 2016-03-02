plotStandardMap <- function(x, txt, limits, cols, ...) {
    plot_raster_from_raster(x, limits = limits, cols = cols,
                            transpose = FALSE, srt = 0,
                            plot_loc = c(0.35,0.83,0.01,0.04),
                            quick = TRUE, ...)
    mtext(txt,side = 1, line = -3.33)
}


plotStandardMetricMap <- function(x, txt, limits, cols, ...) {
    plotStandardMap(x, txt, limits = quantile(x, seq(0.2,0.8,0.2)),
                    cols = c('white', 'black'), labelss = seq(0,1,0.2)*100)
}

setupPlotStandardMap <- function(name, x, y, ...)
    setupPlot(name, x, y, mar = c(0,0,0,0), oma = c(2,0,0,0),
              height2width = 0.5, scaleWidth = 6, ...)
