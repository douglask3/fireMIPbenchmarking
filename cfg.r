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

sourceAllLibs('src')

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
data_dir.BenchmarkData = '~/Documents2/lpxBenchmarking/data/benchmarkData/'
outputs_dir.modelMasks = paste(outputs_dir, 'modelMasks', sep = '/')

################################################################################
## Model Information                                                          ##
################################################################################

Model.RAW = list(      #DIR                 #Processing
            CLM      = c('CLM'               , process.CLM     ),
            CTEM     = c('CTEM'              , process.CTEM    ),
            INFERNO  = c('Inferno'           , process.INFERNO ),
            JSBACH   = c('JSBACH'            , process.default ),
            LPJglob  = c('LPJ-GUESS-GlobFIRM', process.default ),
            LPJspit  = c('LPJ-GUESS-SPITFIRE', process.default ),
            LPJblze  = c('LPJ-GUESS-BLAZE'   , process.default ),
            MC2      = c('MC2'               , process.default ),
            ORCHIDEE = c('ORCHIDEE'          , process.orchidee))
#Burnt area
# EMmission
# Carbon
# Production
# Veg Cover
Model.Variable = list( #Line 1  variable name; Line 2  scaling; Line 3 - timestep
            varname  = rbind(c("BurntArea", "lifeForm"     , "GPP"    , "ModelMask"),
                             c(1          , 100            , 1/1000   , 1          ),
                             c('Monthly'  , 'Annual'       , 'Annual' , "Monthly"  ),
                             c(1996       , 1992           , 1997     , 1996       ),
                             c('mean'     , 'mean'         , "sum"    , "sum"     )),
            CLM      = rbind(c("BAF"      , "landCoverFrac", "gpp"    , "cSoilt"   ),
                             c(100/30.4167, 1              , 1        , 1          ),
                             c(1700       , 1900           , 1        , 1996       ),
                             c('Monthly'  , 'Annual'       , 'Monthly', "Monthly"  ),
                             c(NA         , "2:9;10:16"    , NA       , NA        )),
            CTEM     = rbind(c("burntArea", "landCoverFrac", "gpp"    , "cSoil"    ),
                             c(100        , 1              , 1        , 1          ),
                             c(1859       , 1859           , 1        , 1996       ),
                             c('Monthly'  , 'Monthly'      , 'Annual' , "Monthly"  ),
                             c(NA         , '1:7;8:9'      , NA       , NA        )),
            INFERNO  = rbind(c("burntArea", "NULL"         , "gpp"    , "cSoil"    ),
                             c(1/(60*60*24*30), 1          , 1        , 1          ),
                             c(1700       , 1              , 1        , 1996       ),
                             c('Monthly'  , 'Monthly'      , 'Annual' , "Monthly"  ),
                             c(NA         , 1              , NA       , NA        )),
            JSBACH   = rbind(c("burntArea", "landCoverFrac", "NULL"   , "npp"      ),
                             c(1          , 1              , 1        , 1          ),
                             c(1700       , 1              , 1        , 1996       ),
                             c('Monthly'  , 'Annual'       , 'Daily'  , "Monthly"  ),
                             c(NA         , 1              , NA       , NA        )),
            LPJglob  = rbind(c("burntArea", "landCoverFrac", "NULL"   , "ra"       ),
                             c(100        , 1              , 1        , 1          ),
                             c(1700       , 1              , 1        , 1996       ),
                             c('Annual'   , "Annual"       , 'Daily'  , "Monthly"  ),
                             c(NA         , "3:11;1:2,12:19",NA       , NA        )),
            LPJspit  = rbind(c("burntAreaMonthly",
                                            "landCoverFrac", "NULL"   , "npp_WWF"  ),
                             c(100        , 1              , 1        , 1          ),
                             c(1700       , 1              , 1        , 1996       ),
                             c('Monthly'  , "Annual"       , 'Daily'  , "Monthly"  ),
                             c(NA         , "3:11;1:2,12:19",NA       , NA        )),
            LPJblze  = rbind(c("BA"       , "NULL"         , "NULL"   , "cSoil"    ),
                             c(100        , 1              , 1        , 1          ),
                             c(1700       , 1              , 1        , 1996       ),
                             c('Monthly'  , 'Annual'       , 'Daily'  , "Annual"   ),
                             c(NA         , "3:11;1:2,12:19",NA       , NA        )),
            MC2      = rbind(c("BA"       , "NULL"         , "NULL"   , "tas"      ),
                             c(100        , 1              , 1        , 1          ),
                             c(1901       , 1              , 1        , 1996       ),
                             c('Annual'   , 'Annual'       , 'Daily'  , "Annual"   ),
                             c(NA         , 1              , NA       , NA        )),
            ORCHIDEE = rbind(c("burntArea", "landCoverFrac", "NULL"   , "burntArea"),
                             c(100/30.4167, 1              , 1        , 1          ),
                             c(1950       , 1700           , 1950     , 1996       ),
                             c('Monthly'  , 'Annual'       , 'Daily'  , "Monthly"  ),
                             c(NA         , '2:9;10:13'    , NA       , NA        )))

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
BurntArea.Spatial = list(cols    = c('white', "#EE8811", "#FF0000", "#110000"),
                         dcols   = c('#0000AA', '#2093FF', '#C0D0FF','white',
                                        '#FFD793', "#F07700", "#AA0000"),
                         limits  = c(0.001,.01,.02,.05,.1,.2),
                         dlimits = c(-0.2,-0.1,-0.5,-0.01,0.01,0.05,0.1, 0.2))

BurntArea.IA      = list(x = 1997:2009)


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

fAPAR.Spatial         = list(cols    = c('white',"#AAFFAA","#00FF00",
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




##################################################################################
## Full comparisons info ##
BurntArea.Spatial = list(obsFile       = "Fire_GFEDv4_Burnt_fraction_0.5grid9.nc",
                         obsVarname    = "mfire_frac",
                         obsLayers     = 1:156,
                         ComparisonFun = FullNME,
                         plotArgs      = BurntArea.Spatial,
                         ExtraArgs     = list(mnth2yr = TRUE))

BurntArea.IA      = list(obsFile       = "Fire_GFEDv4_Burnt_fraction_0.5grid9.nc",
                         obsVarname    = "mfire_frac",
                         obsLayers     = 1:156,
                         ComparisonFun = FullNME,
                         plotArgs      = BurntArea.IA,
                         ExtraArgs     = list(byZ = TRUE, nZ = 12))

BurntArea.Season  = list(obsFile       = "Fire_GFEDv4_Burnt_fraction_0.5grid9.nc",
                         obsVarname    = "mfire_frac",
                         obsLayers     = 8:127,
                         ComparisonFun = FullSeasonal,
                         plotArgs      = TRUE)

lifeForm          = list(obsFile       = "veg_cont_fields_CRU.nc",
                         obsVarname    = c("Tree_cover", "Herb"),
                         ComparisonFun = FullMM,
                         plotArgs      = VegComparison,
                         ExtraArgs     = list(extraItem = 100,
                                              itemNames = c('Tree', 'Herb', 'Bare')))


## Height
Height            = list(obsFile       = "height_Simard.nc",
                         obsVarname    = "height",
                         ComparisonFun = FullNME,
                         plotArgs      = Height)

## NPP
NPP               = list(obsFile       = "NPP.csv",
                         obsVarname    = "csv",
                         obsLayers     = 1:9,
                         ComparisonFun = FullNME.site,
                         plotArgs      = NPP)

## GPP
GPP               = list(obsFile       = "GPP6.csv",
                         obsVarname    = "csv",
                         obsLayers     = 1:9,
                         ComparisonFun = FullNME.site,
                         plotArgs      = GPP)


## Fapar
fAPAR.Spatial     = list(obsFile       = "SeaWiFs_fapar_annual.nc",
                         obsVarname    = "fapar",
                         obsLayers     = 1:8,
                         ComparisonFun = FullNME,
                         plotArgs      = fAPAR.Spatial)

fAPAR.season     = list(obsFile       = 'SeaWiFS_fapar_monthly.nc',
                        obsVarname    = "fapar",
                        obsLayers     = NULL,
                        ComparisonFun = FullSeasonal,
                        plotArgs      = TRUE)



fAPAR.ia         = list(obsFile       = "SeaWiFs_fapar_annual.nc",
                        obsVarname    = "fapar",
                        obsLayers     = 1:8,
                        ComparisonFun = FullNME,
                        plotArgs      = fAPAR.ia,
                        ExtraArgs     = list(byZ = TRUE))




## Comparisons to be performed
comparisonList <- named.list(BurntArea.Season, BurntArea.IA, BurntArea.Spatial)
#comparisonList <- named.list(GPP, BurntArea.IA, BurntArea.Spatial, BurntArea.Season)

runComparisons(comparisonList)
