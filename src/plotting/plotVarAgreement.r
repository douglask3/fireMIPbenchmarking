plotVarAgreement <- function(mod, obs, name, info, scores, ...) {
	index = !sapply(mod, is.null)
	mod = mod[index]
	modNames = names(mod)
	
	if (is.True(info$obsVarname  == "csv")) return()#FUN = plotVarAgreement.site
	else if (is.True(info$plotArgs)) FUN = plotVarAgreement.seasonal
	else if (all(names(info$plotArgs) == 'x')) FUN = plotVarAgreement.IA
	else FUN = plotVarAgreement.spatial
	
	FUN(mod, obs, name, modNames, info, scores, ...)
}

plotVarAgreement.site <- function(mod, obs, name, modNames, info, scores, comp, ...) {
	cols  = info$plotArgs$cols
	lims  = info$plotArgs$limits
	nmods = length(mod)
	
	x     = obs[[1]][,2]
	y     = obs[[1]][,1]
	z     = obs[[1]][,3]
	
	index= c(1, 2, 2, 2, 3, 3, 3)
	lmat = index
	for (i in 1:(nmods)) lmat = rbind(lmat, index + (i * 3))
	lmat = lmat -1
	
	spoint = max(lmat) + 1
	lmat = rbind(lmat, spoint)
	lmat = rbind(lmat, spoint + 1)
	
	nxtLine = c(spoint, rep((spoint + 1):(spoint + 3), each = 2))
	lmat = rbind(lmat, nxtLine + 2, nxtLine + 6,  nxtLine + 10)
	
	pdf('yay.pdf',  height = 3 * (nmods + 1.5), width = 14)
	layout(lmat, heights = c(0.1, rep(1, nmods), 1.5, 0.5, 1), widths = c(0.1, rep(1, 6)))
	par(mar = rep(0,4), oma = c(0, 1, 0, 1))
	plot.new(); mtext('')
	plot.new(); mtext('')
	
	plotComp <- function(modName, dat, comp, addLegend) {
		plot.new(); mtext(modName, side = 2, line = -1)
		plotNME.site(x, y, z, dat, comp[[1]], name, cols, lims,
		             figOut = FALSE, addLegend = addLegend, ...)
		par(mar = rep(0,4))
	}
	
	mapply(plotComp, modNames, mod, comp, c(rep(FALSE, nmods -1), TRUE))
	
	mod = layer.apply(mod, mean)
	
	plotComMods.mod(mod, lims, cols, annotateFun = plotNME.site.points, annotateFunArgs = list(x, y, z))
	
	plot.new()
	par(mar = c(0, 0, 3, 3))
	#for (i in 1:3) plot(0)
	lapply(1:3, plotComMods.site, comp, cols)
	#browser()
}

plotComMods.site <- function(step, comp, cols) {
	obsMod = c()
	for (i in comp) obsMod = rbind(cbind(i[[1]]$x,i[[1]]$y123[, step]))
	density =  kde2d(obsMod[,1], obsMod[,2], n = 100)
	density$z = density$z / max(density$z)
	
	limits = c(0, 0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1)
	cols =  make_col_vector(cols, ncols = length(limits) - 1)
	filled.contour.custom(density, col = cols, levels = limits)
	mtext(paste('step', step))
	lines(c(0,0), c(9E9, 9E9))
	
	if (step == 2) mtext(side = 1, 'observed')
	if (step == 1) mtext(side = 2, 'simulates')
}

plotVarAgreement.IA <- function(mod, obs, name, modNames, info, scores, comp, ...) {
	mod = lapply(comp, function(i) i[[1]][[6]])
	obs = lapply(comp, function(i) i[[1]][[5]])
	x   = info$plotArgs$x
	yrange = range(unlist(mod), obs)
	
	fname =  paste(figs_dir, name, 'modObsMetric', '.pdf', sep = '-')
	pdf(fname, height = 13.5, width = 7.5)
	layout(c(1,5,2:4), heights = c(1, 0.3, 1, 1, 1))
	par(oma = c(0, 0, 1, 0), mar = c(3, 3, 0, 3))	
	
	##################
	## plot outputs	##
	##################
	plot(range(x), yrange, type = 'n', xlab = '', ylab ='')
	plotModObsLines <- function(md, ob, col) {
		lines(x, ob, lwd = 2)
		lines(x, md, col = col, lwd = 2)
	}
	mapply(plotModObsLines, mod, obs,  Model.plotting[, 2], SIMPLIFY = FALSE)
		
	plotStep <- function(FUN, stepN) {	
		##################
		## plot metric	##
		##################
		if (!is.null(FUN)) mod =  mapply(FUN, mod, obs, SIMPLIFY = FALSE)
		
		stepTitle = paste("metric contribution - step", stepN)
		NMEs = mapply(function(md, ob) abs(md-ob)/mean(abs(ob - mean(ob))), mod, obs, SIMPLIFY = FALSE)
		
		yrange = range(unlist(NMEs))
		plot(range(x), yrange, type = 'n', xlab = '', ylab ='')
		mtext(stepTitle)
		mapply(plotModObsLines, NMEs, NMEs,  Model.plotting[, 2])
		
		c(MetricLims, MN, RR) := nullScores_lims(scores)
		RR = tail(MetricLims, 3)
		addNullModel <- function(sc, nm, adj, ...) {	
			lines(x, rep(sc, length(x)), ...)
			text(x[1], sc, nm, adj = c(0.1, adj))
		}
		
		addNullModel(MN   , 'mean'   ,  1)
		addNullModel(RR[1], 'RR low' ,  1, lty = 2)
		addNullModel(RR[2], 'RR'     , -1)
		addNullModel(RR[3], 'RR high', -1, lty = 2)
	}
	mapply(plotStep, list(NULL, removeMean, removeMeanVar), 1:3)
	
	##################
	## legend    	##
	##################
	plot.new()
	par(mar = c(2, 0, 0, 0))
	legTitle = c('Observations', Model.plotting[, 1])
	legCol   = c('black', Model.plotting[, 2])
	legend(x = "center", legend = legTitle, ncol = 4, lwd = 1, col = legCol)
		
	dev.off.gitWatermarkStandard()
}

plotVarAgreement.spatial <- function(mod, obs, name, modNames, info, scores, ...) {
	mod = layer.apply(mod, mean)
	obs = mean(stack(obs))
	
	if (is.True(info$ExtraArgs[['mnth2yr']])) {
		mod = mod * 12
		obs = obs * 12
	}

	cols  = info$plotArgs$cols
	dcols = info$plotArgs$dcols
	lims  = info$plotArgs$limits
	dlims = info$plotArgs$dlimits
	
	plotSepMods.3step(mod, obs, modNames, name, info,
					  cols, dcols, lims, dlims, scores)
}

plotVarAgreement.seasonal <- function(mod, obs, name, modNames, info, scores, ...) {
	obs = PolarConcentrationAndPhase.memStore(obs)
	mod = lapply(mod, PolarConcentrationAndPhase.memStore)
	
	pmod = ithLayerFromList(mod, 1)	
	
	cols    = SeasonPhaseCols
	dcols   = SeasonPhaseDcols
	lims    = SeasonPhaseLimits
	dlims   = SeasonPhaseDlimits
	
	plotSepMods(pmod, obs[[1]], modNames, paste(name, 'phase', sep = '-'), info,
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
	plotSepMods.3step(cmod, obs[[2]], modNames, name, info, cols, dcols, lims, dlims,
				scores[, c("mean.concentration2", "random.concentration")])
}

plotSepMods.3step <- function(mod, obs, modNames, name, ...) {
	stepN <- function(FUN, title)  {
		if (!is.null(FUN)) mod = layer.apply(mod, FUN, obs)
		Name = paste(name, title, sep = '-')
		plotSepMods(mod, obs, modNames, Name, ...)
	}
	
	mapply(stepN, list(NULL, removeMean, removeMeanVar), paste('step', 1:3))
}

plotSepMods <- function(mod, obs, modNames, name, info, cols, dcols, lims, dlims, scores,
						    plotFun = plotNME.spatial.stepN, legendFun = add_raster_legend2, ...) {
	MetricCols = c('white', 'green', 'yellow', 'orange', 'red', 'black')
	MetricLabs = c('prefect', 'mean', 'RR low', 'RR', 'RR high')
	c(MetricLims, MN, RR) := nullScores_lims(scores)
	
	if (MetricLims[2] > MetricLims[5]) {
		MetricLims = MetricLims[-2]
		MetricLabs = MetricLabs[-2]
		MetricCols = MetricCols[-2]
	}
	
	nmods = nlayers(mod)
	np = nmods*3 + 6
	lmat  = t(matrix(rep(1:np, each = 2), nrow = 6))
	lmat2 = t(matrix(rep(np + c(1, 3, 2, 4), each = 3), nrow = 6))
	lmat3 = t(matrix(rep(np + c(5, 7, 6, 8), each = 3), nrow = 6))
	lmat  = rbind(lmat, lmat2, lmat3) 
	
	fname =  paste(figs_dir, name, 'modObsMetric', '.pdf', sep = '-')
	pdf(fname, height = 3 * (nmods + 1.5), width = 14)
	layout(lmat, heights = c(0.1, rep(1, nrow(lmat)-6),0.5, 1, 0.7, 1, 0.25))
	par(mar = rep(0,4), oma = c(0, 1, 0, 0))
	mtextPN <- function(txt) {
		plot.new()
		mtext(txt, side = 3, line = -3)
	}
	
	lapply(c('Simulated', 'Simulated - Observed', 'Metric contribution'), mtextPN)
	
	out = c()
	for (i in 1:nlayers(mod)) {
		out[i] = 
			plotFun(mod[[i]],obs, 1, modNames[i], cols, dcols, metricCols = MetricCols,
								   lims, dlims, MetricLims, figOut = FALSE, plotObs = FALSE)
	}
	legendFun(cols =  cols, limits =  lims, transpose = FALSE, plot_loc = c(0.2, 0.8, 0.8, 0.9), add = FALSE, 
	          mar = c(-0.5, 0, 0, 0))
	legendFun(cols = dcols, limits = dlims, transpose = FALSE, plot_loc = c(0.2, 0.8, 0.8, 0.9), add = FALSE, mar = rep(0,4))
	add_raster_legend2(cols = MetricCols, limits = MetricLims, labelss = MetricLabs,
	                   transpose = FALSE, plot_loc = c(0.2, 0.8, 0.8, 0.9), add = FALSE)	
	
	plotComMods(mod, obs, name, cols, lims, newFig = FALSE, legendFun = legendFun, ...)
	
	mapMetricScores.default(lapply(out,list), 1, info, score = MN)
	mapMetricScores.default(lapply(out,list), 1, info, score = RR, nullModel = "Randomly-resampled")
	dev.off.gitWatermarkStandard()
	plotComMods(mod, obs, name, cols, lims, newFig = TRUE, legendFun = legendFun, ...)
}


nullScores_lims <- function(x) {
	rmNaN <- function(i)
		if (i[1] == "N/A") invisible() else return(as.numeric(i))
	RR = strsplit(x[, 2], ' +/- ', fixed = TRUE)
	RR = lapply(RR, rmNaN)
	RR = matrix(unlist(RR), 2)
	
	MN = lapply(x[,1], rmNaN)
	MN = unlist(MN)
	
	scores = rbind(MN, matrix(RR, 2))
	scores = apply(scores, 1, mean)
	return(list(c(0, scores[1], scores[2] - scores[3], scores[2], scores[2] + scores[3]),
	            scores[1], scores[2]))
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

plotComMods.obs <- function(obs, lims, cols, name, legendFun = add_raster_legend2, ...) {
	plot_raster_from_raster(obs, limits = lims, cols = cols, add_legend = FALSE, y_range = c(-60, 90))
	mtext(paste(name, 'observations'), side = 3, line = -1)
	
	legendFun(cols = cols, limits = lims, transpose = FALSE, plot_loc = c(0.2, 0.8, 0.8, 0.9), mar = c(-0.5, 0,0,0), add = FALSE)
	
}

plotComMods.mod <- function(mod, lims, cols, obs = NULL,
                            legendFun = add_raster_legend2, eFun = sd.raster.missing,
							annotateFun = NULL, annotateFunArgs, ...) {
	mmod = mean(mod, na.rm = TRUE)
	if (!is.null(obs)) {
		obsMask = is.na(obs)
		mmod[obsMask] = NaN
	}
	emod = eFun(mod)
	if (!is.null(obs)) emod[obsMask] = NaN
	
	plot_raster_from_raster(mmod, limits = lims, cols = cols, add_legend = FALSE, y_range = c(-60, 90),
							e = emod, limits_error = c(0.5, 1),  
							ePatternRes = 30,  ePatternThick = 0.2, e_polygon = FALSE)
	mtext(paste('Model Ensemble'), side = 3, line = -1)
	
	if (!is.null(annotateFun)) do.call(annotateFun, annotateFunArgs)
	
	legendFun(cols = cols, limits = lims, transpose = FALSE,
	                   plot_loc = c(0.2, 0.8, 0.55, 0.87), e_lims = c(0.5, 1), mar = c(-0.5, 0,0,0), add = FALSE)

}

plotComMods <- function(mod, obs, name, cols, lims, newFig = TRUE, ...) {	
	
	if (newFig) {
		fname =  paste(figs_dir, name, 'modObsMean', '.pdf', sep = '-')
		pdf(fname, height = 3.67, width = 7.5)
		layout(cbind(1:2, 3:4), heights = c(1,0.5))
		par(mar = rep(0,4))
	}		
	plotComMods.obs(obs, lims, cols, name, ...)
	plotComMods.mod(mod, lims, cols, obs, ...)
	
	
	if (newFig) dev.off.gitWatermarkStandard()
}