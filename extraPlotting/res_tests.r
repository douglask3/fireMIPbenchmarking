source("cfg.r")
graphics.off()
names = 'fire'

comparisons = list(c("GFED4s.Spatial"))

temp_file = 'temp/resExperiment.Rd'

res = list(c(2.5, 1.875), 2.8125, c(1.875, 1.25), 1.875, 0.5)
openOnly = FALSE

if (file.exists(temp_file)) {
    load(temp_file) 
} else {
    source('run.r')
    save(out, file = temp_file)
}

out = out[[1]]

extractScore <- function(x) {
    x = x[[4]]
    extractMod <- function(mod) {
        s3 = score(mod[[1]])[3]
        RR = mod[[2]][[3]]
        return(list(s3, RR))
    }
    out = lapply(x, extractMod)
    
    scores = sapply(out, function(i) i[[1]])
    RR = sapply(out, function(i) i[[2]])
    
    return(list(scores, mean(RR), sd(RR)))
}

scores = sapply(out, extractScore)

modScores = (unlist(scores[1,]))

res = list(c(2.5, 1.9), 2.8125, c(1.875, 1.245), 1.875, 0.5)

nms = sapply(sapply(res, as.character), paste, collapse = ', ')
#nms = sapply(nms, function(i) c(rep('', 4), i, rep('', 4)))
png('figs/res_test_new.png', height = 6, width = 7, res = 300, units = 'in')
layout(rbind(1, 2), heights = c(1, 0.3))
par(mar = c(2, 4, 0, 0))
names(modScores) = NULL
space =  rep(c(1,rep(0.1, 8)), 5)
space =  c(1.0,rep(0.0, 8))
cols = Model.plotting[,2]
barplot(modScores, width = 1, space = space, col = cols, ylim = c(0.5, 1.3), xpd = FALSE, axes = FALSE)
axis(2, at = seq(0.5, 1.2, 0.1))
mtext(side = 2, line = 2, 'Score')
axis(1, at = seq(5, 45, 10), labels = nms)
lines(c(0.5, 49.5), c(1, 1))

RRmean = unlist(scores[2,])
RRsd = unlist(scores[3,])

addRR <- function(RRmean, RRsd, x) {
    x = x + c(0.5, 9.5)
    lines(x, c(RRmean, RRmean))
    lines(x, c(RRmean, RRmean) - RRsd, lty = 2)
    lines(x, c(RRmean, RRmean) + RRsd, lty = 2)
}

mapply(addRR, RRmean, RRsd, seq(0, 40, 10))
text(x = 2, y = 1.15, 'Randomly-Resampled', adj  = 0.1)
text(x = 0.8, y = 1.02, 'Mean', adj  = 0.0)
par(mar = rep(0,4))
plot.new()
legend('top', ncol = 3, legend = Model.plotting[,1], pt.cex = 2.2, col = 'black', pch = 15, bty = 'n')
legend('top', ncol = 3, legend = Model.plotting[,1], pt.cex = 2, col = cols, pch = 15, bty = 'n')
#outs = lapply(ress, runAtRes)
dev.off()
