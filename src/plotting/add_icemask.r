add_icemask <- function() {
	icemask = raster('data/icemask.nc')
	plot_raster_from_raster(icemask, add = TRUE, cols = c('#FFFFFFFF', 'grey'), y_range = c(-60, 90),
						    limits = c(-0.5, 0.5), add_legend = FALSE, interior = FALSE, coast.lwd = 0.67)#, coast.lwd = NULL)
}