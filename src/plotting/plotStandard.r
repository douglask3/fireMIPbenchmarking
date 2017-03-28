plotStandardMap <- function(x, txt, limits, cols, ...) {
    plot_raster_from_raster(x, y_range = c(-60, 90), limits = limits, cols = cols,
                            transpose = FALSE, srt = 0,
                            plot_loc = c(0.35,0.83,0.01,0.04),
                            quick = TRUE, ...)
    mtext(txt,side = 1, line = -3.33)
}


plotStandardMetricMap <- function(x, txt, limits  = NULL, qunatiles = NMEmap_qunatiles, cols = NMEmap_cols, ...) {
    if (is.null(limits)) {
		limits = quantile(x, qunatiles)
		labelss = qunatiles * 100
	} else labelss = limits
	
	plotStandardMap(x, txt, limits = limits,
                    cols = cols, labelss = labelss, ...)
}

setupPlotStandardMap <- function(name, x, y, ...)
    setupPlot(name, x, y, mar = c(0,0,0,0), oma = c(2,0,0,0),
              height2width = 0.5, scaleWidth = 6, ...)
