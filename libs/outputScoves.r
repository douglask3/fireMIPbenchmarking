outputScores <- function(comp, name, info) {

    if (grepl('MPD',comp[[1]][[1]]$call[1])) n = c(6,4)
        else n = c(2,3)

    extractScore <- function(FUN, n = 2) {
        null = rep('N/A', n)
        sapply(comp, function(i) {if(is.null(i)) return(null); FUN(i)})
    }
    null = extractScore(nullScores , n[1])
    mods = extractScore(modelScores, n[2])

    scores =  t(rbind(null, mods))
    scores = beautifyOutScore(scores)

    file   = paste(outputs_dir, name, '.csv', sep = '-')
    write.csv(scores, file)
    return(file)
}

beautifyOutScore <- function(scores) {
    rownames(scores) = Model.plotting[,1]
    
    if (ncol(scores) == 10) {
        colnames(scores)[1:4] = paste('mean',c('phase', 'concentration1',
                                               'concentration2',
                                               'concentration3'), sep = '.')
        colnames(scores)[5:6] = paste('random',c('phase', 'concentration'),
                                      sep = '.')
    }

    return(scores)
}


nullScores <- function(comp) {
    comp = summary(comp[[2]])
    if (length(comp[[1]]) == 1) {
        comp = standard.round(comp)
        comp[2] = paste(comp[2:3], collapse = ' +/- ')
        comp = comp[1:2]
    } else {
        comp = lapply(comp, standard.round)
        comp = c(comp[[1]], paste(comp[[2]], '+/-', comp[[3]]))
    }
    return(comp)
}


modelScores <- function(comp)
    standard.round(score(comp[[1]]))
