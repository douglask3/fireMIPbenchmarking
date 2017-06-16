#########################################################################
## cfg 																   ##
#########################################################################
source('cfg.r')

tempBAEfname = paste(temp_dir, 'BAGFAS', sep = '/')
tempVEGfname = paste(temp_dir, 'VEGCBN', sep = '/')

prFname = paste('../LimFIRE/data/cru_ts3.23/cru_ts3.23.',
			    c('1991.2000', '2001.2010', '2011.2014'),
				'.pre.dat.nc', sep = '')
				
figName = 'figs/burntArea_INFERNO_vs_'
				
prStart = 85
binSize = c(MAP = 100 , MMX = 100 , conc = 0.05, veg = 0.5)
maxBin  = c(MAP = 2600, MMX = 2000, conc = 1.00, veg = 6  )
minBin  = c(MAP = 0   , MMX = 0   , conc = 0   , veg = -4 )
units   = c('mm/yr'   , 'mm/month', ''         , 'gC/m2'  )
ylab    = c('Burnt Area (km2)', rep('Burnt Fraction', 3))
sampleIndex = 1:12#NULL

modsSelect = 3

options(scipen=999)

#########################################################################
## load  															   ##
#########################################################################
if (file.exists(tempBAEfname)) {
	load(tempBAEfname)
} else {
	source("run.fire.r")
	burntArea = list(obs = out[[2]], mod = out[[3]])
	emissions = list(obs = out[[5]], mod = out[[6]])

	save(burntArea, emissions, file = tempBAEfname)
}

if (file.exists(tempVEGfname)) {
	load(tempVEGfname)
} else {
	source("run.production.r")
	cveg = list(obs = out[[2]], mod = out[[3]])
	save(cveg, file = tempVEGfname)
}

index = prStart:(nlayers(burntArea[[1]]) + prStart -1)

pr0 = stack(prFname)[[index]]

#########################################################################
## Convert to matrices  															   ##
#########################################################################

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
		if (any(modsSelect != i)) return()
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
	pdf(paste(figName, xName, '.pdf', sep = ''), height = 0.4 * npy + 4, width = 0.4 * npx + 4)
		par(mfrow = c(npx,npy), mar = c(2, 1, 0, 0), oma = c(3,3,4,1))

		mapply(plotModel, 1:length(mbin), names(mod), 
			   c(rep('n', npx * (npy - 1)), rep('s', npy)), c('s', rep('n', length(modsSelect)-1)),
			   c(rep('', max(length( modsSelect) - 2, 0)), xlab, ''), 
			   c(rep('', npx + 1), ylab, rep('', length(modsSelect) - 1)))
		title(xName, outer = TRUE, line = 2)
	dev.off.gitWatermarkStandard()
}


mapply(plotMetric, list(pr, maxmin, conc, cveg),names(binSize), binSize, minBin, maxBin,
      c(F, T, T, T), c(F, F, F, T), units, ylab)

