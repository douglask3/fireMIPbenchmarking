raster.ma <- function(r, ma = 12) {
	nl = nlayers(r)
	point.ma <- function(i) {
		print(i)
		index = i:(i+ma-1)
		out = mean(r[[index]])
		return(out)
	}			
	out = layer.apply(1:(nl - ma + 1), point.ma)
}