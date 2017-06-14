
fname = paste(temp_dir, 'BAGFAS', sep = '/')

prFname = paste('../LimFIRE/data/cru_ts3.23/cru_ts3.23.',
			    c('1991.2000', '2001.2010', '2011.2014'),
				'.pre.dat.nc', sep = '')
				
prStart = 85

sampleIndex = 1:12

bins = seq(0, 2600, 100)


if (file.exists(fname)) {
	load(fname)
} else {
	source("run.fire.r")
	burntArea = list(obs = out[[2]], mod = out[[3]])
	emissions = list(obs = out[[5]], mod = out[[6]])

	save(burntArea, emissions, file = fname)
}

index = prStart:(nlayers(burntArea[[1]]) + prStart -1)

pr = stack(prFname)[[index]]


## convert2ANnualAverage
if (is.null(sampleIndex)) sampleIndex = 1:nlayers(pr)
mean12 <- function(i) mean(i[[sampleIndex]]) * 12
pr = mean12(pr)

obs = burntArea[[1]]
mod = burntArea[[2]]
Area = raster::area(obs)

obs = mean12(obs)
mod = lapply(mod, mean12)

fireInMod <- function(x) {
	fireInBin <- function(b1, b2) {
		test = pr > b1 & pr <= b2
		barea = sum(x[test] * Area[test], na.rm = TRUE) #/ sum(Area[test], na.rm = TRUE)
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

plotModel <- function(i, name) {
	plot(range(bins), c(0, ymax), type = 'n', xlab = '', ylab = '')
	lapply(mbin[-i], addPoly)

	addPoly(mbin[[i]], col = make.transparent('red', 0.5))
	lines(bins, obin, col = 'blue')
	mtext(name)
}

par(mfrow = c(3,3), mar = c(3, 2, 1, 1))

mapply(plotModel, 1:length(mbin), names(mod))
