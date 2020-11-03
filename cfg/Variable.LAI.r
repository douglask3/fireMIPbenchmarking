 # EMmission
# Carbon
# Production
# Veg Cover

jules_nl = rbind(rep("lai", 4),
                             1/100,
                             1990,
                             'Monthly',
                             "NULL")


Model.Variable = list( #Line 1  variable name; Line 2  scaling; Line 3 - timestep
            varname  = rbind(c("LAImodis", "LAIavhrr", "LAImodisMonthly", "LAIavhrrMonthly"),
                             1,
                             "Monthly",
                             c(2001, 		1990     , 2001             , 1990),
                             'mean'),
            jules_nl,
            jules_nl)


################################################################################
## Plotting Info                                                              ##
################################################################################
							 
LAI   			      = list(cols    = c('white',"#BBBB00","#00AA00",
                                         "#002200"), 
                             dcols   = c('#110011','#AA00AA','#CCCCFF','white',
                                        '#FFFF00',"#00DD00","#002200"),
                             limits  = c(0.01, 0.1, 0.2, 0.5, 1, 2, 5),
                             dlimits = c(-2, -1, -0.5, -0.1, 0.1, 0.5, 1, 2))

################################################################################
## Full comparisons info                                                      ##
################################################################################

LAImodisMonthly    = list(obsFile       = "lai_0.5x0.5_2000-2005.nc",
                         obsVarname    = "lai",
                      obsLayers     = 12:59,
                      ComparisonFun = FullSeasonal,
                      plotArgs      = TRUE)
							 
LAImodis          = list(obsFile       = "lai_0.5x0.5_2000-2005.nc",
                         obsVarname    = "lai",
                         ComparisonFun = FullNME,
                         obsLayers     = 13:60,
                         plotArgs      = LAI)
							 
LAIavhrr          = list(obsFile       = "lai_0.5x0.5_1982-2009.nc",
                         obsVarname    = "lai",
                         ComparisonFun = FullNME,
                         obsLayers     = 97:336,
                         plotArgs      = LAI)
