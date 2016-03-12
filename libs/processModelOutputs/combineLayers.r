combineLayers <- function(dat, combine) {
    if (nlayers(dat) > 1 ) dat = match.fun(combine)(dat)
    dat = convert_pacific_centric_2_regular(dat)
    return(dat)
}
