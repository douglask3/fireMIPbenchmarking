list.files.patternPath <- function(path,...) {
    splittd = strsplit(path, '/')[[1]]
    pattern = tail(splittd, 1)
    path    = paste(head(splittd, -1), collapse = '/')
    return(list.files(path = path, pattern = pattern, ...))
}
