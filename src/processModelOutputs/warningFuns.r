multiNoFileWarnings <- function(...) {
    oneFileWarning(...)
    noFileWarning(...)
}

oneFileWarning <- function(x, varName)
    if (length(x) > 1) warning(paste('None-unique file for ', 'CLM',
                               ' - variable:', varName ,
                               '. First file selected', sep = ''))


noFileWarning <- function(x, varName) {
    if (length(x) == 0) {
        warnings(paste('No file found for ', 'CLM', ' - variable:', varName,
                       '. Model ignored for this variable'))
        return(TRUE)
    }
    return(FALSE)
}
