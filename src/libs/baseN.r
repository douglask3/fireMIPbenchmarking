baseN <- function(i, N = 12) {
	i = i - N *floor(i / N)
	i[i == 0] = N
	return(i)
}