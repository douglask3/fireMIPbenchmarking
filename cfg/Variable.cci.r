 # EMmission
# Carbon
# Production
# Veg Cover

JULES_nl =  		   rbind(rep("landCoverFrac", 5),
                             12/100,
                             1997,
                             'Monthly',
							 c("1:2;3:4;5", "1:2"     , "1:2,5"    , "3:4"      , "1;2"     , "1" , "2" , "3" , "4" , "5" ))

Model.Variable = list( #Line 1  variable name; Line 2  scaling; Line 3 - timestep
            varname  = rbind(c("lifeForm_cci", "TreeCover_cci", "WoodCover_cci", "HerbCover_cci", "LeafType_cci", "BL_cci", "NL_cci", "C3_cci", "C4_cci", "Sh_cci"),
                             1/100,
                             "Annual",
                             2010,
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

setupList <- function(obsVarname, itemNames, extraItem = 100) {
	lifeForm = list(obsFile       = "vegfrac_refLC_refCW.nc",
					obsVarname    = obsVarname,
					ComparisonFun = FullMM,
					plotArgs      = VegComparison,
					ExtraArgs     = list(extraItem = 100,
                                         itemNames = itemNames))
}

lifeForm_cci  = setupList(list(1:2, 3:4, 5), c('Tree', 'Grass', 'Shrub', 'Bare'))
TreeCover_cci = setupList(list(c(1:2))        , c('Tree', 'non-Tree'))
WoodCover_cci = setupList(list(c(1:2, 5))  , c('Woody', 'non-Woody'))
HerbCover_cci = setupList(list(3:4)        , c("Herb", "non-Herb"))
LeafType_cci  = setupList(list(1, 2)       , c("BL", "NL"))
BL_cci        = setupList(list(1)          , c("BL", "None-BL"))
NL_cci        = setupList(list(2)          , c("NL", "None-NL"))
C3_cci        = setupList(list(3)          , c("C3", "None-C3"))
C4_cci        = setupList(list(4)          , c("C4", "none-C4"))
Sh_cci        = setupList(list(5)          , c("Shrub", "none-Shrub"))
