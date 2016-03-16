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
library(plotrix)
sourceAllLibs('../gitProjectExtras/gitBasedProjects/R/')
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
data_dir.ModelOutputs  = 'data/ModelOutputs'
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
            LPJblze  = c('LPJ-GUESS-BLAZE'   , process.default , 1950),
            MC2      = c('MC2'               , process.default , 1950),
            ORCHIDEE = c('ORCHIDEE'          , process.orchidee, 1950))


Model.Variable = list( #Line 1  variable name; Line 2  scaling; Line 3 - timestep
            varname  = rbind(c("BurntArea", "lifeForm"     , "gpp"    , "ModelMask"),
                             c(1          , 100            , 1/1000   , 1          ),
                             c('Monthly'  , 'Annual'       , 'Annual' , "Monthly"  ),
                             c('mean'     , 'sum'          , "sum"    , "sum"      )),
            CLM      = rbind(c("BAF"      , "NULL"         , "gpp"    , "cSoilt"   ),
                             c(1          , 1              , 1        , 1          ),
                             c('Daily'    , 'Annual'       , 'Monthly', "Monthly"  )),
            CTEM     = rbind(c("burntArea", "landCoverFrac", "gpp"    , "cSoil"    ),
                             c(100        , 1              , 1        , 1          ),
                             c('Monthly'  , 'Annual'       , 'Annual' , "Monthly"  )),
            INFERNO  = rbind(c("burntArea", "landCoverFrac", "gpp"    , "cSoil"    ),
                             c(100        , 1              , 1        , 1          ),
                             c('Monthly'  , 'Monthly'      , 'Annual' , "Monthly"  )),
            JSBACH   = rbind(c("NULL"     , "NULL"         , "NULL"   , "npp"      ),
                             c(100        , 1              , 1        ,1           ),
                             c('Monthly'  , 'Annual'       , 'Daily'  , "Monthly"  )),
            LPJglob  = rbind(c("burntArea", "NULL"         , "NULL"   , "ra"       ),
                             c(100        , 1              , 1        , 1          ),
                             c('Annual'   , "Annual"       , 'Daily'  , "Monthly"  )),
            LPJspit  = rbind(c("burntAreaMonthly",
                                            "NULL"         , "NULL"   , "npp_WWF"  ),
                             c(100        , 1              , 1        , 1          ),
                             c('Monthly'  , "Annual"       , 'Daily'  , "Monthly"  )),
            LPJblze  = rbind(c("NULL"     , "NULL"         , "NULL"   , "cSoil"    ),
                             c(100        , 1              , 1        , 1          ),
                             c('Monthly'  , 'Annual'       , 'Daily'  , "Annual"   )),
            MC2      = rbind(c("BA"       , "NULL"         , "NULL"   , "tas"      ),
                             c(100        , 1              , 1        , 1          ),
                             c('Annual'   , 'Annual'       , 'Daily'  , "Annual"  )),
            ORCHIDEE = rbind(c("meanFire" , "NULL"         , "NULL"   , "intensFire"),
                             c("Ha"       , 1              , 1        , 1          ),
                             c('Monthly'  , 'Annual'       , 'Daily'  , "Monthly" )))

Model.plotting = rbind( #Title            #Colour
            CLM      = c('CLM'               , 'red'        ),
            CTEM     = c('CTEM'              , 'green'      ),
            INFERNO  = c('inferno'           , 'blue'       ),
            JSBACH   = c('JSBACH'            , 'yellow'     ),
            LPJglob  = c('LPJ-GUESS-GlobFIRM', 'cyan'       ),
            LPJspit  = c('LPJ-GUESS-SPITFIRE', 'darkcyan'   ),
            LPJblze  = c('LPJ-GUESS-BLAZE'   , 'dodgerblue4'),
            MC2      = c('MC2'               , 'darkgoldenrod4' ),
            ORCHIDEE = c('ORCHIDEE'          , 'magenta'    ))

################################################################################
## Comparison Info                                                            ##
################################################################################

## Plotting ##
BurntArea.Spacial = list(cols    = c('white', "#EE8811", "#FF0000", "#110000"),
                         dcols   = c('#0000AA', '#2093FF', '#C0D0FF','white',
                                        '#FFD793', "#F07700", "#AA0000"),
                         limits  = c(0.001,.01,.02,.05,.1,.2),
                         dlimits = c(-0.2,-0.1,-0.5,-0.01,0.01,0.05,0.1, 0.2))

BurntArea.IA      = list(x = 1997:2006)


################################################################################
## Plotting Info                                                              ##
################################################################################

Carbon                = list(cols    = c('white',"#CCCC11","#999900",
                                         "#001100"),
                             dcols   = c('#220044','#AA02AA','#FF99FF','white',
                                         '#FFFF99',"#AAAA02","#224400"),
                             limits  = c(0, 500, 1000, 5000, 10000),
                             dlimits = c(-10000, -5000, -1000, 1000, 5000, 10000))

Height                = list(cols    = c('white',"#BBBB00","#CCCC00",
                                         "#111100"),
                             dcols   = c('#000099','#0000FF','#CCCCFF','white',
                                        '#FFFF00',"#CCCC00","#444400"),
                             limits  = c(0.1, 1, 2, 5, 10)*2,
                             dlimits = c(-20, -10, -5, -2, 2, 5, 10, 20))

fAPAR.spacial         = list(cols    = c('white',"#AAFFAA","#00FF00",
                                         "#001100"),
                             dcols   = c('#0000AA','#9302FF','#D0C0FF','white',
                                        '#D7FF93',"#77F000","#00AA00"),
                             limits  = c(.05, .1, .2, .4, .6),
                             dlimits = c(-0.4,-0.2,-0.1,0.1,0.2,0.4))

fAPAR.ia              = list(x = 1998:2005)

VegComparison         = list(cols    = c('white',"#88EE11","#00FF00",
                                         "#001100"),
                             dcols   = c('#AA0000','#FF9320','#FFD0C0','white',
                                        '#D7FF93',"#77F000","#00AA00"),
                             limits  = c(1, 2, 5, 10, 20, 50),
                             dlimits = c(-20,-10,-5, 5, 10, 20))

NPP                   = list(cols    = c('white',"#DDDD00","#33EE00",
                                         "#001100"),
                             limits  = c(100, 200, 400, 600, 1000),
                             xlab    = 'observed NPP (gC/m2)',
                             ylab    = 'simulated NPP (gC/m2)')

GPP                   = list(cols    = c('white',"#00F3CC","#00EE33",
                                         "#001100"),
                             limits  = c(200, 400, 600, 1000, 1500, 2000),
                             xlab    = 'observed GPP (gC/m2)',
                             ylab    = 'simulated GPP (gC/m2)')




## Full comparisons info ##
BurntArea.Spacial = list(obsFile       = "Fire_GFEDv4_Burnt_fraction_0.5grid9.nc",
                         obsVarname    = "mfire_frac",
                         obsLayers     = 8:127,
                         obsStart      = 1996,
                         ComparisonFun = FullNME,
                         plotArgs      = BurntArea.Spacial,
                         ExtraArgs     = list(mnth2yr = TRUE))

BurntArea.IA      = list(obsFile       = "Fire_GFEDv4_Burnt_fraction_0.5grid9.nc",
                         obsVarname    = "mfire_frac",
                         obsLayers     = 8:127,
                         obsStart      = 1996,
                         ComparisonFun = FullNME,
                         plotArgs      = BurntAreaIA.plot,
                         ExtraArgs     = list(byZ = TRUE, nZ = 12))

BurntArea.Season  = list(obsFile       = "Fire_GFEDv4_Burnt_fraction_0.5grid9.nc",
                         obsVarname    = "mfire_frac",
                         obsLayers     = 8:127,
                         obsStart      = 1996,
                         ComparisonFun = FullSeasonal,
                         plotArgs      = TRUE)

lifeForm          = list(obsFile       = "veg_cont_fields_CRU.nc",
                         obsVarname    = c("Tree_cover", "Herb"),
                         ComparisonFun = FullMM,
                         plotArgs      = VegComparison,
                         ExtraArgs     = list(extraItem = 100,
                                              itemNames = c('Tree', 'Herb', 'Bare')))




ModelMask         = list(obsFile       = "Fire_GFEDv4_Burnt_fraction_0.5grid9.nc",
                         obsVarname    = "mfire_frac",
                         obsLayers     = 8,
                         obsStart      = 1996,
                         ComparisonFun = maskComparison,
                         allTogether   = TRUE)


## Comparisons to be performed
comparisonList <- named.list(BurntArea.Season, BurntArea.IA, BurntArea.Spacial, ModelMask)

runComparisons(comparisonList)
