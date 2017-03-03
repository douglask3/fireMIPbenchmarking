plotVarAgreement <- function(mod, obs, name, info) {
	mod = layer.apply(mod, mean) * 12
	obs = mean(obs) * 12
	
	cols =  info$plotArgs$cols
	lims =  info$plotArgs$limits
	
	fname =  paste(figs_dir, name, 'modObsMean', '.pdf', sep = '-')
	pdf(fname, height = 4, width = 7.5)
		layout(cbind(1:2, 3:4), heights = c(1,0.5))
		par(mar = rep(0,4))
		plot_raster_from_raster(obs, limits = lims, cols = cols, add_legend = FALSE, y_range = c(-60, 90))
		plot.new()
		add_raster_legend2(cols = cols, limits = lims, transpose = FALSE, plot_loc = c(0.2, 0.8, 0.8, 0.9))
		
		plot_raster_from_raster(mean(mod), limits = lims, cols = cols, add_legend = FALSE, y_range = c(-60, 90),
								e = sd.raster(mod), limits_error = c(0.5, 1),  
								ePatternRes = 30,  ePatternThick = 0.2, e_polygon = FALSE)
		plot.new()
		add_raster_legend2(cols = cols, limits = lims, transpose = FALSE, plot_loc = c(0.3, 0.7, 0.6, 1.0), e_lims = c(0.5, 1))
	
	dev.off.gitWatermarkStandard()

}