# EMmission
# Carbon
# Production
# Veg Cover

Model.Variable = list( #Line 1  variable name; Line 2  scaling; Line 3 - timestep
            varname  = rbind(c("lifeForm"     , "TreeCover", "HerbCover", "LeafType", "Phenology"),
                             100,
                             'Annual',
                             1992,
                             'mean'),
            CLM      = rbind("landCoverFrac",
                             1,
                             1900,
                             'Annual',
                             c("2:9;10:16"    , "1:5"      , "10:16"    ,"3:5;1:2",  "1,3;2,4:5")),
            CTEM     = rbind("landCoverFrac",
                             1,
                             1859,
                             'Monthly',
                             '1:7;8:9'      , NA       , NA        )),
            INFERNO  = rbind("landCoverFrac",
                             1,
                             1,
                             'Monthly',
                             c("1:5;6:9"      , "1:5"       , "6:9"      , "1:3;4:5", "1,3,4;2,5"   )),
            JSBACH   = rbind("NULL",
                             1,
                             1,
                             'Annual',
                             1),
            LPJglob  = rbind("landCoverFrac",
                             1,
                             1,
                             "Annual",
                             c("3:11;1:2,12:19","3:11"       , "1:2,12:19", "6:11;3:5", "3:4,8:10;5:7,11"),        )),
            LPJspit  = rbind("landCoverFrac",
                             1              ,
                             1              ,
                             "Annual"       ,
                             c("3:11;1:2,12:19","3:11"       , "1:2,12:19", "6:11;3:5", "3:4,8:10;5:7,11"),        )),
            LPJblze  = rbind("landCoverFrac",
                             1,
                             1,
                             'Annual',
                             c("3:11;1:2,12:19","3:11"       , "1:2,12:19", "6:11;3:5", "3:4,8:10;5:7,11"),        )),
            MC2      = rbind("NULL",
                             1,
                             1,
                             'Annual',
                             1),
            ORCHIDEE = rbind("landCoverFrac",
                             1,
                             1700,
                             'Annual',
                             c('2:9;10:13'    , "2:9"       , "10:13", '2:9;10:13', '2:9;10:13')))


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
