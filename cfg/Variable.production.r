# EMmission
# Carbon
# Production
# Veg Cover

#per second
annual2persec = 60 * 60 * 24 * 365.24
annualg2perseckg = annual2persec*1000
perseckg2annualg = 1/annualg2perseckg
perseckg2Mnthg = perseckg2annualg * 12

Model.Variable = list( #Line 1  variable name; Line 2  scaling; Line 3 - timestep
            varname  = rbind(c("GPP_Kelley2013", "NPP_all"       , "NPP_Kelley2013", "NPP_EMDI"      , "NNP_Michaletz" , "cveg"  , "cVeg_50"),
                             c(1               , 1               , 1               , 1               , 1               , 1       , 5       ),
                             c('Annual'        , "Annual"        , "Annual"        , "Annual"        , "Annual"        ,"Monthly", "Annual"),
                             c(1997            , 1997            , 1997            , 1997            , 1997            , 1997    , 1997),
                               "mean"),
            CLM      = rbind(c("gpp"           , rep("npp", 4)                                                         , "cVeg"  , "cVeg"),
                              c(rep(perseckg2Mnthg, 5)                                                                 , 0.1     , 0.1),                   
                               1950,
                               'Monthly'),
            CTEM     = rbind(c("gpppft"           , rep("npppft", 4)                                       , "cVeg"             , "cVeg"),
                             c(rep(perseckg2Mnthg, 5)                                                                  , 0.1     , 0.1),                   
                               1860,
                               "Monthly"),
            INFERNO  = rbind(c("gpp"           ,  rep("npp", 4)                                      , "cVeg"   , "cVeg"   ),
                             c(rep(perseckg2Mnthg, 5)                                                                , 0.05       , 0.05),                   
                               1700,
                               "Monthly"),
            JSBACH   = rbind(c("gpppft"           ,  rep("npppft", 4)                                      , "cVeg"   , "cVeg"   ),
                             c(rep(perseckg2Mnthg, 5)                                                                , 1          , 1),                   
                               1950,
                               "Monthly"),
            LPJglob  = rbind(c("gpp"           ,  rep("npp", 4)                                      , "cVeg"   , "cVeg"   ),
                             c(rep(perseckg2annualg, 5)                                                                , 0.01      , 0.01),                   
                               1700,
                               "Annual"),
            LPJspit  = rbind(c("gpp"           ,  rep("npp", 4)                                      , "cVeg"   , "cVeg"   ),
                             c(rep(perseckg2annualg, 5)                                                                , 0.01       , 0.01),                   
                               1700,
                               "Annual"),
            LPJblze  = rbind(c("gpp"           ,  rep("npp", 4)                                      , "cVeg"  , "cVeg"   ),
                             c(rep(perseckg2annualg, 5)                                                                , 0.01       , 0.01),                   
                               1700,
                               "Annual"),
            MC2      = rbind(c("gpp"           ,  rep("npp", 4)                                      , "cVeg"   , "cVeg"   ),
                             c(rep(perseckg2annualg, 5)                                                                , 0.01       , 0.01),                   
                               1900,
                               "Annual"),
            ORCHIDEE = rbind(c("gpp"           ,  rep("npp", 4)                                      , "cVeg"   , "cVeg"  ),
                             c(rep(perseckg2Mnthg * 12, 5)                                                                , 1       , 1),                   
                               c(rep(1950,5), 1700, 1700),
                               "Monthly"))


################################################################################
## Plotting Info                                                              ##
################################################################################

NPP                   = list(cols    = c('white',"#DDDD00","#33EE00",
                                         "#001100"),
                             limits  = c(10, 50, 100, 200, 400, 600, 1000),
                             xlab    = 'observed NPP (gC/m2)',
                             ylab    = 'simulated NPP (gC/m2)')

GPP                   = list(cols    = c('white',"#00F3CC","#00EE33",
                                         "#001100"),
                             limits  = c(100, 200, 400, 600, 1000, 1500, 2000, 3000, 5000),
                             xlab    = 'observed GPP (gC/m2)',
                             ylab    = 'simulated GPP (gC/m2)')


cVeg                  = list(cols    = c('white',"#BBBB00","#CCCC00",
                                         "#111100"),
                             dcols   = c('#000099','#0000FF','#CCCCFF','white',
                                        '#FFFF00',"#CCCC00","#444400"),
                             limits  = c(0.01, 0.1, 1, 2, 5, 10, 20) * 10,
                             dlimits = c(-20, -10, -5, -2,-1, 1, 2, 5, 10, 20) * 10)

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
cVeg_50         = list(obsFile       = "Carvalhais.cVeg_50.360.720.1-1.nc",
                       obsVarname    = "cVeg_50",
                       ComparisonFun = FullNME,
                       obsLayers     = 1:9,
                       plotArgs      = cVeg)

cveg            = list(obsFile       = "avitabile_carbon_veg_05.nc",
                       obsVarname    = "test2",
                       ComparisonFun = FullNME,
                       obsLayers     = 1:9,
                       plotArgs      = cVeg)
