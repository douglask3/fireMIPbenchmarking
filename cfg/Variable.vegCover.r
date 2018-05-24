 # EMmission
# Carbon
# Production
# Veg Cover

JULES_nl =  		   rbind(rep("landCoverFrac", 4),
                             12/100,
                             1992,
                             'Monthly',
							 c("1:2,5;3:4",  "1:2,5", "3:4", "1;2"))


Model.Variable = list( #Line 1  variable name; Line 2  scaling; Line 3 - timestep
            varname  = rbind(c("lifeForm", "TreeCover", "HerbCover", "LeafType"),
                             c(rep(1, 4)													),
                             c(rep('Annual', 4)										        ),	
                             c(rep(1992, 4)													),
                             'mean'),
            S2       = JULES_nl, 
			S3       = JULES_nl,
			SF2      = JULES_nl,
            SF3      = JULES_nl)
			
################################################################################
## Plotting Info                                                              ##
################################################################################

VegComparison         = list(cols    = c('white',"#88EE11","#00FF00",
                                         "#001100"),
                             dcols   = c('#AA0000','#FF9320','#FFD0C0','white',
                                        '#D7FF93',"#77F000","#00AA00"),
                             limits  = c(1, 2, 5, 10, 20, 50),
                             dlimits = c(-20,-10,-5, 5, 10, 20))
							 
################################################################################
## Full comparisons info                                                      ##
################################################################################
lifeForm          = list(obsFile       = "veg_cont_fields_CRU.nc",
                         obsVarname    = c("Tree_cover", "Herb"),
                         ComparisonFun = FullMM,
                         plotArgs      = VegComparison,
                         ExtraArgs     = list(extraItem = 100,
                                              itemNames = c('Tree', 'Herb', 'Bare')))

TreeCover         = list(obsFile       = "veg_cont_fields_CRU.nc",
                         obsVarname    = c("Tree_cover"),
                         ComparisonFun = FullMM,
                         plotArgs      = VegComparison,
                         ExtraArgs     = list(extraItem = 100,
                                              itemNames = c('Tree', 'Not Tree')))

HerbCover         = list(obsFile       = "veg_cont_fields_CRU.nc",
                         obsVarname    = c("Herb"),
                         ComparisonFun = FullMM,
                         plotArgs      = VegComparison,
                         ExtraArgs     = list(extraItem = 100,
                                              itemNames = c('Herb', 'Not Herb')))

LeafType          = list(obsFile       = "veg_cont_fields_CRU.nc",
                         obsVarname    = c("Broadleaf", "Needleleaf"),
                         ComparisonFun = FullMM,
                         plotArgs      = VegComparison,
                         ExtraArgs     = list(itemNames = c('Broadleaf', 'Needle')))

Phenology         = list(obsFile       = "veg_cont_fields_CRU.nc",
                         obsVarname    = c("Evergreen", "Decidous"),
                         ComparisonFun = FullMM,
                         plotArgs      = VegComparison,
                         ExtraArgs     = list(itemNames = c('Evergreen', 'Decidous')))

