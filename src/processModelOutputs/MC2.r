process.MC2 <- function(...) {
	dat = process.default(..., amIMC2 = TRUE)
	if (is.null(dat)) return(dat)
	removeNaN <- function(i) {
		i[is.na(i)] = 0.0
		return(i)
	}
	dat = memSafeFunction(dat, removeNaN)
	return(dat)
}