 # EMmission
# Carbon
# Production
# Veg Cover


Model.Variable = list( #Line 1  variable name; Line 2  scaling; Line 3 - timestep
            varname  = rbind(c("LAImodis", "LAIavhrr", "LAImodisMonthly", "LAIavhrrMonthly"),
                             1,
                             "Monthly",
                             c(2001, 		1983     , 2001             , 1983),
                             'mean'),
            CLM      = rbind(c("lai", "lai", "NULL", "NULL"),
                             1/12 ,
                             1950,
                             'Annual',
                             "NULL"),
            CTEM     = rbind(rep("lai", 4),
                             1,	
                             1860,
                             'Monthly',
                             "NULL"),
            INFERNO  = rbind(rep("lai", 4),
                             1,
                             1700,
                             'Monthly',
                             "NULL"),
            JSBACH   = rbind(c("lai", "lai", "NULL", "NULL"),
                             1,
                             1950,
                             'Annual',
                             "NULL"),
            LPJglob  = rbind(c("lai", "lai", "NULL", "NULL"),
                             1/12,
                             1950,
                             "Annual",
                             "NULL"),
            LPJspit  = rbind(c("lai", "lai", "NULL", "NULL"),
                             1/12,
                             1950,
                             "Annual"       ,
                             "NULL"),
            LPJblze  = rbind(c("lai", "lai", "NULL", "NULL"),
                             1/12,
                             1950,
                             'Annual',
                             "NULL"),
            MC2      = rbind(c("lai", "lai", "NULL", "NULL"),
                             1/12,
                             1901,
                             'Annual',
                             "NULL"),
            ORCHIDEE = rbind("NULL",
                             "NULL",
                             "NULL",
                             'Annual',
                             "NULL"))


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
                      obsLayers     = 12:71,
                      ComparisonFun = FullSeasonal,
                      plotArgs      = TRUE)
							 
LAImodis          = list(obsFile       = "lai_0.5x0.5_2000-2005.nc",
                         obsVarname    = "lai",
                         ComparisonFun = FullNME,
                         obsLayers     = 12:71,
                         plotArgs      = LAI)