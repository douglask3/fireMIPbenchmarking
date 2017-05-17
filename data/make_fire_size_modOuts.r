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
	return(sum(i) / sum(j))
}

meanFire = mapply(bntByNr, bntFrc, NRfire)
