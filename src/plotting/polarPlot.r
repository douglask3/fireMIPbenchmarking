
polarPlot.setup <- function(x, y, xlim = NULL, ylim = xlim, type = 'l',pch = 19, cex = 2, ...) {
    
    if (type == 'l') {
        x = c(x, x[1])
        y = c(y, y[1])
    }
    x = 2 * pi * (x-0.5)/12
    yn = y * cos(x)
    xn = y * sin(x)
    x = xn; y = yn
    if (is.null(xlim)) xlim = ylim = max(abs(x), abs(y)) * c(-1, 1)
    
    plot(x, y, pch = pch, cex = cex, xlab = '', ylab = '', axes = FALSE, xlim = xlim, ylim = ylim, type = type,...)
}

polarPlot.image <- function(x, y, z, cols, ...) {
    x0 = x; y0 = y; z0 = z
    z = cols[z]
    z[is.na(z)] = "#000000"
    x = x
    x = x[-1] - diff(x)/2
    y = y[-1] - diff(y)/2
    xi = rep(x, length(y))
    yi = rep(y, each = length(x))
    
    #polarPlot.lines(xi, yi, col = z, pch = 19, cex = 10,..., FUN = points)  
    
    for (cex in seq(2.5, 0.1, -0.1))
        polarPlot.lines(xi, yi, col = z, pch = 19, cex = cex,..., FUN = points)  
    
}

polarPlot.points <- function(...) 
    polarPlot.lines(..., FUN = points)

polarPlot.lines <- function(x, y, ..., xlim = NULL, FUN = lines) {

    x = c(x, x[1])
    y = c(y, y[1])
    x = 2 * pi * (x-0.5)/12
    yn = y * cos(x)
    xn = y * sin(x)
    x = xn; y = yn
    
    FUN(x, y, ...)
     if (!is.null(xlim)) {
        polarPlot.polygon(seq(-6, 6, length.out = 200), rbind(rep(3000, 200), 6000),
                          col = "white", alpha = 0)
    }
}

polarPlot.polygon <- function(x, y, col = "black", alpha = 0.67, border = TRUE, ...) {
    x0 = x; y0 = y
    x = x- 0.5
    x = 2 * pi * x/12
    yn = apply(y, 1, function(i) i * cos(x))
    xn = apply(y, 1, function(i) i * sin(x)) 
    
    x = rbind(xn, xn[1, ]); y = rbind(yn, yn[1, ])
    xp = c(x[,1], rev(x[,2])); yp = c(y[,1], rev(y[,2]))
    polygon(xp, yp, border = NA, col = make.transparent(col, alpha), ...)
    if (border) {
        lines(x[,1], y[,1], col = col)
        lines(x[,2], y[,2], col = col)
    }
}

polarPlot.addGuides <- function(xlim = c(-1, 1), ylim = xlim, axisMonth = 0,
                                labScale = NULL, col = "black", bg.col = "white", nguides = 6,
                                labs =  c('J', 'F', 'M', 'A', 'M', 'J',
                                          'J', 'A', 'S', 'O', 'N', 'D'), 
                                labBG = TRUE, labOffset = 0) {
    for (i in seq(2, 4, 0.1)) {
        lines(c(0, 0), ylim/i, lwd = i, col = make.transparent(col, 0.9))
        lines(ylim/i, c(0, 0), lwd = i, col = make.transparent(col, 0.9))
    }
    
    if (is.null(labScale)) 
        at = seq(0, signif(xlim[2], 1), length.out = nguides)
    else
        at = seq(0, signif(labScale, 1), length.out = nguides)
    #browser()
    at = signif(at, 2)
    #at = at[at <= xlim[2]]
    labels = at
    
    if (!is.null(labScale)) at = at * xlim[2]/labScale
    
    mnths = 2 * pi *((0.5:11.5)/12) + labOffset
    xr = xlim[2] * sin(mnths) * 1.07
    yr = ylim[2] * cos(mnths) * 1.07
    text(x = xr, y = yr, lab = labs)
    
    addRadin <- function(mnths, ...) {
        xr = xlim[2] * sin(mnths) 
        yr = ylim[2] * cos(mnths) 
        mapply(function(i,j) lines(c(0, i), c(0, j), col = make.transparent(bg.col, 0.67), ...), xr, yr)
        mapply(function(i,j) lines(c(0, i), c(0, j), col = make.transparent(col, 0.67), lty = 2, ...), xr, yr)
    }
    addRadin(2 * pi *((0:12)/12))
    for (i in 1:4) addRadin(2 * pi *(c(2, 5, 8, 11)/12), lwd = 2)
    
    axisMonth = 2 * pi * (axisMonth + 0.5)/12
    addCirclegrid <- function(r, lab) {
        xr = r * sin(seq(0, 2*pi, 0.01) + axisMonth)
        yr = r * cos(seq(0, 2*pi, 0.01) + axisMonth)   
        lines(xr, yr, col =  make.transparent(bg.col, 0.33))
        lines(xr, yr, lty = 2,  col =  make.transparent(col, 0.33))
        if (r == 0) cex = 2 else cex = 4
        if (labBG) points(xr[1], yr[1], pch = 19, cex = cex, col =  bg.col)
        text(y = yr[1], x = xr[1], lab, col = col, xpd = NA)                
    }
    mapply(addCirclegrid, at, labels)
}

