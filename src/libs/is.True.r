is.True <- function(x) {
	test = try(is.logical(x), silent = TRUE)
	if (class(test) == "try-error") return(FALSE)
    if (!test) return(FALSE)
	if(length(x) == 0) return(FALSE)
    return(x)
}
