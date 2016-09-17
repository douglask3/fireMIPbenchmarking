dev.off.annotate <- function(...) {
    addPlotTitle(...)
    dev.off.gitWatermarkStandard()
}

addPlotTitle <- function(txt, x = 0.5, y = -0.05, cex = 1.33,...) {

    par(fig = c(0, 1, 0, 1), mar = rep(0, 4))
    usr = par('usr')

    x = usr[1] + diff(usr[1:2]) * x
    y = usr[3] + diff(usr[3:4]) * y

    text(x, y, txt, xpd = NA, cex = cex,...)
}

dev.off.gitWatermarkStandard <- function()
    dev.off.gitWatermark(x = 0.7, y = 0.1, srt = 0)
