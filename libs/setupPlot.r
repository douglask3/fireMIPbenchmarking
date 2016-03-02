setupPlot <- function(name, nrow, ncol,
                      height = rep(1, nrow), width = rep(1, ncol),
                      scaleWidth = 4,  height2width = 1, ...) {
    name = paste(figs_dir, paste(name, '.pdf', sep = ""), sep = "/")
    pdf(name, width = scaleWidth * sum(width),
        height = height2width * scaleWidth * sum(height))

    mLayout = matrix(1:(nrow * ncol), ncol = nrow, nrow = ncol)
    layout(t(mLayout), height = height, width = width)
    par(...)
    return(name)
}
