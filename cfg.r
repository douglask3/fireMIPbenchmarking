################################################################################
## Install Packages                                                           ##
################################################################################
library(benchmarkMetrics)
library(gitBasedProjects)
library(raster)
library(ncdf4)
library(rasterExtras)
library(rasterPlot)
library(mapdata)
sourceAllLibs()

################################################################################
## Set Parameters                                                             ##
################################################################################
month_length = c(31,28,31,30,31,30,31,31,30,31,30,31)
experiment   = 'SF1'
mask_type    = 'all'

################################################################################
## Paths                                                                      ##
################################################################################
setupProjectStructure()
data_dir.ModelOuutputs = 'data/ModelOutputs'
data_dir.BenchmarkData = '~/Documents2/lpxBenchmarking/data/benchmarkData/'
outputs_dir.modelMasks = paste(outputs_dir, 'modelMasks', sep = '/')

################################################################################
## Model Information                                                          ##
################################################################################

Model.RAW = list(      #DIR                 #Processing         # Start date
            CLM      = c('CLM'               , process.CLM     , 1996),
            CTEM     = c('CTEM'              , process.CTEM    , 1859),
            INFERNO  = c('inferno'           , process.INFERNO , 1900),
            JSBACH   = c('JSBACH'            , process.default , 1950),
            LPJglob  = c('LPJ-GUESS-GlobFIRM', process.default , 1950),
            LPJspit  = c('LPJ-GUESS-SPITFIRE', process.default , 1950),
            ORCHIDEE = c('ORCHIDEE'          , process.orchidee, 1950))


Model.Variable = list( #Line 1  variable name; Line 2  scaling; Line 3 - timestep
            varname  = rbind(c("BurntArea", "gpp"    , "ModelMask"),
                             c(1          , 1/1000   , 1          ),
                             c('Monthly'  , 'Annual' , "Monthly"  ),
                             c('mean'     , 'sum'    , "sum"      )),
            CLM      = rbind(c("BAF"      , "gpp"    , "cSoilt"   ),
                             c(1          , 1        , 1          ),
                             c('Daily'    , 'Monthly', "Monthly"  )),
            CTEM     = rbind(c("burntArea", "gpp"    , "cSoil"    ),
                             c(100        , 1        , 1          ),
                             c('Monthly'  , 'Daily'  , "Monthly"  )),
            INFERNO  = rbind(c("burntArea", "gpp"    , "cSoil"    ),
                             c(100        , 1        , 1          ),
                             c('Monthly'  , 'Daily'  , "Monthly"  )),
            JSBACH   = rbind(c("NULL"     , "NULL"   , "npp"      ),
                             c(100        , 1        , 1          ),
                             c('Monthly'  , 'Daily'  , "Monthly"  )),
            LPJglob  = rbind(c("NULL"     , "NULL"   , "ra"       ),
                             c(100        , 1        , 1          ),
                             c('Monthly'  , 'Daily'  , "Monthly"  )),
            LPJspit  = rbind(c("burntAreaMonthly",
                                            "NULL"   , "npp_WWF"  ),
                             c(100        , 1        , 1          ),
                             c('Monthly'  , 'Daily'  , "Monthly"  )),
            ORCHIDEE = rbind(c("meanFire" , "NULL"   , "intensFire"),
                             c("100"        , 1        , 1          ),
                             c('Monthly'  , 'Daily'  , "Monthly" )))

Model.plotting = rbind( #Title            #Colour
            CLM      = c('CLM'               , 'red'     ),
            CTEM     = c('CTEM'              , 'green'   ),
            INFERNO  = c('inferno'           , 'blue'    ),
            JSBACH   = c('JSBACH'            , 'yellow'  ),
            LPJglob  = c('LPJ-GUESS-GlobFIRM', 'cyan'    ),
            LPJspit  = c('LPJ-GUESS-SPITFIRE', 'darkcyan' ),
            ORCHIDEE = c('ORCHIDEE'          , 'magenta'   ))

################################################################################
## Comparison Info                                                            ##
################################################################################

## Plotting ##
BurntArea.Spacial = list(cols    = c('white', "#EE8811", "#FF0000", "#110000"),
                         dcols   = c('#0000AA', '#2093FF', '#C0D0FF','white',
                                        '#FFD793', "#F07700", "#AA0000"),
                         limits  = c(0.001,.01,.02,.05,.1,.2),
                         dlimits = c(-0.2,-0.1,-0.5,-0.01,0.01,0.05,0.1, 0.2))


## Full comparisons info ##
BurntArea.Spacial = list(obsFile       = "Fire_GFEDv4_Burnt_fraction_0.5grid9.nc",
                         obsVarname    = "mfire_frac",
                         obsLayers     = 8:127,
                         obsStart      = 1996,
                         ComparisonFun = FullNME,
                         plotArgs      = BurntArea.Spacial,
                         ExtraArgs     = list(mnth2yr = TRUE))

ModelMask         = list(obsFile       = "Fire_GFEDv4_Burnt_fraction_0.5grid9.nc",
                         obsVarname    = "mfire_frac",
                         obsLayers     = 8,
                         obsStart      = 1996,
                         ComparisonFun = maskComparison,
                         allTogether   = TRUE)


## Comparisons to be performed
comparisonList <- named.list(BurntArea.Spacial, ModelMask)

runComparisons(comparisonList)
