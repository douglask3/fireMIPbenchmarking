plotStandardMap <- function(x, txt, limits, cols, ...) {
    plot_raster_from_raster(x, y_range = c(-60, 90), limits = limits, cols = cols,
                            transpose = FALSE, srt = 0,
                            plot_loc = c(0.35,0.83,0.01,0.04),
                            quick = TRUE, interior = FALSE, ...)

    addCoastlineAndIce2map()
    mtext(txt,side = 1, line = -3.33)
}

addCoastlineAndIce2map <- function() {
    add_icemask()
    
    mask = raster('data/seamask.nc')
    plot_raster_from_raster(mask, add = TRUE, col = c("white", "transparent"), limits = c(0.5), quick = TRUE, interior = FALSE, coast.lwd = NULL, add_legend = FALSE)
    #
    #contour(mask, add = TRUE, drawlabels = FALSE, lwd = 0.5)  

    ployBox <- function(x, y)
        polygon(c(x[1], x[2], x[2], x[1]), c(y[1], y[1], y[2], y[2]), col = "white", border = "white")
        
    ployBox(c(-180, -90), c(-60, 0))
    #ployBox(c(-180, -120), c(-60, 25))
    ployBox(c(-50, -19), c(10, 25))
    ployBox(c(-50, -13.5), c(27.5, 34))
    #ployBox(c(115, 125), c(-8, -7))
    #ployBox(c(104, 111), c(2.5, 8))
    #ployBox(c(122, 128), c(2.5, 5)) 
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
