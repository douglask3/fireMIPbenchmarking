mapMetricScores <- function(comp, name, info) {
	dat     = select2ndCommonItem(comp, 4)
	scores  = lapply(select2ndCommonItem(comp, 1), score)
	nmetric =  max(sapply(dat, length), na.rm = TRUE)
	
	print("feed in score")
	browser() 
	lapply(1:nmetric, mapMetricScore, dat, scores)
	browser()

}

mapMetricScore <- function(i, dat, scores) {
	dat   = select2ndCommonItem(dat  , i)
	score = select2ndCommonItem(scores, i)
	dat   = mapply('/', dat, score)
	dat   = list2layers(dat)
	
	mn      = mean(dat)
	mn_cols = c('white', '#FF9944', '#FF0000')
	mn_lims = quantile(mn, c(0.33, 0.67))
	
	vr      = sd.raster(dat) / mn
	vr_lims = quantile(vr, c(0.33, 0.67))
	
	plot_raster_from_raster(dat, cols = mn_cols, 
        limits = mn_lims, y_range = c(-60, 90), 		
        smooth_image = FALSE, smooth_factor = NULL,
        add_legend = FALSE, 
        e = vr, limits_error = vr_lims,  
        ePatternRes = 30,  ePatternThick = 0.2, e_polygon = FALSE)
	
	plot.new()
	#lines(c(0.33, 0.33), c(0, 1))
	#lines(c(0.67, 0.67), c(0, 1))
	#lines(c(0, 1), c(0.33, 0.33))
	#lines(c(0, 1), c(0.67, 0.67))
	lapply(1:3, function(i) {
		i2 = i/3; i1 = i2 - (1/3);
		polygon(c(i1, i2, i2, i1), c(0, 0, 1, 1), col = mn_cols[i], border = NA)
		
		x = seq(0, 1, by = 0.1) 
		y = seq(1, i1, by = -0.15)
		
		x = rep(x, each = length(y))
		y = rep(y, length.out = length(x))
		points(x, y, pch = 16, cex = i, col = make.transparent('black', 1 - i1))
		})			
	#lines(c(0.67, 0.0), c(0, 0.67))
	#lines(c(1, 0.33), c(0.33, 1))
	text('All models perform well', x = 0.15, y = 0.8)
	text('Some models perform well', x = 0.5, y = 0.2)
	text('All models perform poorly', x = 0.85, y = 0.8)
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