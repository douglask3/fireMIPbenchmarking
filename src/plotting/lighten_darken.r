darken <- function(color, factor=1.4){
    col <- col2rgb(color)
    col <- col/factor
    col <- rgb(t(col), maxColorValue=255)
    col
}

invert.color <- function(color, factor=1.4){	
	col <- col2rgb(color)
	col = sqrt((255^2) - (col^2))
	col <- rgb(t(col), maxColorValue=255)
	return(col)
}

hue_shift <- function(color, shift = -1/6) {
	col = col2rgb(color)
	col = rgb2hsv(col)
	col[1,] = col[1,] + shift
	
	while (min(col[1,]) < 0 || max(col[1,]) > 1) {
		col[1,col[1,] > 1] = col[1,col[1,] > 1] - 1
		col[1,col[1,] < 0] = col[1,col[1,] < 0] + 1
	}
	#browser()
	col <- hsv(t(col))
	return(col)
}

lighten <- function(color, factor=1.4){
	col <- col2rgb(color)
	col = 255 - col
    col <- col/factor
	col = 255 - col
	col = rgb(t(col), maxColorValue=255)
	return(col)
	renormalise <- function(i) {
		p = 0
		while ( any(i>255) && p < 10) {
			test = i > 255
			if (all(test)) return(rep(255, length(i)))
			nrm = sum(i[test] - 255)
			i[!test] = i[!test] + nrm/sum(!test)
			i[test] = 255
			p = p + 1
			print(sum(i))
		}
		
		return(i)
	}
    #col <- rgb(t(as.matrix(apply(col, 1, function(x) if (x > 255) 255 else x))), maxColorValue=255)
    col = apply(col, 2, renormalise)
	browser()
	col = rgb(col)
}