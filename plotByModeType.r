################################
## cfg   				      ##
################################
source("cfg.r")
	
maxY = 2

################################
## plotting function	      ##
################################
compModelCatigory <- function(dat, addXaxis = FALSE, addYaxis = FALSE, ModelSplit) {	
	################################################
	## Grab params  						      ##
	################################################
	compName = dat[[1]]
	scores   = dat[[2]]
	nAxis    = length(ModelSplit)
	c(nullMean, nullRRMN, nullRRVR, modScores) := deconstruct.csv.outs(scores)
	
	allScores = c(modScores, nullMean, nullRRMN + nullRRVR)
	minY = min(allScores, na.rm = TRUE)
	maxY = max(allScores, na.rm = TRUE)
	
	if ((maxY - minY) > 2) log = 'y' else log = ''
	################################################
	## set up plot frame					      ##
	################################################
	plot(c(0.8, nAxis + 0.2), c(minY, maxY), type = 'n', yaxt = 'n', xaxt = 'n', xlab = '', log = log)
	mtext(compName)
	if (addXaxis) labels = names(ModelSplit) else labels = rep('', nAxis)
	axis(1, at = 1:nAxis, labels = labels, las = 2)
	
	if (addYaxis) axis(2)
	
	################################################
	## Add Null Models 						      ##
	################################################
	
	nullLine <- function(y, ...) lines(c(0, nAxis), c(y, y), ...)
	
	nullLine(nullMean)
	nullLine(nullRRMN - nullRRVR, col = 'grey', lty = 2)
	nullLine(nullRRMN + nullRRVR, col = 'grey', lty = 2)
	nullLine(nullRRMN, col = 'grey')	
	
	################################################
	## Plot Catigories 						      ##
	################################################
	plotCat <- function(info, x, ys, offset, boxLab = NULL) {
		cats = unique(info)
		cols = colourSelectFun(cats)
		x = x + offset
		
		catPnt <- function(FUN) sapply(cats, function(i) FUN(ys[info==i]))
		catMean = catPnt(mean)
		catMin  = catPnt(min)
		catMax  = catPnt(max)
		
		
		x = seq(x - 0.02, x + 0.02, length.out = length(cats))
		points(x, catMean, col = cols, pch = 19)
		
		addLines <- function(x, mn, mx, col) {
			lines(c(x, x), c(mn, mx), col = col)
			lines(c(x - 0.01, x + 0.01), c(mn, mn), col = col)
			lines(c(x - 0.01, x + 0.01), c(mx, mx), col = col)
		}
		
		mapply(addLines, x, catMin, catMax, cols)
		
		#points(rep(, length(ys)), ys, col = cols, pch = 19)
		
		#cols = sapply(info, function(i) catCols[which(cats == i)])
		
		
		
	}
	
	plotStep <- function(stepN, offset) {		
		score = as.numeric(scores[, stepN])
		mapply(plotCat, ModelSplit, 1:nAxis, MoreArgs = list(score, offset, NULL))
	}
	
	steps = 3:ncol(scores)
	if (length(steps) == 3) offsets = c(-0.2, 0, 0.2)
	else if (length(steps) == 1) offsets = 0
	else browser()
	
	mapply(plotStep, steps, offsets)
	
}

#############################
## Open                    ##
#############################
dat = c()
files = list.files('outputs/',  full.names = TRUE)
files = files[grep('.csv', files)]
for (i in files) dat = c(dat, open.csvOutFile(i))


plotSpit <- function(ModelSplit, name) {
	#############################
	## setup plot              ##
	#############################
	nplots = length(dat)
	nplotsX = floor(sqrt(nplots))
	nplotsY = ceiling(sqrt(nplots))
	
	if (nplots > (nplotsX * nplotsY)) nplotsX = nplotsX + 1
	nplotsY = nplotsY + 1

	fname = paste("figs/catigoryScores", name, "pdf", sep = '.')
	pdf(fname, height = nplotsX * 4, width = nplotsY * 2.9)

	lmat = t(matrix(1:(nplotsX *nplotsY), nrow = nplotsY))
	lmat[lmat > nplots] = 0.0
	lmat[nplotsX, ] = nplots
	layout(lmat)
	par(mar = c(1, 3, 2, 0), oma = c(1, 2, 1,0))

	#############################
	## perform analysis        ##
	#############################
	addYaxis = addXaxis = rep(FALSE, nplots)
	addYaxis[seq(1, nplots, nplotsY)] = TRUE
	addXaxis[(nplots - nplotsX):nplots] = TRUE
	addYaxis = TRUE

	mapply(compModelCatigory, dat, addXaxis, addYaxis, MoreArgs = list(ModelSplit = ModelSplit))

	

	#############################
	## add legend		       ##
	#############################
	addLegends <- function(cats, y, title) {
		cats = unique(cats)
		cols = colourSelectFun(cats)
		
		legend(x = 0.5, xjust = 0.5, y = y, legend = cats, title = title,
			   horiz = TRUE, pch = 19, col = cols, xpd = TRUE, bty = 'n', lwd = 1, lty = 1)
		
	}

	plot.new()
	ys = seq(0.9, 0.1, length.out =length(ModelSplit))
	mapply(addLegends, ModelSplit, ys, names(ModelSplit))
	
	#############################
	## Turn off   		       ##
	#############################
	dev.off.gitWatermarkStandard()
}

mapply(plotSpit, ModelSplits, names(ModelSplits))