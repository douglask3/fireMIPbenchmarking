# EMmission
# Carbon
# Production
# Veg Cover

#per second
annual2persec = 60 * 60 * 24 * 365.24
annualg2perseckg = annual2persec*1000
perseckg2annualg = 1/annualg2perseckg
Model.Variable = list( #Line 1  variable name; Line 2  scaling; Line 3 - timestep
            varname  = rbind(c("GPP_Kelley2013", "NPP_all"       , "NPP_Kelley2013", "NPP_EMDI"      , "NNP_Michaletz" , "cveg"  ),
                             c(1               , 1               , 1               , 1               , 1               , 1       ),
                             c('Annual'        , "Annual"        , "Annual"        , "Annual"        , "Annual"        ,"Monthly"),
                             c(1997            , 1997            , 1997            , 1997            , 1997            , 1997    ),
                               "mean"),
            CLM      = rbind(c("gpp"           , rep("npp", 4)                                                         , "cVeg"  ),
                             c(rep(perseckg2annualg, 5)                                                                , 1       ),                   
                               1950,
                               'Monthly'),
            CTEM     = rbind(c("gpppft"           , rep("npppft", 4)                                       , "cVeg"   ),
                             c(rep(perseckg2annualg, 5)                                                                , 1       ),                   
                               1860,
                               "Monthly"),
            INFERNO  = rbind(c("gpp"           ,  rep("npp", 4)                                      , "cVeg"   ),
                             c(rep(perseckg2annualg, 5)                                                                , 1       ),                   
                               1700,
                               "Monthly"),
            JSBACH   = rbind(c("gpppft"           ,  rep("npppft", 4)                                      , "cVeg"   ),
                             c(rep(perseckg2annualg, 5)                                                                , 1000     ),                   
                               1950,
                               "Monthly"),
            LPJglob  = rbind(c("gpp"           ,  rep("npp", 4)                                      , "cVeg"   ),
                             c(rep(perseckg2annualg, 5)                                                                , 1       ),                   
                               c(rep(1700	, 4)                                                        , 1700),
                               c(rep("Annual", 4)                                                   , "Annual")),
            LPJspit  = rbind(c("gpp"           ,  rep("npp", 4)                                      , "cVeg"   ),
                             c(rep(perseckg2annualg, 5)                                                                , 1       ),                   
                               c(rep(1700, 4)                                                        , 1700),
                               c(rep("Annual", 4)                                                   , "Annual")),
            LPJblze  = rbind(c("gpp"           ,  rep("npp", 4)                                      , "cVeg"   ),
                             c(rep(perseckg2annualg, 5)                                                                , 1       ),                   
                               c(rep(1700, 4)                                                        , 1700),
                               c(rep("Annual", 4)                                                   , "Annual")),
            MC2      = rbind(c("gpp"           ,  rep("npp", 4)                                      , "cVeg"   ),
                             c(rep(perseckg2annualg, 5)                                                                , 1       ),                   
                               1900,
                               "Annual"),
            ORCHIDEE = rbind(c("gpp"           ,  rep("npp", 4)                                      , "cVeg"   ),
                             c(rep(perseckg2annualg, 5)                                                                , 1       ),                   
                               1950,
                               "Monthly"))


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
NPP_Kelley2013    = list(obsFile       = "NPP.csv",
                         obsVarname    = "csv",
                         obsLayers     = 1:9,
                         ComparisonFun = FullNME.site,
                         plotArgs      = NPP)

NPP_EMDI          = list(obsFile       = "EMDI_NPP.csv",
                         obsVarname    = "csv",
                         obsLayers     = 1:9,
                         ComparisonFun = FullNME.site,
                         plotArgs      = NPP)

NPP_Michaletz     = list(obsFile       = "NNP_Michaletz_2014_single.csv",
                         obsVarname    = "csv",
                         obsLayers     = 1:9,
                         ComparisonFun = FullNME.site,
                         plotArgs      = NPP)

NPP_all           = list(obsFile       = "NPP_all.csv",
                         obsVarname    = "csv",
                         obsLayers     = 1:9,
                         ComparisonFun = FullNME.site,
                         plotArgs      = NPP)

## GPP
GPP_Kelley2013    = list(obsFile       = "GPP6.csv",
                         obsVarname    = "csv",
                         obsLayers     = 1:9,
                         ComparisonFun = FullNME.site,
                         plotArgs      = GPP)

## cveg
cveg            = list(obsFile       = "avitabile_carbon_veg_05.nc",
                       obsVarname    = "test2",
                       ComparisonFun = FullNME,
                       obsLayers     = 1:9,
                       plotArgs      = cVeg)
