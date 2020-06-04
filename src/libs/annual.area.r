annual.area <- function(r, monthly2annual = TRUE) {
	nl = nlayers(r)
	out = sum(r)
	out = sum(values(out * raster::area(out)), na.rm = TRUE) / nl
	if (monthly2annual) out = out * 12
	out = out * 100/1000000
	return(out)
}