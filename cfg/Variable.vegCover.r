 # EMmission
# Carbon
# Production
# Veg Cover


Model.Variable = list( #Line 1  variable name; Line 2  scaling; Line 3 - timestep
            varname  = rbind(c("lifeForm", "TreeCover", "HerbCover", "LeafType", "Phenology", "LAImodis", "LAIavhrr"),
                             c(rep(100, 5)													,	       1,          1),
                             c(rep('Annual', 5)										        ,  "Monthly",  "Monthly"),	
                             c(rep(1992, 5)													,   	2001, 		1983),
                             'mean'),
            CLM      = rbind(c(rep("landCoverFrac", 5)                                      ,      "lai",      "lai"),
                             c(rep(1,5),                                                           1/12 ,       1/12 ),
                             c(rep(1990, 5) 												,		1950,       1950),
                             'Annual',
                             c("9:16;2:8"    , "9:16"      , "2:8"    ,"10:14;15:16",  "17,16,14,13;15,12,11,10",
																								   "NULL",    "NULL")),
            CTEM     = rbind(c(rep("landCoverFrac", 5)                                      ,      "lai",      "lai"),
                             c(rep(12, 5),												  			   1,          1),	
                             1860,
                             'Monthly',
                             c('1:5;6:9'      , "1:5"      , "6:9"    ,"3:5;1:2",  "1,3;2,4:5",   "NULL",      "NULL")),
            INFERNO  = rbind(c(rep("LandCoverFrac", 5)										  ,   "lai" ,      "lai" ),
                             c(rep(12, 5)													  , 1       , 1          ),
                             1700,
                             'Monthly',
                             c("1:5;6:9"      , "1:5"       , "6:9"      , "1:3;4:5", "1,3,4;2,5", "NULL",     "NULL")),
            JSBACH   = rbind(c(rep("landCoverFrac", 3)                     , "NULL"   , "landCoverFrac",
																								   "lai",       "lai"),
                             c(rep(1,5),                                                           1 ,       1 ),
                             c(rep(1700, 5)													,	   1950, 		1950),
                             'Annual',
                             c("1:4;5:11"       , "1:4"       , "5:11"     , ""       , "1,3;2,4:6","NULL"     ,"NULL")),
            LPJglob  = rbind(c(rep("landCoverFrac", 5)											   , "lai"     ,"lai"),
                             c(rep(1,5),                                                           1/12 ,       1/12 ),
                             c(rep(1700, 5)														   , 1950      , 1950),
                             "Annual",
                             c("3:11;1:2,12:19","3:11"       , "1:2,12:19", "6:11;3:5", "3:4,8:10;5:7,11",
																								    "NULL"     ,"NULL")),
            LPJspit  = rbind(c(rep("landCoverFrac", 5)											   , "lai"     , "lai"),
                             c(rep(10, 5)				             							   , 1/12      , 1/12 ),
                             c(rep(1700, 5)    										               , 1950	   , 1950 ),
                             "Annual"       ,
                             c("1:2,12:19;3:11", "1:2,12:19"      , "3:11", "6:11;3:5", "3:4,8:10;5:7,11"
																								   ,"NULL"     ,"NULL")),
            LPJblze  = rbind(c(rep("landCoverFrac",	5)											   , "lai"     , "lai"),
                             c(rep(1,5),                                                           1/12 ,       1/12 ),
                             c(rep(1700, 5)														   , 1950      , 1950 ),
                             'Annual',
                             c("3:11;1:2,12:19","3:11"       , "1:2,12:19", "6:11;3:5", "3:4,8:10;5:7,11",
																					                "NULL"     ,"NULL")),
            MC2      = rbind(c(rep("NULL", 5)													   , "lai"     , "lai"),
                             c(rep(1,5),                                                           1/12 ,       1/12 ),
                             c(rep(1, 5)														   , 1901      , 1901 ),
                             'Annual',
                             c(rep(1, 5)														   ,"NULL"     ,"NULL")),
            ORCHIDEE = rbind(c(rep("landCoverFrac", 5)                                             ,"NULL"     ,"NULL"),
                             100,
                             1700,
                             'Annual',
                             c('2:9;10:13'    , "2:9"       , "10:13", '2:9;10:13', '2:9;10:13',   "NULL"     , "NULL")))


################################################################################
## Plotting Info                                                              ##
################################################################################

VegComparison         = list(cols    = c('white',"#88EE11","#00FF00",
                                         "#001100"),
                             dcols   = c('#AA0000','#FF9320','#FFD0C0','white',
                                        '#D7FF93',"#77F000","#00AA00"),
                             limits  = c(1, 2, 5, 10, 20, 50)/100,
                             dlimits = c(-20,-10,-5, 5, 10, 20)/100)
							 
LAI   			      = list(cols    = c('white',"#BBBB00","#00AA00",
                                         "#002200"),
                             dcols   = c('#110011','#AA00AA','#CCCCFF','white',
                                        '#FFFF00',"#00DD00","#002200"),
                             limits  = c(0.01, 0.1, 0.2, 0.5, 1, 2, 5),
                             dlimits = c(-2, -1, -0.5, -0.1, 0.1, 0.5, 1, 2))

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

						 
							 
LAImodis          = list(obsFile       = "lai_0.5x0.5_2000-2005.nc",
                         obsVarname    = "lai",
                         ComparisonFun = FullNME,
                         obsLayers     = 12:71,
                         plotArgs      = LAI)