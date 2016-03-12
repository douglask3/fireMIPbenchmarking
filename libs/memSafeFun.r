memSafeFunction <- function(x, FUN, ...) {
    if (is.character(FUN)) FUN = match.fun(FUN)
    FUN2 = function(i) {
        l = FUN(i, ...)
        if(!is.raster(l)) return(l)
        l = writeRaster(l, file = memSafeFile())
    }

    x = layer.apply(x, FUN2)
    return(x)
}
