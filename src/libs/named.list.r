# taken from http://stackoverflow.com/questions/17831015/r-list-from-variables-using-variable-names
named.list <- function(...) {
    l <- setNames( list(...) , as.character( match.call()[-1]) )
    l
}
