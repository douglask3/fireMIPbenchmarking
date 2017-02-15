process.MC2 <- function(...) {
	dat = process.default(...)
	removeNaN <- function(i) {
		i[is.na(i)] = 0.0
	}
	dat = memSafeFunction(dat, removeNaN)
	browser()
	return(dat)
}