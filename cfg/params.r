ContactDetails = 'Douglas Kelley - douglas.i.kelley@gmail.com'

################################################################################
## Set Parameters                                                             ##
################################################################################
month_length = c(31,28,31,30,31,30,31,31,30,31,30,31)
experiment   = ''
mask_type    = 'common'

nRRs = 2
#res = 0.5

#openOnly          = FALSE
outputMetricFiles = TRUE
plotModMetrics    = FALSE
plotSummery       = FALSE

NMEmap_cols       = c('white', 'black')
NMEmap_qunatiles  = seq(0.2,0.8,0.2)

SeasonConcCols    = c('white', '#FF00FF', '#000022')
SeasonConcDcols   = c('#8e0152','#c51b7d','#de77ae','#f1b6da','#fde0ef','#f7f7f7','#e6f5d0','#b8e186','#7fbc41','#4d9221','#276419')#c('green', 'white', 'red')
SeasonConcLimits  = c(0, 0.2, 0.4, 0.6, 0.8)
SeasonConcDlimits = c(-0.5, -0.2, -0.1, -0.05, 0.05, 0.1, 0.2, 0.5)

SeasonPhaseCols    = c('blue','cyan','red', 'orange', 'blue')
SeasonPhaseDcols   = c("#660066","#0000FF",'white','#FF0000', "#660066")
SeasonPhaseLimits  = 0:11
SeasonPhaseDlimits = -5.5:5.5
################################################################################
## Paths                                                                      ##
################################################################################
setupProjectStructure()
graphics.off()
data_dir.ModelOutputs  = 'data/ModelOutputs/'
data_dir.BenchmarkData = 'data/benchmarkData/'
outputs_dir.modelMasks = paste(outputs_dir, 'modelMasks', sep = '/')
