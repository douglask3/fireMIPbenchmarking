combineLayers <- function(dat, combine) {
    nl = nlayers(dat)
    if (combine == "sum") FUN = mean else FUN = match.fun(combine)
    if (nl > 1 ) dat = FUN(dat)
    if (combine == "sum") dat = dat * nl
    dat = convert_pacific_centric_2_regular(dat)
    return(dat)
}
