################################################################################
## Install Packages                                                           ##
################################################################################
library(benchmarkMetrics)
library(gitBasedProjects)

################################################################################
## Paths                                                                      ##
################################################################################
setupProjectStructure()
modelDir = 'data/ModelOutputs'

################################################################################
## Model Information                                                          ##
################################################################################

Model.RAW = data.frame(      #DIR                 #Processing
            CLM      = c('CLM'               , process.CLM     ),
            CTEM     = c('CTEM'              , process.CTEM    ),
            INFERNO  = c('inferno'           , process.inferno ),
            JSBACH   = c('JSBACH'            , process.jsbach  ),
            LPJglob  = c('LPJ-GUESS-GlobFIRM', process.lpj     ),
            LPJspit  = c('LPJ-GUESS-SPITFIRE', process.lpj     ),
            ORCHIDEE = c('ORCHIDEE'          , process.orchidee))

Model.plotting = data.frame( #Title            #Colour
            CLM      = c('CLM'               , 'red'     ),
            CTEM     = c('CTEM'              , 'green'   ),
            INFERNO  = c('inferno'           , 'blue'    ),
            JSBACH   = c('JSBACH'            , 'yellow'  ),
            LPJglob  = c('LPJ-GUESS-GlobFIRM', 'cyan'    ),
            LPJspit  = c('LPJ-GUESS-SPITFIRE', 'magenta' ),
            ORCHIDEE = c('ORCHIDEE'          , 'black'   ))
