#########################################################################
## cfg 																   ##
#########################################################################
source("processEval/load_fire.r")
				
figName = 'figs/seasonality_JULES'
#figName = 'figs/burntArea_vs_'
				

sampleIndex = NULL

modsSelect = 3
#modsSelect = NULL

extents    = list(Sahel          = extent( 10, 45, 5, 12),
		          SouthernAfrica = extent(-25, 45, -12, -5),
			      India          = extent(73,85,5, 25),
				  SEAus          = extent(146,151, -45, -26))
				  
extentXindex = list(Sahel          = c(8:12, 1:8),
		            SouthernAfrica = c(1:12,1),
			        India          = c(12,1:12),
				    SEAus          = c(7:12,1:7))

options(scipen=999)

apply2obsmod <- function(r, FUN, ...) {
	r[[1]] = FUN(r[[1]], ...)
	r[[2]] = lapply(r[[2]], FUN, ...)
}

climateologizeArea <- function(r, extent, areaNormal = TRUE) {
	r = crop(r, extent)
	r = climateologize(r)
	
	rArea = raster::area(r[[1]], na.rm = TRUE)
	r = r * rArea
	r = apply(r[], 2, sum, na.rm = TRUE)
	
	if (areaNormal) r = r / sum(rArea[], na.rm = TRUE)
	#r = r[c(12, 1:12)]
	return(r)
}

ceilingN <- function(x, n = 1) {
	sc = 10^(find.ndig(x) - n)
	return(sc * ceiling(x/sc))
}

plot4Extent <- function(extent, name, Xindex, norm) {
	tempName = paste('temp/seasonality4', name, sep = '-')
	if (file.exists(tempName)) {
		load(tempName)
	} else {
		pr = climateologizeArea(pr0, extent)
		burntArea = apply2obsmod(burntArea, climateologizeArea, extent)
		burntArea = lapply(burntArea, '*', 100)
		emissions = apply2obsmod(emissions, climateologizeArea, extent)
		save(pr, burntArea, emissions, file = tempName)
	}
	plot(c(0, 12), c(0, 1), type = 'n', axes = FALSE, xlab = '', ylab = '')
	axis(1, at = 0:12, labels = substr(month.abb[Xindex], 0, 1))
	
	
	plotLines <- function(y, ymax = NULL, ...) {
		if (is.null(ymax)) ymax = sum(y) * 0.3
		y = y / ymax
		lines(0:12, y[Xindex], lwd = 2, ...)
	}
	
	addAxis <- function(mx, side,...) {
		length.out = mx/10^(find.ndig(mx)-1) + 1
		index = seq(0, 1, length.out = length.out)	
		axis(at = index, labels = index * mx, side = side, ...)
		
	}
	
	if (norm) baMax = NULL
		else baMax =  ceilingN(max(unlist(burntArea)))
	lapply(burntArea[-1], plotLines, baMax, col = '#F0F0F0')
	
	prMax = ceilingN(max(pr))
	pr = pr / prMax
	lines(0:12, pr[Xindex], lwd = 2, col = 'blue')
	addAxis(prMax, 4)
	
	plotLines(burntArea[[1]], baMax, col = 'red', lty = 2)
	plotLines(burntArea[[4]], baMax, col = 'red')
	
	if (norm) baMax = 0.3
	addAxis(baMax, 2)
	
	title(name, line  = -2)
}

normNoneNorm <- function(norm, name, ylab) {
	figName = paste(figName, name, '.png', sep = '')
	png(figName, width = 8, height = 6.67, units = 'in', res = 300)
	
		lmat = rbind(c(1:2),c(5,5), (3:4))
		layout(lmat, heights = c(3,0.67,3))
		
		par( mar = c(3,2,1,2), oma = c (0, 2, 0, 2))
		mapply(plot4Extent, extents, names(extents), extentXindex, norm)
		
		plot.new()
		legend('center', c('precip', 'GFED4s', 'JULES', 'fireMIP models'), horiz = TRUE, lty = c(1,2,1,1),
		       col = c('blue', 'red', 'red', '#F0F0F0'), lwd = 2, bty = 'n')

		par(fig = c(0, 1, 0, 1))
		mtext(side = 2, ylab, line = 2.5)
		mtext(side = 4, 'precip (mm)', line = 2.5)
	dev.off()
}

normNoneNorm(TRUE, '_normalised', 'burnt area (% of annual burnt area)')
normNoneNorm(FALSE, '', 'burnt area (%)')

