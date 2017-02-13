filename.noPath <- function(r, noExtension = FALSE) {
    fname = filename(r)
    fname = tail(strsplit(fname, '\\', fixed = TRUE)[[1]], 1)
    fname = tail(strsplit(fname, '/')[[1]], 1)
    if (noExtension)
        fname = paste(head(strsplit(fname, '.', TRUE)[[1]], -1), collapse = '.')

    return(fname)
}
