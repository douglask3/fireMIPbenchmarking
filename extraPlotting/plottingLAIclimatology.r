names = 'vegCover'
comparisons = list(c("LAImodis"))
source('run.r')


extent = extent(c(55, 125, 40, 52))

dat = c(out[[1]][2], out[[1]][[3]])
names(dat) = c('MODIS', names(out[[1]][[3]]))
dat = dat[!sapply(dat, is.null)]

dat = lapply(dat, climateologize)

dat = lapply(dat, raster::crop, extent)
dat = lapply(dat, function(i) unlist(layer.apply(i, mean.raster, na.rm = TRUE)))
dat = lapply(dat, function(i) c(i, i[1]))
yrange = range(unlist(dat))
yrange[1] = 0

graphics.off()
png('figs/climatology.png', height = 5, width = 8, units = 'in', res = 300)
	plot(c(0, 12), yrange, axes = FALSE, xlab = '', ylab = '', type = 'n')
	axis(1, at = 0:12, labels = c('J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D', 'J'))
	axis(2)
	mtext.units('LAI (~m2~/~m2~)', side = 2, line = 2)

	lines(0:12, dat[[1]], lwd = 2)

	modRange4month <- function(mn, q) quantile(sapply(dat[-1], function(i) i[mn]), c(q, 1-q))

	plotQR <- function(q) {
		mod = sapply(1:13, modRange4month, q)
		polygon(c(0:12, 12:0), c(mod[1,], rev(mod[2,])), col = make.transparent('black', 0.9), border = NA)
	}

	lapply(c(0.0, 0.1, 0.33, 0.49), plotQR)

	lines(0:12, dat$'INFERNO', col = 'red', lwd = 2)

	legend('bottom', lwd = 2, col = c('black', 'red'), legend = c('MODIS', 'JULES-INFERNO'), horiz = TRUE, bty = 'n')
dev.off.gitWatermark(x = 0.7, y = 0.9, srt = 0)