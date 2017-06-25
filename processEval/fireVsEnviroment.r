#########################################################################
## cfg 																   ##
#########################################################################
source("processEval/load_fire.r")

figName = 'figs/burntArea_INFERNO_vs_'
#figName = 'figs/burntArea_vs_'
				
prStart = 85
binSize = c(MAP = 100 , MMX = 100 , Precip_seasonality = 0.05, veg = 0.5)
maxBin  = c(MAP = 2600, MMX = 2000, Precip_seasonality = 1.00, veg = 6  )
minBin  = c(MAP = 0   , MMX = 0   , Precip_seasonality = 0   , veg = -4 )
units   = c('mm/yr'   , 'mm/month', ''         , 'gC/m2'  )
ylab    = c('Burnt Area (km2)', rep('Burnt Fraction', 3))
sampleIndex = NULL

modsSelect = 3
#modsSelect = NULL

options(scipen=999)



#########################################################################
## Convert to matrices  															   ##
#########################################################################
if (is.null(modsSelect)) modsSelect = 1:9
## convert to annual average
if (is.null(sampleIndex)) sampleIndex = 1:nlayers(pr0)
mean12 <- function(i) mean(i[[sampleIndex]]) * 12
pr  = mean12(pr0)
cveg[[1]] = mean(cveg[[1]])
cveg[[2]] = lapply(cveg[[2]], mean)

cveg[[1]] = raster::resample(cveg[[1]], pr)
cveg[[2]] = lapply(cveg[[2]], raster::resample, pr)

obs = burntArea[[1]]
mod = burntArea[[2]]
Area = raster::area(obs)

obs = mean12(obs)
mod = lapply(mod, mean12)

## convert to max vs min

prClim = climateologize(pr0)
maxmin = max(prClim) - min(prClim)
conc   = PolarConcentrationAndPhase(prClim)[[2]]

extrapNaN <- function(x) {
	test = is.na(x)
	test[test > 1 && test < length(x)]
	x[test] = (x[test - 1] + x[test + 1])/2
	return(x)
}

plotMetric <- function(Xdat, xName, binS, binMin, binMax, normArea = TRUE,
                       logX = FALSE, xlab = '', ylab = '') {
	print(xName)
	
	bins = seq(binMin, binMax, binS)
	fireInMod <- function(x, Xdati) {
		if (logX) Xdati = log(Xdati)
		fireInBin <- function(b1, b2) {
			test = Xdati > b1 & Xdati <= b2
			
			barea = sum(x[test] * Area[test], na.rm = TRUE) 
			if (normArea) barea = barea / sum(Area[test], na.rm = TRUE)
				else barea = barea / binS
			
			return(barea)
		}
		barea = mapply(fireInBin, head(bins,-1), bins[-1])	
		barea = extrapNaN(barea)
		
		return(barea)
	}
	
	if (is.raster(Xdat)) Xdat = list(Xdat, lapply(1:length(mod), function(i) Xdat))
	
	obin = fireInMod(obs, Xdat[[1]])
	mbin = mapply(fireInMod, mod, Xdat[[2]], SIMPLIFY = FALSE)
	
	ymax = max(obin, unlist(mbin), na.rm = TRUE)


	bins =  bins[-1] - diff(bins)/2
	if (logX) {
		bins = exp(bins)
		plog = 'x'
	} else plog = ''
	addPoly <- function(p, col = make.transparent('black', 0.5)) 
		polygon(c(bins, rev(bins)), c(p, rep(0, length(p))), border = NA, col = col)

	plotModel <- function(i, name, xaxt = 'n', yaxt = 'n', xlab = '', ylab = '') {
		if (!is.null(modsSelect) && all(modsSelect != i)) return()
		print(name)
		plot(range(bins), c(0, ymax), type = 'n',
			 xlab = xlab, ylab = ylab, xaxt = xaxt, yaxt = yaxt, log = plog)
		lapply(mbin[-i], addPoly)
		mtext(xlab, line = 2, side = 1, cex = 0.9)
		mtext(ylab, line = 2, side = 2, cex = 0.9)
		addPoly(mbin[[i]], col = make.transparent('red', 0.5))
		lines(bins, obin, col = 'blue')
		mtext(name)
	}
	
	if (!is.null(modsSelect)) {
		npx = ceiling(sqrt(length(modsSelect))); npy = ceiling(length(modsSelect)/ npx)
	} else npx = npy = 3
	png(paste(figName, xName, '.png', sep = ''), height = 0.4 * npy + 4, width = 0.4 * npx + 4, units = 'in', res = 300)
		par(mfrow = c(npx,npy), mar = c(2, 1, 0, 0), oma = c(3,3,4,1), bg = make.transparent('white', 1))

		if (length( modsSelect) == 1) ylabIndex = ylab
		else
			ylabIndex = c(rep('', npx), ylab, rep('', length(modsSelect) - 1 - npx))
		
		mapply(plotModel, 1:length(mbin), names(mod), 
			   c(rep('n', npx * (npy - 1)), rep('s', npy)), rep(c('s', rep('n', npx - 1)), npy),
			   c(rep('', max(length( modsSelect) - 2, 0)), xlab, ''), 
			   ylabIndex)
		title(xName, outer = TRUE, line = 2)
	dev.off.gitWatermarkStandard()
}


mapply(plotMetric, list(pr, maxmin, conc, cveg),names(binSize), binSize, minBin, maxBin,
      c(F, T, T, T), c(F, F, F, T), units, ylab)

