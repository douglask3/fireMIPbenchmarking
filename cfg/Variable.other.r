# EMmission
# Carbon
# Production
# Veg Cover

Model.Variable = list( #Line 1  variable name; Line 2  scaling; Line 3 - timestep
            varname  = rbind(c("lifeForm"     , "GPP"    , "ModelMask"),
                             c(100            , 1/1000   , 1          ),
                             c('Annual'       , 'Annual' , "Monthly"  ),
                             c(1992           , 1997     , 1996       ),
                             c('mean'         , "sum"    , "sum"     )),
            CLM      = rbind(c("landCoverFrac", "gpp"    , "cSoilt"   ),
                             c(1              , 1        , 1          ),
                             c(1900           , 1        , 1996       ),
                             c('Annual'       , 'Monthly', "Monthly"  ),
                             c("2:9;10:16"    , NA       , NA        )),
            CTEM     = rbind(c("landCoverFrac", "gpp"    , "cSoil"    ),
                             c(1              , 1        , 1          ),
                             c(1859           , 1        , 1996       ),
                             c('Monthly'      , 'Annual' , "Monthly"  ),
                             c('1:7;8:9'      , NA       , NA        )),
            INFERNO  = rbind(c("NULL"         , "gpp"    , "cSoil"    ),
                             c(1          , 1        , 1          ),
                             c(1              , 1        , 1996       ),
                             c('Monthly'      , 'Annual' , "Monthly"  ),
                             c(1              , NA       , NA        )),
            JSBACH   = rbind(c("landCoverFrac", "NULL"   , "npp"      ),
                             c(1              , 1        , 1          ),
                             c(1              , 1        , 1996       ),
                             c('Annual'       , 'Daily'  , "Monthly"  ),
                             c(1              , NA       , NA        )),
            LPJglob  = rbind(c("landCoverFrac", "NULL"   , "ra"       ),
                             c(1              , 1        , 1          ),
                             c(1              , 1        , 1996       ),
                             c("Annual"       , 'Daily'  , "Monthly"  ),
                             c("3:11;1:2,12:19",NA       , NA        )),
            LPJspit  = rbind(c("landCoverFrac", "NULL"   , "npp_WWF"  ),
                             c(1              , 1        , 1          ),
                             c(1              , 1        , 1996       ),
                             c("Annual"       , 'Daily'  , "Monthly"  ),
                             c("3:11;1:2,12:19",NA       , NA        )),
            LPJblze  = rbind(c("NULL"         , "NULL"   , "cSoil"    ),
                             c(1              , 1        , 1          ),
                             c(1              , 1        , 1996       ),
                             c('Annual'       , 'Daily'  , "Annual"   ),
                             c("3:11;1:2,12:19",NA       , NA        )),
            MC2      = rbind(c("NULL"         , "NULL"   , "tas"      ),
                             c(1              , 1        , 1          ),
                             c(1              , 1        , 1996       ),
                             c('Annual'       , 'Daily'  , "Annual"   ),
                             c(1              , NA       , NA        )),
            ORCHIDEE = rbind(c("landCoverFrac", "NULL"   , "burntArea"),
                             c(1              , 1        , 1          ),
                             c(1700           , 1950     , 1996       ),
                             c('Annual'       , 'Daily'  , "Monthly"  ),
                             c('2:9;10:13'    , NA       , NA        )))


################################################################################
## Plotting Info                                                              ##
################################################################################
## Carbon
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




################################################################################
## Full comparisons info                                                      ##
################################################################################
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
