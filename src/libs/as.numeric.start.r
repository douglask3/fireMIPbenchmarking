as.numeric.start <- function(x)
    sapply(x, function(i) strsplit(i, ' ')[[1]][1])
