memSafeFunction <- function(x, FUN, ...) {
    if (is.character(FUN)) FUN = match.fun(FUN)
    FUN2 = function(i) {
        l = FUN(i, ...)
        if(!is.raster(l)) return(l)
        l = writeRaster(l, file = memSafeFile(), overwrite = TRUE)
    }

    x = layer.apply(x, FUN2)
    return(x)
}
