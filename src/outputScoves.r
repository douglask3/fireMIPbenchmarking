outputScores <- function(comp, name, info) {

    MPD_test = !sapply(comp, is.null)
    MPD_test = sapply(comp[MPD_test],
                      function(i) grepl('MPD', i[[1]]$call[1]))
    if (length(MPD_test) !=0 && MPD_test[1]) n = c(6,4)
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
    return(scores)
}

beautifyOutScore <- function(scores) {
    rownames(scores) = Model.plotting[,1]

    if (ncol(scores) == 10) {
        cnames = paste('concentration',1:3, sep = '')
        cnames = c(paste('mean'  , c('phase', cnames), sep = '.'),
                   paste('random', c('phase', 'concentration'), sep = '.'),
                   paste('models', c('phase', cnames), sep = '.'))

        colnames(scores) = cnames
    } else if (ncol(scores) == 5) {
        colnames(scores) = c('mean', 'random',
                             'step1', 'step2', 'step3')
    } else if (ncol(scores) == 3){
        colnames(scores) = c('mean', 'random', 'model')
    } else {
        warning('unknow amount of column scores. Column names not added')
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
