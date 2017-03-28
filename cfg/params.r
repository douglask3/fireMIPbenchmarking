################################################################################
## Set Parameters                                                             ##
################################################################################
month_length = c(31,28,31,30,31,30,31,31,30,31,30,31)
experiment   = ''
mask_type    = 'common'
nRRs = 2

plotModNMEs      = FALSE
NMEmap_cols      = c('white', 'black')
NMEmap_qunatiles = seq(0.2,0.8,0.2)
################################################################################
## Paths                                                                      ##
################################################################################
setupProjectStructure()
graphics.off()
data_dir.ModelOutputs  = 'data/ModelOutputs'
data_dir.BenchmarkData = 'data/benchmarkData/'
outputs_dir.modelMasks = paste(outputs_dir, 'modelMasks', sep = '/')
