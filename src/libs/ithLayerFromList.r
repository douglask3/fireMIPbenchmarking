ithLayerFromList <- function(x, n = 1) {
	x = lapply(x, function(i) i[[n]])
	return(list2layers(x))
}