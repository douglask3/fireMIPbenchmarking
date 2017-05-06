deconstruct.csv.outs <- function(scores) {
	
	nullMean =  mean(as.numeric(scores[, 1]), na.rm = TRUE)
	nullRR   = scores[, 2]
	nullRR   = strsplit(nullRR, ' +/- ', fixed = TRUE)
	
	meanStr <- function(x, i) {
		x = sapply(x, function(j) j[i])
		x = mean(as.numeric(x), na.rm = TRUE)
		return(x)
	}
	
	nullRRMN = meanStr(nullRR, 1)
	nullRRVR = meanStr(nullRR, 2)
	modScores = sapply(scores[,-c(1:2)], as.numeric)
	
	return(list(nullMean, nullRRMN, nullRRVR, modScores))
}