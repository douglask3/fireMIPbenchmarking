open.csvOutFile <- function(file) {
	scores = read.csv(file, stringsAsFactors = FALSE)
	cats   = colnames(scores)
	
	compName = strsplit(file, 'outputs/')[[1]][2]
	compName = strsplit(compName, '-')[[1]][2]
	
	testIndexUnique <- function(index) all(sapply(index, length) == 1)
	
	findMetricTypeScores <- function(indexs,nm) {
		index = lapply(indexs, grep, cats)
		if (nm !="") compName = paste(compName, nm, sep = '.')
		if (testIndexUnique(index))
			return(list(compName, scores[unlist(index)]))
		else invisible()
	}
	
	indexess = list(c("mean", "random", "step1", "step2", "step3"),
					c("mean", "random", "model"),
					c("mean.phase", "random.phase", "models.phase"),
					c("mean.concentration2", "random.concentration",
					  "models.concentration1", "models.concentration2",
 					  "models.concentration3"))
		
	nms = c("", "", "phase", "concentration")	
	out = mapply(findMetricTypeScores, indexess, nms)
	
	return(out[!sapply(out, is.null)])
}