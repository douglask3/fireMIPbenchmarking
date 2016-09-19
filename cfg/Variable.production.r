# EMmission
# Carbon
# Production
# Veg Cover

#per second
Model.Variable = list( #Line 1  variable name; Line 2  scaling; Line 3 - timestep
            varname  = rbind(c("GPP"    , "NPP"     , "cveg"   ),
                             c(1/1000   , 1/1000    , 1        ),
                             c('Annual' , "Annual"  , "Monthly"),
                             c(1997     , 1997      , 1997     ),
                             c("sum"    , "sum"     , "mean"   )),
            CLM      = rbind(c("gpp"    , "npp"     , "cVeg"   ),
                             c(1        , 1         , 1        ),
                             c(1950     , 1950      , 1950     ),
                             c('Monthly', "Monthly" , "Monthly")),
            CTEM     = rbind(c("gpp"    , "npp"     , "cVeg"   ),
                             c(1        , 1         , 1        ),
                             c(1950     , 1950      , 1950     ),
                             c('Monthly', "Monthly" , "Monthly")),
            INFERNO  = rbind(c("gpp"    , "npp"     , "cVeg"   ),
                             c(1        , 1         , 1  ),
                             c(1950     , 1950      , 1950  ),
                             c('Monthly', "Monthly" , "Monthly"  )),
            JSBACH   = rbind(c("NULL"   , "NULL"    , "cVeg"   ),
                             c(1        , 1         , 1  ),
                             c(1950     , 1996      , 1950  ),
                             c('Monthly', "Monthly" , "Monthly"  )),
            LPJglob  = rbind(c("gpp"    , "npp"     ,  "cVeg"),
                             c(1        , 1         ,  1),
                             c(1950     , 1950      ,  1950),
                             c('Monthly', "Monthly" ,  "Annual")),
            LPJspit  = rbind(c("gpp"   , "npp"      ,  "cVeg"),
                             c(1        , 1         ,  1),
                             c(1950     , 1950      ,  1950),
                             c('Monthly', "Monthly" ,  "Annual")),
            LPJblze  = rbind(c("gpp"    , "npp"     ,  "cVeg"),
                             c(1        , 1         ,  1),
                             c(1950     , 1950      ,  1950),
                             c('Monthly', "Monthly" ,  "Annual")),
            MC2      = rbind(c("gpp"    , "npp"     ,  "cVeg"),
                             c(1        , 1         ,  1),
                             c(1950     , 1950      ,  1950),
                             c('Annual' , "Annual"  ,  "Annual")),
            ORCHIDEE = rbind(c("gpp"    , "npp"     ,  "cVeg"),
                             c(1        , 1         ,  1),
                             c(1950     , 1950      ,  1950),
                             c('Monthly' , "Monthly",  "Monthly")))


################################################################################
## Plotting Info                                                              ##
################################################################################

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


cVeg                  = list(cols    = c('white',"#BBBB00","#CCCC00",
                                         "#111100"),
                             dcols   = c('#000099','#0000FF','#CCCCFF','white',
                                        '#FFFF00',"#CCCC00","#444400"),
                             limits  = c(0.1, 1, 2, 5, 10)*2,
                             dlimits = c(-20, -10, -5, -2, 2, 5, 10, 20))

################################################################################
## Full comparisons info                                                      ##
################################################################################
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

## cveg
cveg            = list(obsFile       = "avitabile_carbon_veg_05.nc",
                       obsVarname    = "test2",
                       ComparisonFun = FullNME,
                       obsLayers     = 1:9,
                       plotArgs      = veg
