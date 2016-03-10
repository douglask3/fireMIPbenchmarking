outputScoves <- function(comp, name, info) {

    extractScore <- function(FUN, n = 2) {
        null = rep('N/A', n)
        sapply(comp, function(i) {if(is.null(i)) return(null); FUN(i)})
    }
    null = extractScore(nullScores , 2)
    mods = extractScore(modelScores, 3)

    scores =  t(rbind(null, mods))

    rownames(scores) = Model.plotting[,1]
    file = paste(outputs_dir, name, '.csv', sep = '-')

    write.csv(scores, file)
    return(file)
}


nullScores <- function(comp) {
    comp = summary(comp[[2]])

    comp = standard.round(comp)
    comp[2] = paste(comp[2:3], collapse = ' +/- ')

    return(comp[1:2])
}


modelScores <- function(comp) standard.round(score(comp[[1]]))
