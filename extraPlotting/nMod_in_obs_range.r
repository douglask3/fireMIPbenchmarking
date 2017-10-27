source('cfg.r')
names = c('fire', 'production')
comparisons  = list(c("GFED4s.Spatial",  "GFAS"), c("cveg"))
plotSeason   =      c(TRUE            ,  FALSE , FALSE)
titles       = list(list(
					     c('a) GFED4s burnt area', 'b) Simulated burnt area', 
					       'c) Model performance in burnt area'),
					     c('d) GFED4s seasonal phase', 'e) Simulated seasonal phase',    
						   'f) Model performance in seasonal phase'),
						 c('g) GFED4s seasonal concentration',
  						   'h) Simulated seasonal concentration', 
						   'i) Model performance in seasonal concentration')),
					list(
						 c('j) GFAS fire emissions', 'k) Simulated fire emissions',
                           'm) Model performance in fire emissions')),		
					list(
						 c('n) Avitabile vegetative carbon',
						   'o) Simulated vegetative carbon',
						   'p) Model performance in vegetative carbon')))

		   
scale  = c(12, 12, 1)
						   
res = NULL
openOnly = TRUE
range = c(1.2, 2.0)
e_lims = list(c(0.5, 1), c(1, 2))

nmodLims  = seq(10, 90, 10)
nmodeCols = c('#AA0000', '#FFFF55', '#008800')

source('run.r')

limits = list(GFED4s.Spatial$plotArgs$limits,
		   GFAS$plotArgs$limits,
		   cveg$plotArgs$limits)
		   
cols   = list(GFED4s.Spatial$plotArgs$cols,
		   GFAS$plotArgs$cols,
		   cveg$plotArgs$cols)

if (length(names) > 1) out = unlist(out, recursive = FALSE)

plotAgreement <- function(x, txt, limits = nmodLims, cols = nmodeCols, e_lims, ...) {
	plotStandardMap(x, '',  limits = limits, cols = cols,
					add_legend = FALSE, e_polygon = FALSE, ePatternRes = 30, 
					ePatternThick = 0.2, limits_error = e_lims, ...)
	mtext(txt, side = 3, adj = 0.1, line = -1)
}

plotLegend <- function(cols, limits, plot_loc = c(0.2, 0.3, 0.8, 0.99), ...) {
	add_raster_legend2(cols = cols, limits = limits, ylabposScling = 2,
						   transpose = FALSE, plot_loc = plot_loc, 
						   add = FALSE, nx  = 1.75, ...)
}

plotSpatialNmod <- function(dat, txt, index, limits, cols, range, scale, e_lims, ...) {
	obs = mean(dat[[1]][[index]]) * scale
	
	plotAgreement(obs, txt[[1]][1], limits, cols)
	
	mod = layer.apply(dat[[2]], function(i) mean(i[[index]]))
	plotAgreement(mean(mod) * scale, txt[[1]][2], limits, cols,
				  e = sd.raster(mod), e_lims = e_lims)
	
	lower = obs / range
	upper = obs * range
	upper[upper < 0.001] = 0.001
	nmod = mean(mod >= lower & mod <= upper, na.rm = TRUE) * 100

	plotAgreement(nmod, txt[[1]][3], e_lims = e_lims)
	plotLegend(cols, limits, e_lims = e_lims)
}



plotSeasonalNmod <- function(dat, txt, index, range, e_lims, ...) {
	
	mnthRange =  6 * (1- 1/range)
	obs = PolarConcentrationAndPhase(dat[[1]][[index]], phase_units = 'months')
	mod = lapply(dat[[2]][-c(5,8)], function(i) PolarConcentrationAndPhase(i[[index]], phase_units = 'months'))
	
	obsP = obs[[1]]
	plotAgreement(obsP, txt[[2]][1], SeasonPhaseLimits, SeasonPhaseCols, e_lims)
	SeasonLegend(SeasonPhaseLimits, SeasonPhaseCols, dat = modPmean,
				 mar = rep(0,4), add = TRUE, xp = 1.08, e_lims = e_lims)
	
	modP = layer.apply(mod, function(i) i[[1]])
	
	xP = mean(cos(modP * 2 * pi / 12), na.rm = TRUE)
	yP = mean(sin(modP * 2 * pi / 12), na.rm = TRUE)
	modPmean = atans(yP, xP)
	modPmean[is.na(obsP)] = NaN
	
	xP = sd.raster(cos(modP * 2 * pi / 12))
	yP = sd.raster(sin(modP * 2 * pi / 12))
	modPsd = atans(yP, xP)
	modPsd[is.na(obsP)] = NaN
	
	plotAgreement(modPmean, txt[[2]][2], SeasonPhaseLimits, SeasonPhaseCols,
	              e_lims = e_lims, e = modPsd / 3)
	SeasonLegend(SeasonPhaseLimits, SeasonPhaseCols, dat = modPmean, mar = rep(0,4),
				 add = TRUE, xp = 0.08, e_lims = e_lims)
	
	diff = abs(obsP - modP)
	nmod = diff < mnthRange | diff > 12 - mnthRange	
	nmod = mean(nmod, na.rm = TRUE) * 100
	plotAgreement(nmod, txt[[2]][3], e_lims = e_lims)
	
	plot.new()
	plot.new()
	
	obsC = obs[[2]]
	plotAgreement(obsC, txt[[3]][1], SeasonConcLimits, SeasonConcCols, e_lims)
	
	modC  = layer.apply(mod, function(i) i[[2]])
	modCm = mean(modC, na.rm = TRUE)
	modCm[is.na(obsP)] = NaN
	sdC = sd.raster(modC, FALSE) / sqrt(vartrunc("norm", 0, 1))
	sdC[is.na(obsP)] = NaN
	
	plotAgreement(modCm, txt[[3]][2], SeasonConcLimits, SeasonConcCols, 
	              e_lims = e_lims, e = sdC)
	
	lower = obsC ^ range
	upper = obsC ^ (1/range)
	
	nmod = mean(modC >= lower & modC <= upper, na.rm = TRUE) * 100
	plotAgreement(nmod, txt[[3]][3], e_lims = e_lims)
	
	plotLegend(SeasonConcCols, SeasonConcLimits, e_lims = e_lims)
}


plotVariable <- function(dat, pltSeason, txt, 
						 limits, cols, add_extra_leg, 
						 index = 1:12, range, ...) {
	if (nlayers(dat[[1]]) == 1) index = 1
	else if (is.null(index)) index = 1:nlayers(dat[[1]])
	
	dat[[2]] = dat[[2]][!sapply(dat[[2]], is.null)]
	
	plotSpatialNmod(dat, txt, index, limits, cols, range, ...)
	if (pltSeason) {
		plot.new()
		plotSeasonalNmod(dat, txt, index, range, ...)
	}
	
	if (add_extra_leg) plotLegend(nmodeCols, nmodLims, plot_loc = c(0.2, 0.5, 0.8, 0.8),
								  labelss = c(0, nmodLims, 100))
	else plot.new()
}

for (r in range) for (es in e_lims) {		
	nrow = length(plotSeason) + sum(plotSeason) * 2
	
	lmat = index = t(matrix(c(1:3,4,4,5), ncol = 2))
	for (i in 2:nrow) lmat = rbind(lmat, index + (i-1) * 5)
	
	#lmat = t(matrix(1:(3*6), ncol = nrow))
	#lmat = rbind(lmat, max(lmat) + 1)
	
	fname = paste('figs/nmodAgreement', '-R', r - 1, '-sd', paste(es, collapse='-'), '.png', sep = '')
	png(fname, height = 2 * nrow, width = 10, unit = 'in', res = 300)
		layout(lmat, heights = c(1, 0.3, 1, 0.01, 1, 0.3, 1, 0.3, 1, 0.3))
		par(mar = rep(0, 4), oma = c(0, 0, 2, 0))
		
		mapply(plotVariable, out, plotSeason, titles, limits, cols, c(F, F, T), scale = scale, MoreArgs = list(range = r, e_lims = es))			   
	dev.off.gitWatermarkStandard()
}