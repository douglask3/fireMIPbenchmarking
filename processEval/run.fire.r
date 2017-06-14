#########################################################################
## cfg 																   ##
#########################################################################

tempFname = paste(temp_dir, 'BAGFAS', sep = '/')

prFname = paste('../LimFIRE/data/cru_ts3.23/cru_ts3.23.',
			    c('1991.2000', '2001.2010', '2011.2014'),
				'.pre.dat.nc', sep = '')
				
prStart = 85
binSize = c(MAP = 100 , MMX = 100 , conc = 0.05)
maxBin  = c(MAP = 2600, MMX = 2000, conc = 1.00)
sampleIndex = NULL



#########################################################################
## load  															   ##
#########################################################################
source('cfg.r')

if (file.exists(tempFname)) {
	load(tempFname)
} else {
	source("run.fire.r")
	burntArea = list(obs = out[[2]], mod = out[[3]])
	emissions = list(obs = out[[5]], mod = out[[6]])

	save(burntArea, emissions, file = tempFname)
}

index = prStart:(nlayers(burntArea[[1]]) + prStart -1)

pr0 = stack(prFname)[[index]]

#########################################################################
## Convert to matrices  															   ##
#########################################################################

## convert to annual average
if (is.null(sampleIndex)) sampleIndex = 1:nlayers(pr0)
mean12 <- function(i) mean(i[[sampleIndex]]) * 12
pr = mean12(pr0)

obs = burntArea[[1]]
mod = burntArea[[2]]
Area = raster::area(obs)

obs = mean12(obs)
mod = lapply(mod, mean12)

## convert to max vs min

prClim = climateologize(pr0)
maxmin = max(prClim) - min(prClim)
conc   = PolarConcentrationAndPhase(prClim)[[2]]

plotMetric <- function(Xdat, xName, binS, binM, normArea = TRUE) {
	bins = seq(0, binM, binS)
	fireInMod <- function(x) {
		fireInBin <- function(b1, b2) {
			test = Xdat > b1 & Xdat <= b2
			
			barea = sum(x[test] * Area[test], na.rm = TRUE) 
			if (normArea) barea = barea / sum(Area[test], na.rm = TRUE)
				else barea = barea / binS
			return(barea)
		}

		mapply(fireInBin, head(bins,-1), bins[-1])
	}

	obin = fireInMod(obs)
	mbin = lapply(mod, fireInMod)

	ymax = max(obin, unlist(mbin))


	bins =  bins[-1] - diff(bins)/2
	addPoly <- function(p, col = make.transparent('black', 0.5)) 
		polygon(c(bins, rev(bins)), c(p, rep(0, length(p))), border = NA, col = col)

	plotModel <- function(i, name, xaxt = 'n', yaxt = 'n') {
		plot(range(bins), c(0, ymax), type = 'n',
			 xlab = '', ylab = '', xaxt = xaxt, yaxt = yaxt)
		lapply(mbin[-i], addPoly)

		addPoly(mbin[[i]], col = make.transparent('red', 0.5))
		lines(bins, obin, col = 'blue')
		mtext(name)
	}
	
	pdf(paste('figs/burntArea_vs_', xName, '.pdf', sep = ''), height = 6, width = 6)
		par(mfrow = c(3,3), mar = c(2, 1, 0, 0), oma = c(3,3,4,1))

		mapply(plotModel, 1:length(mbin), names(mod), 
			   c(rep('n', 6), rep('s', 3)), c('s', 'n', 'n'))
		title(xName, outer = TRUE, line = 2)
	dev.off.gitWatermarkStandard()
}

mapply(plotMetric, c(pr, maxmin, conc),names(binSize), binSize, maxBin, c(F, T, T))