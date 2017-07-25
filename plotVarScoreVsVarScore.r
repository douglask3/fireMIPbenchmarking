################################
## cfg   				      ##
################################
source("cfg.r")
graphics.off()
	
maxY   = 2

vars2test = c('cveg', 'GFED4s', 'NPP_', 'GFAS', 'NRfire')
stepN     = c(1     , 1       , 1     , 1     , 3       )
#############################
## Open                    ##
#############################
dat = c()
files = list.files('outputs/',  full.names = TRUE)
files = files[grep('.csv', files)]
for (i in files) dat = c(dat, open.csvOutFile(i))
scores = lapply(dat, function(i) deconstruct.csv.outs(i[[2]]))

nplots = length(scores)
nmes   = sapply(dat, function(i) i[[1]])

index = lapply(vars2test, grep, nmes)

stepN  = unlist(mapply(rep, stepN, sapply(index, length)))
index  = unlist(index)
scores = scores[index]
nmes   = nmes[index]

plotAvB <- function(A, Anm, stepA, nA, B, Bnm, stepB, nB) {
	if (is.matrix(A[[4]])) A[[4]] = A[[4]][,min(stepA, ncol(A[[4]]))]
	if (is.matrix(B[[4]])) B[[4]] = B[[4]][,min(stepB, ncol(B[[4]]))]
	
	scoresA = A[[4]]
	scoresB = B[[4]]
	MNB = B[[1]]; mnRRB = B[[2]] - B[[3]]; mxRRB = B[[2]] + B[[3]]
	MNA = A[[1]]; mnRRA = A[[2]] - A[[3]]; mxRRA = A[[2]] + A[[3]]
	
	mask = !is.na(scoresA + scoresB)
	scoresA = scoresA[mask]; scoresB = scoresB[mask]
	
	xrange = range(c(scoresA, MNA, mnRRA, mxRRA), na.rm = TRUE)
	yrange = range(c(scoresB, MNB, mnRRB, mxRRB), na.rm = TRUE)
	xrange = range(c(scoresA), na.rm = TRUE)
	yrange = range(c(scoresB), na.rm = TRUE)
	
	plot(xrange, yrange, type = 'n', xlab = '', ylab = '')	
	
	lines(c(A[[1]], A[[1]]), c(0, 9E9))
	lines(c(A[[2]], A[[2]]), c(0, 9E9), lty = 2)
	
	lines(c(0, 9E9), c(B[[1]], B[[1]]))
	lines(c(0, 9E9), c(B[[2]], B[[2]]), lty = 2)
	
	polygon(c(mnRRA, mnRRA, mxRRA, mxRRA), c(0, 9E9, 9E9, 0), col = 'grey', border = NA)
	polygon(c(0, 9E9, 9E9, 0), c(mnRRB, mnRRB, mxRRB, mxRRB), col = 'grey', border = NA)
	
	points(scoresA, scoresB)
	
	try(abline(lm(scoresB~scoresA), col="red"))
	r2 = round(cor(scoresA, scoresB)^2, 2)
	mtext(r2, side = 3, line = -3, adj = 0.9)
	
	if (nB == 1) mtext(Anm, side = 3, line = 2.5)
	if (nA == 1) mtext(Bnm, side = 2, line = 2.5)
	
	if (nB == nplots) mtext(Anm, side = 1, line = 2.5)
	if (nA == nplots) mtext(Bnm, side = 4, line = 2.5)
}


plotB <- function(scoresB, nmesB, nB, stepB)
	mapply(plotAvB, scores, nmes, stepN, 1:nplots, MoreArgs = list(scoresB, nmesB, nB, stepB))

pdf('figs/varVvar.pdf', height = 3*nplots, width = 3*nplots)
par(mfrow = c(nplots, nplots), mar = c(4, 4, 0, 0), oma = c(0, 0, 4, 4))
mapply(plotB, scores, nmes, stepN, 1:nplots)
dev.off.gitWatermarkStandard()
