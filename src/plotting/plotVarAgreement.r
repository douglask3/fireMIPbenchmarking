
plotVarAgreement <- function(mod, obs, name, info, scores) {
	index = !sapply(mod, is.null)
	mod = mod[index]
	modNames = names(mod)
	
	if (is.True(info$plotArgs)) {
		obs = PolarConcentrationAndPhase.memStore(obs)
		mod = lapply(mod, PolarConcentrationAndPhase.memStore)
		
		pmod = ithLayerFromList(mod, 1)	
		
		cols    = SeasonPhaseCols
		dcols   = SeasonPhaseDcols
		lims    = SeasonPhaseLimits
		dlims   = SeasonPhaseDlimits
		
		plotSepMods.MPD(pmod, obs[[1]], modNames, paste(name, 'phase', sep = '-'), 
						cols, dcols, lims, dlims,
					    scores[, c("mean.phase", "random.phase")],
						plotSeasonal.phse, SeasonLegend,
						eFun = mnVar.raster)
		
		cmod = ithLayerFromList(mod, 2)	
		
		cols    = SeasonConcCols
		dcols   = SeasonConcDcols
		lims    = SeasonConcLimits
		dlims   = SeasonConcDlimits
		
		name = paste(name, 'conc', sep = '-')
		plotSepMods(cmod, obs[[2]], modNames, name, cols, dcols, lims, dlims,
				    scores[, c("mean.concentration2", "random.concentration")])
		
	} else {
		mod = layer.apply(mod, mean)
		obs = mean(obs)
		
		if (is.True(info$ExtraArgs['mnth2yr'])) {
			mod = mod * 12
			obs = obs * 12
		}
	
		cols  = info$plotArgs$cols
		dcols = info$plotArgs$dcols
		lims  = info$plotArgs$limits
		dlims = info$plotArgs$dlimits
	}
	
	plotSepMods(mod, obs, modNames, name, cols, dcols, lims, dlims, scores)
	
}


plotSepMods <- function(mod, obs, modNames, name, cols, dcols, lims, dlims, scores,
						    plotFun = plotNME.spatial.stepN, legendFun = add_raster_legend2, ...) {
	MetricCols = c('white', 'green', 'yellow', 'orange', 'red', 'black')
	MetricLabs = c('prefect', 'mean', 'RR low', 'RR', 'RR high')
	MetricLims = nullScores_lims(scores)
	
	if (MetricLims[2] > MetricLims[5]) {
		MetricLims = MetricLims[-2]
		MetricLabs = MetricLabs[-2]
		MetricCols = MetricCols[-2]
	}
	
	nmods = nlayers(mod)
	np = nmods*3 + 6
	lmat  = t(matrix(rep(1:np, each = 2), nrow = 6))
	lmat2 = t(matrix(rep(np + c(1, 3, 2, 4), each = 3), nrow = 6))
	lmat  = rbind(lmat, lmat2) 
	
	fname =  paste(figs_dir, name, 'modObsNME', '.pdf', sep = '-')
	pdf(fname, height = 3 * nmods + 1, width = 14)
	layout(lmat, heights = c(0.1, rep(1, nrow(lmat)-4),0.5, 1, 0.7))
	par(mar = rep(0,4), oma = c(0, 1, 0, 0))
	mtextPN <- function(txt) {
		plot.new()
		mtext(txt, side = 3, line = -3)
	}
	
	lapply(c('Simulated', 'Simulated - Observed', 'NME contribution'), mtextPN)
	
	for (i in 1:nlayers(mod))
		plotFun(mod[[i]],obs, 1, modNames[i], cols, dcols, metricCols = MetricCols,
	                           lims, dlims, MetricLims, figOut = FALSE, plotObs = FALSE)
	
	legendFun(cols =  cols, limits =  lims, transpose = FALSE, plot_loc = c(0.2, 0.8, 0.8, 0.9), add = FALSE, 
	          mar = c(-0.5, 0, 0, 0))
	legendFun(cols = dcols, limits = dlims, transpose = FALSE, plot_loc = c(0.2, 0.8, 0.8, 0.9), add = FALSE, mar = rep(0,4))
	add_raster_legend2(cols = MetricCols, limits = MetricLims, labelss = MetricLabs,
	                   transpose = FALSE, plot_loc = c(0.2, 0.8, 0.8, 0.9), add = FALSE)	
	
	plotComMods(mod, obs, name, cols, lims, newFig = FALSE, legendFun = legendFun, ...)
	plotComMods(mod, obs, name, cols, lims, newFig = TRUE, legendFun = legendFun, ...)
	
	dev.off.gitWatermarkStandard()
}


nullScores_lims <- function(x) {
	scores = strsplit(x[, 2], ' +/- ', fixed = TRUE)
	scores = matrix(as.numeric(unlist(scores)), 2)
	scores = rbind(as.numeric(x[,1]), scores)
	return(c(0, scores[1], scores[2] - scores[3], scores[2], scores[2] + scores[3]))
}

mnVar.raster <- function(x, lengthNotConc = TRUE) {
	x = x * 2 * pi /12
	Lx = sum(sin(x), na.rm = TRUE)
	Ly = sum(cos(x), na.rm = TRUE)
	
	nmods = sum(!is.na(x))
	
	C = sqrt(Lx ^ 2 + Ly ^ 2) / nmods
	if (lengthNotConc) C = (1 / C) -1
	return(C)
}

sd.raster.missing <- function(x, pmean = TRUE) {
	llayers=sum(!is.na(x))
    
    lmean=mean(x, na.rm = TRUE)
    ldelt=x-lmean

    ldelt=ldelt*ldelt

    lvarn=sum(ldelt, na.rm = TRUE)/(llayers)

    lvarn=sqrt(lvarn)
    if (pmean) lvarn=lvarn/abs(lmean)
    return(lvarn)
}


plotComMods <- function(mod, obs, name, cols, lims, newFig = TRUE, legendFun = add_raster_legend2, eFun = sd.raster.missing) {	
	
	if (newFig) {
		fname =  paste(figs_dir, name, 'modObsMean', '.pdf', sep = '-')
		pdf(fname, height = 3.67, width = 7.5)
		layout(cbind(1:2, 3:4), heights = c(1,0.5))
	}
		par(mar = rep(0,4))
		
	plot_raster_from_raster(obs, limits = lims, cols = cols, add_legend = FALSE, y_range = c(-60, 90))
	mtext(paste(name, 'observations'), side = 3, line = -1)
	
	
	legendFun(cols = cols, limits = lims, transpose = FALSE, plot_loc = c(0.2, 0.8, 0.8, 0.9), mar = c(-0.5, 0,0,0), add = FALSE)
	
	mmod = mean(mod, na.rm = TRUE)
	mmod[is.na(obs)] = NaN
	
	plot_raster_from_raster(mmod, limits = lims, cols = cols, add_legend = FALSE, y_range = c(-60, 90),
							e = eFun(mod), limits_error = c(0.5, 1),  
							ePatternRes = 30,  ePatternThick = 0.2, e_polygon = FALSE)
	mtext(paste('Model Ensemble'), side = 3, line = -1)
	
	legendFun(cols = cols, limits = lims, transpose = FALSE,
	                   plot_loc = c(0.2, 0.8, 0.55, 0.87), e_lims = c(0.5, 1), mar = c(-0.5, 0,0,0), add = FALSE)
	
	if (newFig) dev.off.gitWatermarkStandard()
}