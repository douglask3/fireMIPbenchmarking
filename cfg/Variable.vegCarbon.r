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
            varname  = rbind(c("cveg"  , "cVeg_50"),
                             c(1       , 50/12       ),
                             c("Monthly", "Annual"),
                             c(1997    , 1997),
                               "mean"),
            CLM      = rbind(rep("cVeg"  , 5),
                             0.1,                   
                             1950,
                             'Monthly'),
            CTEM     = rbind(rep("cVeg"  , 5),
                             0.1,                   
                             1860,
                             "Monthly"),
            INFERNO  = rbind(rep("cVeg"  , 5),
                             0.05,                   
                             1700,
                             "Monthly"),
            JSBACH   = rbind(rep("cVeg"  , 5),
                             1,                   
                             1950,
                             "Monthly"),
            LPJglob  = rbind(rep("cVeg"  , 5),
                             0.01,                   
                             1700,
                             "Annual"),
            LPJspit  = rbind(rep("cVeg"  , 5),
                             0.01,                   
                             1700,
                             "Annual"),
            LPJblze  = rbind(rep("cVeg"  , 5),
                             0.01,                   
                             1700,
                             "Annual"),
            MC2      = rbind(rep("cVeg"  , 5),
                             0.01,                   
                             1900,
                             "Annual"),
            ORCHIDEE = rbind(rep("cVeg"  , 5),
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
cVeg_50         = list(obsFile       = "Carvalhais.cVeg_50.360.720.1-1.nc",
                       obsVarname    = "cVeg_50",
                       ComparisonFun = FullNME,
                       obsLayers     = 1:9,
                       plotArgs      = cVeg.plot)

cveg_tc20       = list(obsFile       = "avitabile_carbon_veg_05-remove20pc-tree.nc",
                       obsVarname    = "test2",
                       ComparisonFun = FullNME,
                       obsLayers     = 1:9,
                       plotArgs      = cVeg.plot)

cveg_tc40       = list(obsFile       = "avitabile_carbon_veg_05-remove40pc-tree.nc",
                       obsVarname    = "test2",
                       ComparisonFun = FullNME,
                       obsLayers     = 1:9,
                       plotArgs      = cVeg.plot)

cveg_tc60       = list(obsFile       = "avitabile_carbon_veg_05-remove60pc-tree.nc",
                       obsVarname    = "test2",
                       ComparisonFun = FullNME,
                       obsLayers     = 1:9,
                       plotArgs      = cVeg.plot)

cveg            = list(obsFile       = "avitabile_carbon_veg_05.nc",
                       obsVarname    = "test2",
                       ComparisonFun = FullNME,
                       obsLayers     = 1:9,
                       plotArgs      = cVeg.plot)
