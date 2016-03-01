standardPlotDims <- function(n) {
    rt = sqrt(n)
    nc = floor(rt)
    nr = ceiling(rt)

    if ((nc * nr) < n) nc = nc + 1
    return(c(nr,nc))
}
