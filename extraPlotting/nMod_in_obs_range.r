names = c('fire', 'production')
comparisons  = list(c("GFED4s.Spatial",  "GFAS"), c("cveg"))
plotSeason   =      c(TRUE            ,  FALSE , FALSE)
titles       = list(c('a) Burnt Area',
					 'b) Seasonal phase',
					 'c) Seasonal concentration'),
										 'd) Emission', 'e) Vegetation Carbon')

res = NULL
openOnly = TRUE
range = c(1.2, 2.0)

limits = seq(10, 90, 10)
cols   = c('#AA0000', '#FFFF55', '#008800')

source('run.r')
if (length(names) > 1) out = unlist(out, recursive = FALSE)

plotAgreement <- function(x, txt) {
	plotStandardMap(x, '',  limits = limits, cols = cols,
					add_legend = FALSE)
	mtext(txt, side = 3, adj = 0.1, line = -1)
}

plotSpatialNmod <- function(dat, txt, index, range) {
	obs = mean(dat[[1]][[index]])
	mod = layer.apply(dat[[2]], function(i) mean(i[[index]]))

	lower = obs / range
	upper = obs * range
	
	upper[upper < 0.001] = 0.001

	nmod = mean(mod >= lower & mod <= upper, na.rm = TRUE) * 100

	plotAgreement(nmod, txt[1])
}

plotSeasonalNmod <- function(dat, txt, index, range) {
	mnthRange =  6 * (1- 1/range)
	obs = PolarConcentrationAndPhase(dat[[1]][[index]], phase_units = 'months')
	mod = lapply(dat[[2]], function(i) PolarConcentrationAndPhase(i[[index]], phase_units = 'months'))
	
	modP = layer.apply(mod, function(i) i[[1]])
	obsP = obs[[1]]
	
	diff = abs(obsP - modP)
	nmod = diff < mnthRange | diff > 12 - mnthRange	
	nmod = mean(nmod, na.rm = TRUE) * 100
	plotAgreement(nmod, txt[2])
	
	modP = layer.apply(mod, function(i) i[[2]])
	obsP = obs[[2]]
	
	lower = obsP ^ range
	upper = obsP ^ (1/range)
	
	nmod = mean(modP >= lower & modP <= upper, na.rm = TRUE) * 100
	plotAgreement(nmod, txt[3])
}


plotVariable <- function(dat, pltSeason, txt, index = NULL, range) {
	if (nlayers(dat[[1]]) == 1) index = 1
	else if (is.null(index)) index = 1:nlayers(dat[[1]])
	
	dat[[2]] = dat[[2]][!sapply(dat[[2]], is.null)]
	
	plotSpatialNmod(dat, txt, index, range)
	if (pltSeason) plotSeasonalNmod(dat, txt, index, range)
}

for (i in range) {	
	
	fname = paste('figs/nmodAgreement', '-R', i, '.pdf', sep = '')
	pdf(fname, height = 8, width = 10)
	lmat = rbind(cbind(1:3,c(4:5,0)), c(6,6))
	layout(lmat, heights = c(1,1,1,0.3))
	par(mar = rep(0, 4), oma = c(0, 0, 2, 0))
	
	mapply(plotVariable, out, plotSeason, titles, MoreArgs = list(range = i))

	add_raster_legend2(cols = cols, limits = limits, ylabposScling = 2,
	                   transpose = FALSE, plot_loc = c(0.2, 0.6, 0.8, 0.9), add = FALSE)
					   
	dev.off.gitWatermarkStandard()
}