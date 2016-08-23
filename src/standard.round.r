standard.round <- function(x) sapply(x, standard.round.ind)

standard.round.ind <- function(x) {
	if (is.na(x)) 	return(x)
	ndig = find.ndig(x)
	if (ndig == 0)  return(signif(x,2))
	if (ndig == 1)  return(round(x,2))
	
					return(round(x))
}


find.ndig <- function(x) {
	i = 0
	while (x > 1) {x = x / 10; i = i + 1}
	return(i)
}
