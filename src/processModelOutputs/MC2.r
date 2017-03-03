process.MC2 <- function(...) {
	dat = process.default(...)
	removeNaN <- function(i) {
		i[is.na(i)] = 0.0
		return(i)
	}
	dat = memSafeFunction(dat, removeNaN)
	return(dat)
}