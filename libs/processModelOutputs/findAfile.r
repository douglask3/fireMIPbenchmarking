findAfile <- function(files, varName, sep = '.', warn = TRUE, returnAll = !warn) {
    if (is.null(varName)) return(NULL)
    varName = paste(varName, sep, sep = '')
    index = which(grepl(varName, files, fixed = TRUE))
    if (warn && multiNoFileWarnings(index, varName)) return(NULL)
    files = files[index]
    if (!returnAll) files = files[1]
    return(files)
}
