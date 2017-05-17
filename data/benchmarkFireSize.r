source('cfg.r')
names = 'fire'
comparisons = list(c("NRfire", "GFED4s.Spatial"))
source('run.r')

NRfire = out[3,][[1]]
bntFrc = out[6,][[1]]

whichMods = !mapply(function(i,j) is.null(i) || is.null(j), NRfire, bntFrc)

NRfire = NRfire[whichMods]
bntFrc = bntFrc[whichMods]

NRfire = lapply(NRfire, function(i) i[[1 :7  ]])
bntFrc = lapply(bntFrc, function(i) i[[73:156]])

annualize <- function(r, FUN = function(i) sum(i)) {
	nyr = floor(nlayers(r)/12)
	annualize1yr <- function(y) {
		m = (12*(y-1)+1):(y*12)
		FUN(r[[m]])
	}
	return(layer.apply(1:nyr, annualize1yr))
}

bntFrc = lapply(bntFrc, annualize)

bntByNr <- function(i, j) {
	i = raster::resample(i, j)
	i = sum(i); j = sum(j)
	k = i / j
	k[i == 0] = 0.0
	k[j == 0] = 0.0
	return(k)
}

ModMeanFire = mapply(bntByNr, bntFrc, NRfire)
ModMeanFire = lapply(ModMeanFire, function(i) i * raster::area(i) * 100)

filenames = paste(outputs_dir, names(ModMeanFire), 'meanFire.nc', sep = '-')
ModMeanFire = mapply(writeRaster.gitInfo, ModMeanFire, filenames, overwrite = TRUE)

inp = out[3,][[1]]
inp = lapply(inp, function(i) return(NULL))
inp[ whichMods] = ModMeanFire

runComparison(meanFire, 'meanFire', inp)
