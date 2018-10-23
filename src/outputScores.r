outputScores <- function(comp, name, info) {
	
    MET_test = !sapply(comp, is.null)
	MET_test = !sapply(comp, is.null)
    TYP_test <- function(TYP) sapply(comp[MET_test],
                      function(i) grepl(TYP, i[[1]]$call[1]))
    MPD_test = TYP_test('MPD')
    MM__test = TYP_test('MM' )
	OTR_test = !MM__test & !MPD_test
    if (length(MET_test) !=0 && MPD_test[1]) n = c(10,4, 12)
    else if (length(MET_test) !=0 && MM__test[1]) n = c(3,1,6)
    else n = c(3,3,6)

    extractScore <- function(FUN, n = 2) {
        null = rep('N/A', n)
        sapply(comp, function(i) {if(is.null(i)) return(null); FUN(i)})
    }
    nn = n
    null = extractScore(nullScores  , n[1])
    mods = extractScore(modelScores , n[2])
    mnvr = extractScore(meanVariance, n[3])
	
    scores =  t(rbind(null, mods))
    scores = beautifyOutScore(scores)
	
    if (!is.list(mnvr[1,1])) {
        scores = cbind(t(mnvr), scores)

        if (nrow(mnvr) == 12) {
            colnames(scores)[1:12] = c('obs mean phase'  , 'obs var phase'  ,
                                       'obs mean conc'   , 'obs var conc'   ,
                                       'sim mean phase'  , 'sim var phase'  ,
                                       'sim mean conc'   , 'sim var conc'   ,
                                       'ratio mean phase', 'ratio var phase',
                                       'ratio mean conc' , 'ratio var conc' )
        } else {
            colnames(scores)[1:6 ] = c('obs mean', 'obs var',
                                       'sim mean', 'sim var',
                                       'mean ratio', 'var ratio')
        }
    }
    file   = paste(outputs_dir, name, '.csv', sep = '-')
    write.csv(scores, file)
	
	
	
	comp = comp[MET_test] 
	
	sig = sapply(comp, function(i) sapply(comp, sigDiff, i, MM__test[[1]]))
	modNames =  Model.plotting[,1][MET_test]
	colnames(sig) = modNames
	
	if (nrow(sig) == length(modNames)) rownames(sig) = modNames
	else if(OTR_test && nrow(sig) == 3 * length(modNames)) rownames(sig) = unlist(lapply(modNames, function(i) paste(i, 'step', 1:3)))
	else rownames(sig) = unlist(lapply(modNames, function(i) paste(i, 'item', 1:(nrow(sig) / length(modNames)))))#browser()
	
	sig = round(sig, 2)
	file   = paste(outputs_dir, name, 'signfic-.csv', sep = '-')
    write.csv(sig, file)

    return(scores)
}

sigDiff <- function(m1, m2, MM_type = FALSE) {
	
	grabInfo <- function(m) {
		m = m[[1]][c('diff', 'w')]
		if (MM_type) 
			m = lapply(m, function(i) as.matrix(as.vector(i[, -ncol(i)])))
		return(m)
	}
			
	m1 = grabInfo(m1)
	m2 = grabInfo(m2)
	
	if (is.null(m1) || is.null(m2)) return(NULL)
	
	
	test <- function(m1i, m2i, w) {
		sc = wtd.t.test(m1i - m2i, weight = w)[[2]][3] * 100
	}
	if ( is.matrix(m1[[2]]) && ncol(m1[[2]]) == 1 && ncol(m1[[1]]) > 1)
		m1[[2]] = sapply(1:3, function(i) m1[[2]])
	sapply(1:ncol(m1[[1]]), function(i) test(m1[[1]][,i], m2[[1]][,i], m1[[2]][,i]))
}



beautifyOutScore <- function(scores) {
    rownames(scores) = Model.plotting[,1]
	
    if (ncol(scores) == 14) {
        cnames = paste('concentration',1:3, sep = '')
        cnames = c(paste('median'  , c('phase', cnames), sep = '.'),
			       paste('mean'  , c('phase', cnames), sep = '.'),
                   paste('random', c('phase', 'concentration'), sep = '.'),
                   paste('models', c('phase', cnames), sep = '.'))

        colnames(scores) = cnames
    } else if (ncol(scores) == 6) {
        colnames(scores) = c('median', 'mean', 'random',
                             'step1', 'step2', 'step3')
    } else if (ncol(scores) == 4){
        colnames(scores) = c('mediam', 'mean', 'random', 'model')
    } else {
        warning('unknow amount of column scores. Column names not added')
    }
    return(scores)
}


nullScores <- function(comp) {
    comp = summary(comp[[2]])
    if (length(comp[[1]]) == 1) {
        comp = standard.round(comp)
        comp[3] = paste(comp[3:4], collapse = ' +/- ')
        comp = comp[1:3]
    } else {
        comp = lapply(comp, standard.round)
        comp = c(comp[[1]], comp[[2]], paste(comp[[3]], '+/-', comp[[4]]))
    }
    return(comp)
}


modelScores <- function(comp)
    standard.round(score(comp[[1]]))

meanVariance <- function(comp) {
    summ = summary(comp[[1]])
    if (summ[[1]] == "Phase & Concentration") {
        Phase = summ[[4]]; Conc = summ[[3]]
        tab = rbind(Phase[2:4], Phase[5:7],
                    Conc [2:4], Conc [5:7])
        colnames(tab) = c('x','y','x:y')
        rownames(tab) = c('phase.mean', 'phase.var', 'conc.mean', 'conc.var')
    } else {
        tab = rbind(mean     = summ[2:4],
                    variance = summ[5:7])
    }
    return(tab)
}
