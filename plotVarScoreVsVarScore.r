################################
## cfg   				      ##
################################
source("cfg.r")
graphics.off()
	
maxY   = 2
nplots = length(scores)

colourSelectFun <- function(cats)
		rainbow(length(cats))
		
#############################
## Open                    ##
#############################
dat = c()
files = list.files('outputs/',  full.names = TRUE)
files = files[grep('.csv', files)]
for (i in files) dat = c(dat, open.csvOutFile(i))
scores = lapply(dat, function(i) deconstruct.csv.outs(i[[2]]))
nmes   = lapply(dat, function(i) i[[1]])


plotAvB <- function(A, Anm, nA, B, Bnm, nB) {
	if (is.matrix(A[[4]])) A[[4]] = A[[4]][,1]
	if (is.matrix(B[[4]])) B[[4]] = B[[4]][,1]
	
	scoresA = A[[4]]
	scoresB = B[[4]]
	
	mask = !is.na(scoresA + scoresB)
	scoresA = scoresA[mask]; scoresB = scoresB[mask]
	
	xrange = range(unlist(A), na.rm = TRUE)
	yrange = range(unlist(B), na.rm = TRUE)
	
	plot(xrange, yrange, type = 'n', xlab = '', ylab = '')	
	
	lines(c(A[[1]], A[[1]]), c(0, 9E9))
	lines(c(A[[2]], A[[2]]), c(0, 9E9), lty = 2)
	
	mnRR = A[[2]] - A[[3]]; mxRR = A[[2]] + A[[3]]
	polygon(c(mnRR, mnRR, mxRR, mxRR), c(0, 9E9, 9E9, 0), col = 'grey', border = NA)
	
	points(scoresA, scoresB)
	
	lines(c(0, 9E9), c(B[[1]], B[[1]]))
	lines(c(0, 9E9), c(B[[2]], B[[2]]), lty = 2)
	
	mnRR = B[[2]] - B[[3]]; mxRR = B[[2]] + B[[3]]
	polygon(c(0, 9E9, 9E9, 0), c(mnRR, mnRR, mxRR, mxRR), col = 'grey', border = NA)
	
	points(scoresA, scoresB)
	try(abline(lm(scoresA~scoresB), col="red"))
	r2 = round(cor(scoresA, scoresB)^2, 2)
	mtext(r2, side = 3, line = -3, adj = 0.9)
	
	if (nB == 1) mtext(Anm, side = 3, line = 2.5)
	if (nA == 1) mtext(Bnm, side = 2, line = 2.5)
	
	if (nB == nplots) mtext(Anm, side = 1, line = 2.5)
	if (nA == nplots) mtext(Bnm, side = 4, line = 2.5)
}


plotB <- function(scoresB, nmesB, nB) {
	mapply(plotAvB, scores, nmes, 1:nplots, MoreArgs = list(scoresB, nmesB, nB))
}
pdf('yay.pdf', height = 3*nplots, width = 3*nplots)
par(mfrow = c(nplots, nplots), mar = c(4, 4, 0, 0), oma = c(0, 0, 4, 4))
mapply(plotB, scores, nmes, 1:nplots)
dev.off()
