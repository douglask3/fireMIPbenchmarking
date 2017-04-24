mapMetricScores <- function(comp, name, info) {
	if (length(comp[[1]]) < 4) return() # pragmatric fix to skip seasonal and mms
	dat     = select2ndCommonItem(comp, 4)
	nmetric =  max(sapply(dat, length), na.rm = TRUE)
	
	fname = paste(figs_dir, name, "MetricMapCombo", ".pdf", sep = '-')
	
	mapMetricScores.default(dat, nmetric, info, fname)
}

mapMetricScores.default <- function(dat, nmetric, info, fname = NULL, ...) {
	if (is.raster(dat[[1]][[1]])) FUN = mapMetricScores.raster
		else FUN = mapMetricScores.lines
	FUN(fname, nmetric, dat, info, ...)	
}

mapMetricScores.lines <- function(fname, nmetric, dat, info, score = 1, nullModel = 'mean'){
	
	dat = lapply(dat, function(i) i / mean(i))
	yrange = c(min(unlist(dat)), max(unlist(dat)))
	
	test = !sapply(dat, is.null)
	
	cols = Model.plotting[test, 2]
	x = info$plotArgs$x
	
	if (!is.null(fname)) {
		pdf(fname, height = 8 * 1.33, width = 9)
		layout(1:2, heights = c(1, 0.33))
		par(mar = c(3, 4, 1, 1))
	}
		plot(range(x), yrange, ylab = 'NME contribution', xlab = '', type = 'n')	
		mapply(function(y, col) lines(x, y, col = col, lwd = 2), dat, cols)
		plot.new()
		par(mar = c(1, 1, 1, 1))
		legend(x = 'top', legend = names(cols), ncol = 5, col = cols, lty = 1)
	if (!is.null(fname)) dev.off.gitWatermarkStandard()
}


mapMetricScores.raster <- function(fname, nmetric, dat, info, score = 1, nullModel = 'mean') {	
	nmodels = length(dat)
	mapMetricScore <- function(i) {
		stepn = i
		dat   = select2ndCommonItem(dat  , i)
		dat   = list2layers(dat)
		nmsk = sum(is.na(dat))
		
		cutPlt = sum(dat < score, na.rm = TRUE)
		cutPlt = cutPlt * nlayers(dat) / (nlayers(dat) - nmsk)
		cutPlt[nmsk == nlayers(dat)] = NaN
		plot_raster_from_raster(cutPlt, limits = 0.5:(nmodels - 0.5), cols = c('red', 'white', 'green'),
							    y_range = c(-60, 90), add_legend = FALSE)
		if (!is.null(fname)) mtext(side = 3, paste("step", stepn))
								
	}
	
	if (!is.null(fname)){
		pdf(fname, height = 2.5 * (nmetric + 0.3), width = 5)
		## setup
		layout(1:(nmetric + 1), heights = c(rep(1, nmetric), 0.3))
		par(mar = rep(0,4), oma = c(0,0,3,0))
	}
		## plot maps
		lapply(1:nmetric, mapMetricScore)
		
		## plot legend
		limits = seq(0.5, nmodels - 0.5, 0.5)
		labels = as.character(c(limits, nmodels))
		labels[seq(1, length(labels), by = 2)] = ""
		cols = rep(make_col_vector(c("red", "white", "green"), limits=0.5:8.5, whiteAt0=F), each = 2)
		add_raster_legend2(cols = cols, limits = limits, transpose = FALSE, labelss = labels,
		                   ylabposScling = 2, add = FALSE, plot_loc = c(0.05, 0.45, 0.95, 0.90))
		
		arrows(0.35, 1, 0.05, 1, lwd = 2, length = 0.1, xpd = NA)
		text('Models perform poorly', x = 0.2, y = 1.2, xpd = NA)
		
		arrows(0.65, 1, 0.95, 1, lwd = 2, length = 0.1, xpd = NA)
		text('Models perform well', x = 0.8, y = 1.2, xpd = NA)
		
		lab = paste('No. of model "better than ', nullModel ,'"', sep = '')
		text(lab, x = 0.5, y = 0.15, xpd = NA)
	if (!is.null(fname)) dev.off.gitWatermarkStandard()
}

select2ndCommonItem <- function(lst, i) lapply(lst, function(j) j[[i]])

