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
            varname  = rbind(c("avitabile_cveg" , "avitabile_cveg_tc20" , "avitabile_cveg_tc40" , "avitabile_cveg_tc60" , 
                               "carvalhais_cveg", "carvalhais_cveg_tc20", "carvalhais_cveg_tc40", "carvalhais_cveg_tc60"),
                             c(rep(1, 4)       , rep(50/12, 4)),
                             c(rep("Monthly", 4), rep("Annual",4)),
                             1997,
                               "mean"),
            CLM      = rbind(rep("cVeg"  , 8),
                             0.1,                   
                             1950,
                             'Monthly'),
            CTEM     = rbind(rep("cVeg"  , 8),
                             0.1,                   
                             1860,
                             "Monthly"),
            INFERNO  = rbind(rep("cVeg"  , 8),
                             0.05,                   
                             1700,
                             "Monthly"),
            JSBACH   = rbind(rep("cVeg"  , 8),
                             1,                   
                             1950,
                             "Monthly"),
            LPJglob  = rbind(rep("cVeg"  , 8),
                             0.01,                   
                             1700,
                             "Annual"),
            LPJspit  = rbind(rep("cVeg"  , 8),
                             0.01,                   
                             1700,
                             "Annual"),
            LPJblze  = rbind(rep("cVeg"  , 8),
                             0.01,                   
                             1700,
                             "Annual"),
            MC2      = rbind(rep("cVeg"  , 8),
                             0.01,                   
                             1900,
                             "Annual"),
            ORCHIDEE = rbind(rep("cVeg"  , 8),
                             1,                   
                             1700,
                             "Monthly"))


################################################################################
## Plotting Info                                                              ##
################################################################################

cVeg.plot             = list(cols    = c('white',"#BBBB00","#CCCC00",
                                         "#111100"),
                             dcols   = c('#000099','#0000FF','#CCCCFF','white',
                                        '#FFFF00',"#CCCC00","#444400"),
                             limits  = c(0.01, 0.1, 1, 2, 5, 10, 20) * 10,
                             dlimits = c(-20, -10, -5, -2,-1, 1, 2, 5, 10, 20) * 10)

################################################################################
## Full comparisons info                                                      ##
################################################################################

## cveg
carvalhais_cveg      = list(obsFile       = "Carvalhais.cVeg_50.360.720.1-1.nc",
                            obsVarname    = "cVeg_50",
                            ComparisonFun = FullNME,
                            obsLayers     = 1:9,
                            plotArgs      = cVeg.plot)

carvalhais_cveg_tc20 = list(obsFile       = "Carvalhais.cVeg_50.360.720.1-1-remove20pc-tree.nc",
                            obsVarname    = "cVeg",
                            ComparisonFun = FullNME,
                            obsLayers     = 1:9,
                            plotArgs      = cVeg.plot)

carvalhais_cveg_tc40 = list(obsFile       = "Carvalhais.cVeg_50.360.720.1-1-remove40pc-tree.nc",
                            obsVarname    = "cVeg",
                            ComparisonFun = FullNME,
                            obsLayers     = 1:9,
                            plotArgs      = cVeg.plot)

carvalhais_cveg_tc60 = list(obsFile       = "Carvalhais.cVeg_50.360.720.1-1-remove60pc-tree.nc",
                            obsVarname    = "cVeg",
                            ComparisonFun = FullNME,
                            obsLayers     = 1:9,
                            plotArgs      = cVeg.plot)

avitabile_cveg       = list(obsFile       = "avitabile_carbon_veg_05.nc",
                            obsVarname    = "test2",
                            ComparisonFun = FullNME,
                            obsLayers     = 1:9,
                            plotArgs      = cVeg.plot)

avitabile_cveg_tc20  = list(obsFile       = "avitabile_carbon_veg_05-remove20pc-tree.nc",
                            obsVarname    = "cVeg",
                            ComparisonFun = FullNME,
                            obsLayers     = 1:9,
                            plotArgs      = cVeg.plot)

avitabile_cveg_tc40  = list(obsFile       = "avitabile_carbon_veg_05-remove40pc-tree.nc",
                            obsVarname    = "cVeg",
                            ComparisonFun = FullNME,
                            obsLayers     = 1:9,
                            plotArgs      = cVeg.plot)

avitabile_cveg_tc60  = list(obsFile       = "avitabile_carbon_veg_05-remove60pc-tree.nc",
                            obsVarname    = "cVeg",
                            ComparisonFun = FullNME,
                            obsLayers     = 1:9,
                            plotArgs      = cVeg.plot)


