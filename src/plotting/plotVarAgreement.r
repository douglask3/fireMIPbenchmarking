plotVarAgreement <- function(mod, obs, name, info, scores) {

	
	index = !sapply(mod, is.null)
	mod = mod[index]
	modNames = names(mod)
	mod = layer.apply(mod, mean)
	
	obs = mean(obs)
	
	
	if (is.True(info$ExtraArgs['mnth2yr'])) {
		mod = mod * 12
		obs = obs * 12
	}
	
	cols  = info$plotArgs$cols
	lims  = info$plotArgs$limits
	dcols = info$plotArgs$dcols
	dlims = info$plotArgs$dlimits
	NMElims = nullScores_lims(scores)
	
    plotSepMods(mod, obs, modNames, name, cols, dcols, lims, dlims, NMElims)
	plotComMods(mod, obs, name, cols, lims)
	browser()
}

plotSepMods <- function(mod, obs, modNames, name, cols, dcols, lims, dlims, NMElims) {
	NMEcols = c('white', 'green', 'yellow', 'orange', 'red', 'black')

	nmods = nlayers(mod)
	np = nmods*3 + 6
	lmat  = t(matrix(rep(1:np, each = 2), nrow = 6))
	lmat2 = t(matrix(rep(np + c(1, 3, 2, 4), each = 3), nrow = 6))
	lmat  = rbind(lmat, lmat2) 
	
	fname =  paste(figs_dir, name, 'modObsNME', '.pdf', sep = '-')
	pdf(fname, height = 3 * nmods + 0.75, width = 14)
	layout(lmat, heights = c(0.1, rep(1, nrow(lmat)-4),0.3, 1, 0.5))
	par(mar = rep(0,4), oma = c(0, 1, 0, 0))
	mtextPN <- function(txt) {
		plot.new()
		mtext(txt, side = 3, line = -3)
	}
	
	lapply(c('Simulated', 'Simulated - Observed', 'NME contribution'), mtextPN)
	
	for (i in 1:nlayers(mod))
		plotNME.spatial.stepN(mod[[i]],obs, 1, modNames[i], cols, dcols, NMEcols = NMEcols,
	                           lims, dlims, NMElims, figOut = FALSE, plotObs = FALSE)
	
	plot.new()
	add_raster_legend2(cols =  cols, limits =  lims, transpose = FALSE, plot_loc = c(0.2, 0.8, 0.8, 0.9))
	
	plot.new()
	add_raster_legend2(cols = dcols, limits = dlims, transpose = FALSE, plot_loc = c(0.2, 0.8, 0.8, 0.9))
	
	plot.new()
	add_raster_legend2(cols = NMEcols, limits = NMElims, labelss = c('prefect', 'mean', 'RR low', 'RR', 'RR high'),
	                   transpose = FALSE, plot_loc = c(0.2, 0.8, 0.8, 0.9))	
	
	plotComMods(mod, obs, name, cols, lims, newFig = FALSE)
	
	dev.off.gitWatermarkStandard()
}

nullScores_lims <- function(x) {
	scores = strsplit(x[, 2], ' +/- ', fixed = TRUE)
	scores = matrix(as.numeric(unlist(scores)), 2)
	scores = rbind(as.numeric(x[,1]), scores)
	return(c(0, scores[1], scores[2] - scores[3], scores[2], scores[2] + scores[3]))
}

plotComMods <- function(mod, obs, name, cols, lims, newFig = TRUE) {	
	
	if (newFig) {
		fname =  paste(figs_dir, name, 'modObsMean', '.pdf', sep = '-')
		pdf(fname, height = 3.67, width = 7.5)
		layout(cbind(1:2, 3:4), heights = c(1,0.5))
	}
		par(mar = rep(0,4))
		
	plot_raster_from_raster(obs, limits = lims, cols = cols, add_legend = FALSE, y_range = c(-60, 90))
	mtext(paste(name, 'observations'), side = 3, line = -1)
	
	plot.new()
	add_raster_legend2(cols = cols, limits = lims, transpose = FALSE, plot_loc = c(0.2, 0.8, 0.8, 0.9))
	
	plot_raster_from_raster(mean(mod), limits = lims, cols = cols, add_legend = FALSE, y_range = c(-60, 90),
							e = sd.raster(mod), limits_error = c(0.5, 1),  
							ePatternRes = 30,  ePatternThick = 0.2, e_polygon = FALSE)
	mtext(paste('Model Ensemble'), side = 3, line = -1)
	plot.new()
	add_raster_legend2(cols = cols, limits = lims, transpose = FALSE,
	                   plot_loc = c(0.2, 0.8, 0.55, 0.87), e_lims = c(0.5, 1))
	
	if (newFig) dev.off.gitWatermarkStandard()
}