is.True <- function(x) {
	test = is.logical(x)
    if (!test) return(FALSE)
	if(length(x) == 0) return(FALSE)
    return(x)
}
