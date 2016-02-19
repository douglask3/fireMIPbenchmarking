################################################################################
## Install Packages                                                           ##
################################################################################
library(benchmarkMetrics)
library(gitBasedProjects)
sourceAllLibs()

################################################################################
## Paths                                                                      ##
################################################################################
setupProjectStructure()
data_dir.ModelOuutputs = 'data/ModelOutputs'
data_dir.BenchmarkData = '~/Documents2/lpxBenchmarking/data/benchmarkData/'

################################################################################
## Model Information                                                          ##
################################################################################

Model.RAW = list(      #DIR                 #Processing
            CLM      = c('CLM'               , process.CLM     ),
            CTEM     = c('CTEM'              , process.CTEM    ),
            INFERNO  = c('inferno'           , process.inferno ),
            JSBACH   = c('JSBACH'            , process.jsbach  ),
            LPJglob  = c('LPJ-GUESS-GlobFIRM', process.lpj     ),
            LPJspit  = c('LPJ-GUESS-SPITFIRE', process.lpj     ),
            ORCHIDEE = c('ORCHIDEE'          , process.orchidee))

Model.plotting = list( #Title            #Colour
            CLM      = c('CLM'               , 'red'     ),
            CTEM     = c('CTEM'              , 'green'   ),
            INFERNO  = c('inferno'           , 'blue'    ),
            JSBACH   = c('JSBACH'            , 'yellow'  ),
            LPJglob  = c('LPJ-GUESS-GlobFIRM', 'cyan'    ),
            LPJspit  = c('LPJ-GUESS-SPITFIRE', 'magenta' ),
            ORCHIDEE = c('ORCHIDEE'          , 'black'   ))


################################################################################
## Comparison Info                                                            ##
################################################################################

## Plotting ##
BurntArea.Spacial = list(cols    = c('white',"#EE8811","#FF0000", "#110000"),
                         dcols   = c('#0000AA','#2093FF','#C0D0FF','white',
                                        '#FFD793',"#F07700","#AA0000"),
                         limits  = c(0.001,.01,.02,.05,.1,.2),
                         dlimits = c(-0.2,-0.1,-0.5,-0.01,0.01,0.05,0.1, 0.2))


## Full comparisons info ##
BurntArea.Spacial = list(obsFile       = "Fire_GFEDv4_Burnt_fraction_0.5grid9.nc",
                         obsVarname    = "mfire_frac",
                         obsLayers     = 8:127,
                         ComparisonFun = FullNME,
                         plotArgs      = BurntArea.Spacial)


## Comparisons to be performed
comparisonList <- named.list(BurntArea.Spacial)
