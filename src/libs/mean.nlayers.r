mean.nlayers <- function(r) {
    if (nlayers(r) > 1) r = mean(r)
        else r = r[[1]]
    return(r)
}
