################################################################################
## Set Parameters                                                             ##
################################################################################
month_length = c(31,28,31,30,31,30,31,31,30,31,30,31)
experiment   = ''
mask_type    = 'common'
nRRs = 2
################################################################################
## Paths                                                                      ##
################################################################################
setupProjectStructure()
data_dir.ModelOutputs  = 'data/ModelOutputs'
data_dir.BenchmarkData = 'data/benchmarkData/'
outputs_dir.modelMasks = paste(outputs_dir, 'modelMasks', sep = '/')
