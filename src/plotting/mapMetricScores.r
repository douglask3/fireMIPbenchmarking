mapMetricScores <- function(comp, name, info) {
	dat     = select2ndCommonItem(comp, 4)
	scores  = lapply(select2ndCommonItem(comp, 1), score)
	nmetric =  max(sapply(dat, length), na.rm = TRUE)
	
	fname = paste(figs_dir, name, "MetricMapCombo", ".pdf", sep = '-')
	
	pdf(fname, height = 5 * nmetric, width = 5)
	
	layout(c((1:nmetric)+1, 1))
	par(mar = rep(0,4))
	
	mapply(mapMetricScore, 1:nmetric, c(T, rep(F, nmetric - 1)), MoreArgs = list(dat, scores))
	dev.off.gitWatermarkStandard()

}

mapMetricScore <- function(i, pltLegend = FALSE, dat, scores) {
	dat   = select2ndCommonItem(dat  , i)
	score = select2ndCommonItem(scores, i)
	dat   = mapply('/', dat, score)
	dat   = list2layers(dat)
	
	mn      = mean(dat)	
	mn_lims = quantile(mn, seq(0.1, 0.9, 0.1))
	vr      = sd.raster(dat, FALSE)
	vr[is.na(mn)] = NaN
	vr_lims = quantile(vr, seq(0.1, 0.9, 0.1))
	
	cutPlt = mn
	cutPlt[] = 0.0	
	cols = c()
	p = 0
	if (pltLegend) plot.new()
	for (i in 1:length(mn_lims)) for (j in length(vr_lims):1) {
		p = p + 1
		ml = mn_lims[i]; vl = vr_lims[j]
		b = (i-1)/(length(mn_lims) - 1)
		r = (1 - b)
		g = ((j - 1)/(length(vr_lims) - 1)) ^ 3
		r = r + (1 - r) * g
		b = b + (1 - b) * g
		cols[p] = hex(RGB(r,g,b))
		test = mn < ml & vr < vl;
		cutPlt[test] = cutPlt[test] + 1	
		
		x = 1 - (i - 0.5)/length(mn_lims)
		y = 1 - (j - 0.5)/length(vr_lims)
		if (pltLegend) points(x, y, pch = 15, col = cols[p])
	}
	text(0.2, 0.9, 'All model perform well')
	text(0.8, 0.9, 'All model perform poorly')
	text(0.1, 0.5, 'Some models perform well')
	
	cutPlt[is.na(mn)] = NaN
	plot_raster_from_raster(cutPlt, limit = 1:p, cols = cols, y_range = c(-60, 90),
	                        readyCut = TRUE, add_legend = FALSE)
							
}

select2ndCommonItem <- function(lst, i) lapply(lst, function(j) j[[i]])
list2layers <- function(lst) layer.apply(lst, function(i) i)

sd.raster <- function(ldata,pmean=TRUE) {
    llayers=nlayers(ldata)
    ones=rep(1,llayers)
    lmean=stackApply(ldata,ones,'mean',na.rm=TRUE)
    ldelt=ldata-lmean

    ldelt=ldelt*ldelt

    lvarn=stackApply(ldelt,ones,'sum',na.rm=TRUE)/llayers

    lvarn=sqrt(lvarn)
    if (pmean) lvarn=lvarn/abs(lmean)
    return(lvarn)

}