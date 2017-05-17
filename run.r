source('cfg.r')

runNamedComparison <- function(name, comps_name = NULL, ...) {
    fname = paste('cfg/Variable.', name, '.r', sep = "")
    source(fname); source(fname, local = TRUE)

    if (is.null(comps_name)) {
        comps_name = Model.Variable[[1]][1,]
        comps_name = ls()[apply(sapply(comps_name, grepl, ls()),1, any)]
    }
    comparisonList = lapply(comps_name, get)
    names(comparisonList) = comps_name
    #comparisonList = named.list(comps, ...)
    runComparisons(comparisonList)
}

if (!exists('comparisons') || is.null(comparisons)) comparisons = list(NULL)

out = mapply(runNamedComparison, names, comparisons)
