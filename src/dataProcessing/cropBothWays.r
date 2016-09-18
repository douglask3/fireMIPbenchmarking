cropBothWays <- function(obs, mod) {
    index = !sapply(mod, is.null)
    modi = mod[index]

    cropMe <- function(...) memSafeFile.crop(..., overwrite = TRUE)

    for (i in modi) obs = cropMe(obs, i)

    cropFun <- function(i, ...) {
        if (nlayers(i) == 1) return(cropMe(i[[1]], obs))
        return(cropMe(i, obs))
    }

    modi = lapply(modi, cropFun, obs)

    mod[index] = modi
    return(list(obs, mod))
}
