SeasonLegend <- function(limits, cols, add = FALSE, plot_loc, dat, e_lims = NULL,
                         mnthLabs = 1:12,
                         mar = c(0,0,0,0),labR = 0.87,
                         MonLetters = c('J','F','M','A','M','J','J','A','S','O','N','D'),
						 xp = 1.0, yp = 0.13, radius = 0.11,
                         ...) {
    
    if (all(range(limits)==c(0,11))) {
        labelss = rep('', 12)
        labelss[mnthLabs] = MonLetters[mnthLabs]
        #mar[1] = mar[1]+1.5
        ncols = c(13,12)
        dang = 0
    } else {
        #labelss = limits[-1]
        #mar[4]=mar[4]+1
        labelss = limits + 0.5
        ncols=c(length(labelss)+1,length(labelss))
        dang = 180
    }
    cols = make_col_vector(cols,ncols=ncols[1])[1:ncols[2]]

    x = rep(1,length(cols))

	if (!add || !is.null(mar)) {
		mar0  = par("mar")
		par(mar = mar)
	}
	
	if (add) {
		par(usr = c(0,1,0,0.416666667))
		add.pie(x, xp, yp, col = cols, clockwise = TRUE,
		        init.angle = dang + 90 + 180/length(x),
				radius = radius, labels = labelss, xpd = TRUE)
		
	} else {  
		pie(x,col=cols,labels='',clockwise = TRUE, init.angle = dang + 90 + 180/length(x))
	
		angles = dang * pi/180 + head(seq(0,2*pi ,length.out=length(labelss)+1),-1)+pi/2

		pie.labels(0,0,angles,rev(labelss),radius=labR,xpd=NA)
	}
	
    if (!is.null(e_lims)) {
		if (!add) {
			xp = 0.0
			yp = 0.0
			radius = 0.8
		}
		
		x = seq(xp - radius, xp + radius, length.out = 30)
		y = seq(yp - radius, yp + radius, length.out = 30)
		e_radius = rev((seq(0, radius, length.out = length(e_lims) + 2))[-1])
		
		
		plot_elim <- function(er, cex, pch, col) {
			plotYs <- function(y) {
				xi = c(-1, 1) * sqrt(er^2 - (y  - yp)^2) + xp
				if (!is.na(diff(xi)) && diff(xi) != 0) {
					xh = x[x > xi[1] & x < xi[2]]
					points(xh, rep(y, length(xh)), cex = cex, pch = pch, col = col)
				}
			}
			lapply(y, plotYs)
		}
		
		
		mapply(plot_elim, e_radius, cex = c(0.0, 1.0, 1.5) * 0.25, pch = 16, col =  make.transparent('black', c(0.33, 0.33, 0.33)))
    }
    par(mar=mar0)
}

scale2MeanRange <- function(v, mn, rg) {
	v = v - min(v)	
	v = v / max(v)
	v = v - 0.5
	v = v * rg * 2 + mn
	return(v)
}
