cropBothWays <- function(obs, mod) {
    index = !sapply(mod, is.null)
    modi = mod[index]

    for (i in modi) obs = memSafeFile.crop(obs, i)

    cropFun <- function(i, ...) {
        if (nlayers(i) == 1) return(memSafeFile.crop(i[[1]], obs))
        return(memSafeFile.crop(i, obs))
    }

    modi = lapply(modi, cropFun, obs)

    mod[index] = modi
    return(list(obs, mod))
}
