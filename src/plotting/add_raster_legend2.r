add_raster_legend2 <- function (cols, limits, e_lims = 0,
                                plot_loc = c(0, 0, 1, 1), add = FALSE, ...) {
	if (!add) plot.new()
	if (is.null(limits))
		limits = 0:(length(cols) - 1)
	if (length(cols) != (length(limits) + 1)) 
        cols = make_col_vector(cols, ncols = length(limits) + 1)

	box_corns(plot_loc)
	if (is.null(e_lims) || length(e_lims) == 1)
		add_raster_legend2.regular(cols, limits, plot_loc, ...)
	else 
		add_raster_legend2.2d(cols, limits, e_lims, plot_loc, ...)
		
	
}

box_corns <- function(xy, col = 'white', ...) {
	x1 = xy[1]; y1 = xy[2]; x2 = xy[3]; y2 = xy[4]
	
	x = c(x1, x1, x2, x2, x1)
	y = c(y1, y2, y2, y1, y1)
	polygon(x, y, col = col,...)
}

add_raster_legend2.regular <- function(cols, limits, plot_loc, 
    labelss = NULL, dat = NULL, spt.cex = 2, pch = 15, main_title = "",
    labelss.cex = 1, title_cex = 0.8, srt = 90, transpose = TRUE, 
    oneSideLabels = TRUE, ylabposScling = 1, ticksInCenter = FALSE, ...)  {
	
	xp = seq(plot_loc[1], plot_loc[3], length.out = length(cols) + 1)
	x2 = xp[-1]
	x1 = head(xp, -1)
	if (is.null(labelss)) labelss = limits
	
	pltCol <- function(x1, x2, col) {
		xy = c(x1, plot_loc[2], x2, plot_loc[4])
		box_corns(xy, col)
	}
	
	mapply(pltCol, x1, x2, cols)
	
	x = seq(plot_loc[1], plot_loc[3], length.out = 2*length(cols) + 1)
	
	if (ticksInCenter) {
		browser()
	} else {
		if (length(labelss) == (length(cols) - 1)) labelss = c("", labelss, "")
		labelss = head(unlist(lapply(labelss, function(i) c(i, ""))),-1)
		if (limits[1] == 0) labelss = labelss[c(1,3,2, 4:length(labelss))]
	}
	print(ylabposScling)
	y = plot_loc[2]
	text(x = x, y = y - 0.07 * ylabposScling, labels = labelss)
	text(main_title,
	     x = mean(plot_loc[c(1,3)]), y  = y - 0.1 * ylabposScling)
	
}


add_raster_legend2.2d <- function(cols, limits, e_lims, plot_loc,...)  {
	add_raster_legend2.regular(cols, limits, plot_loc, ...)
	
	cols = make.transparent("black", c(0.67, 0.33))
	
	dx = 3/360
	dy = (par("pin")[1]/par("pin")[2]) * dx
	
	x = seq(plot_loc[1], plot_loc[3], by = dx)[-1]
	x = head(x, -1)
	nl = length(e_lims)
	
	ysplit = seq(plot_loc[2], plot_loc[4], length.out = nl + 2)[-1]
	
	add_transp <- function(y1, pch, cex, col, lim) {
		y = seq(tail(ysplit, 1), y1, by = - dy)[-1]
		lengthY = length(y)
		y = rep(y, each = length(x))
		x = rep(x, lengthY)
		points(x, y, pch = pch, col = col, cex = cex)
		text(plot_loc[1] - 0.02, y = y1, labels = lim)
	}
	cexs = 0.5 * c(0.67 , 1, 1.5, 1.3, 1.3, 1 , 1 )[1:nl]
	pchs = c(20, 20 , 16 , 16 , 16 , 16, 16)[1:nl]
	
	mapply(add_transp, head(ysplit, -1), pchs, cexs, cols, rev(e_lims))
	text(plot_loc[1] - 0.05, mean(plot_loc[c(2,4)]), 'sd')
}