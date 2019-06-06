
daily_pc = 100/30.4167
sec_frac = 1/(60*60*24*30)
kgpersec =  sec_frac/1000

###########################################################
## Burnt area                                            ##
###########################################################

JULES_nl = rbind(c(rep("burnt_area_gb", 7) , rep("emitted_carbon_gb", 2), "nfire"   , "mean_fire"),
                 c(sec_frac   , sec_frac   , sec_frac     , sec_frac   , sec_frac   , sec_frac, sec_frac, kgpersec  , kgpersec    , 1         , 1          ),
                 1997,
                 'Monthly')
Model.Variable  = list( #Line 1  variable name; Line 2  scaling; Line 3 - time
             varname  = rbind(c("MODIS", "GFED4"    , "GFED4s"   , "GFED4sSeason", "MODISSeason", "meris"    , "MCD45"    , "GFAS"    , "GFASSeason", "NRfire"  , "meanFire" ),
                             c(1      , 1          , 1          , 1            , 1          , 1          , 1          , kgpersec  , kgpersec    , 1         , 1          ),
                             c('Monthly', 'Monthly'  , 'Monthly'  , 'Monthly'    , 'Monthly'  ,  'Monthly'  , "Monthly"  , 'Monthly' , 'Monthly'   , "Annual"  , "Annual"   ),
                             c(2001  , 1996       , 1996       , 1996         , 1996         , 2006       , 2001       , 2000      , 2000        , 2002      , 2002       ),
                             c('mean', 'mean'     , 'mean'     , "mean"       , "mean"       , "mean"     , "mean"     , "mean"    , "mean"      , "mean"    , "mean"    )),
            
            Mort4.3      = JULES_nl,
            Emissions3      = JULES_nl)

################################################################################
## Plotting Info                                                              ##
################################################################################
FractionBA.Spatial = list(cols    = c('white', "#EE8811", "#FF0000", "#110000"),
                     dcols   = c('#0000AA', '#2093FF', '#C0D0FF','white',
                                 '#FFD793', "#F07700", "#AA0000"),
                     limits  = c(0.001,.01,.02,.05,.1,.2),
                     dlimits = c(-0.2,-0.1,-0.05,-0.01,0.01,0.05,0.1, 0.2))
					 
FractionBA.Trend = list(cols    = c('#0000AA', '#2093FF', '#C0D0FF','white',
                                 '#FFD793', "#F07700", "#AA0000"),
                     dcols   = c('#0000AA', '#2093FF', '#C0D0FF','white',
                                 '#FFD793', "#F07700", "#AA0000"),
                     limits  = c(-20, -10, -5, -2, -1, 1, 2, 5, 10, 20),
                     dlimits = c(-20, -10, -5, -2, -1, 1, 2, 5, 10, 20))
					 
FractionBA.Grad = list(cols    = c('white', "#EE8811", "#FF0000", "#110000"),
                     dcols   = c('#000033', '#0066FF','white',
                                 '#FF6600',"#330000"),
                     limits  = c(0.001,.01,.02,.05,.1,.2),
                     dlimits = c(-0.2,-0.1,-0.05,-0.01,-0.005, -0.001, 0.001, 0.005, 0.01,0.05,0.1, 0.2))

FractionBA.IA      = list(x = 1997:2009)
GFED4.IA      = list(x = 1997:2009)

GFED4s.IA     = list(x = 1997:2013)

## GFAS
GFAS          = list(cols    = c('white', "#EE8811", "#FF0000", "#110000"),
                     dcols   = c('#0000AA', '#2093FF', '#C0D0FF','white',
                                 '#FFD793', "#F07700", "#AA0000"),
                     limits  = c(0.01, 0.1, 1, 10, 100),
                     dlimits = c(-100, -10, -1, -0.1, -0.01 ,0.01, 0.1, 1, 10, 100))

## NR
NRfire        = list(cols    = c('white', "#EE8811", "#FF0000", "#110000"),
                     dcols   = c('#0000AA', '#2093FF', '#C0D0FF','white',
                                 '#FFD793', "#F07700", "#AA0000"),
                     limits  = c(0.001,.01,.05,.1,.2,.5),
                     dlimits = c(-0.2,-0.1,-0.05,-0.01,0.01,0.05,0.1, 0.2))
					 
## meanFire
meanFire      = list(cols    = c('white', "#EE8811", "#FF0000", "#110000"),
                     dcols   = c('#0000AA', '#2093FF', '#C0D0FF','white',
                                 '#FFD793', "#F07700", "#AA0000"),
                     limits  = c(0.001,.01,.05,.1,.2,.5) * 10000,
                     dlimits = c(-0.2,-0.1,-0.05,-0.01,0.01,0.05,0.1, 0.2) * 10000)
################################################################################
## Full comparisons info                                                      ##
################################################################################
## GFED4
MODIS.Spatial = list(obsFile       = "MODIS250_q_BA_regridded0.5.nc",
                     obsVarname    = "burnt_area",
                     obsLayers     = 1:108,
                     ComparisonFun = FullNME,
                     plotArgs      = FractionBA.Spatial ,
                     ExtraArgs     = list(mnth2yr = TRUE))

MODISSeason    = list(obsFile       = "MODIS250_q_BA_regridded0.5.nc",
                      obsVarname    = "burnt_area",
                      obsLayers     = 1:108,
                      obsStart      = 1997,
                      ComparisonFun = FullSeasonal,
                      plotArgs      = TRUE)

MODIS.IA      = list(obsFile       = "MODIS250_q_BA_regridded0.5.nc",
                     obsVarname    = "burnt_area",
                     obsLayers     = 1:108,
                     ComparisonFun = FullNME,
                     plotArgs      = list(x = 1997:2009),
                     ExtraArgs     = list(byZ = TRUE, nZ = 12))

MODIS.Season  = list(obsFile       = "MODIS250_q_BA_regridded0.5.nc",
                     obsVarname    = "burnt_area",
                     obsLayers     = 1:108,
                     ComparisonFun = FullSeasonal,
                     plotArgs      = TRUE)

## GFED4
GFED4.Spatial = list(obsFile       = "Fire_GFEDv4_Burnt_fraction_0.5grid9.nc",
                     obsVarname    = "mfire_frac",
                     obsLayers     = 8:163,
                     ComparisonFun = FullNME,
                     plotArgs      = FractionBA.Spatial ,
                     ExtraArgs     = list(mnth2yr = TRUE))
					 
GFED4.Trend   = list(obsFile       = "Fire_GFEDv4_Burnt_fraction_0.5grid9.nc",
                      obsVarname    = "mfire_frac",
                      obsLayers     = 8:163,
                      obsStart      = 1997,
                      ComparisonFun = FullNME,
                      plotArgs      = FractionBA.Trend,
                      ExtraArgs     = list(zTrend = TRUE))

GFED4.IA      = list(obsFile       = "Fire_GFEDv4_Burnt_fraction_0.5grid9.nc",
                     obsVarname    = "mfire_frac",
                     obsLayers     = 8:163,
                     ComparisonFun = FullNME,
                     plotArgs      = list(x = 1997:2009),
                     ExtraArgs     = list(byZ = TRUE, nZ = 12))

GFED4.Season  = list(obsFile       = "GFED4.nc",
                     obsVarname    = "mfire_frac",
                     obsLayers     = 1:156,
                     ComparisonFun = FullSeasonal,
                     plotArgs      = TRUE)

##GFED4s
GFED4s.Spatial = list(obsFile       = "GFED4s_v2.nc",
                      obsVarname    = "variable",
                      obsLayers     = 1:204,
                      obsStart      = 1997,
                      ComparisonFun = FullNME,
                      plotArgs      = FractionBA.Spatial,
                      ExtraArgs     = list(mnth2yr = TRUE))
					  
GFED4s.Trend   = list(obsFile       = "GFED4s_v2.nc",
                      obsVarname    = "variable",
                      obsLayers     = 1:204,
                      obsStart      = 1997,
                      ComparisonFun = FullNME,
                      plotArgs      = FractionBA.Trend,
                      ExtraArgs     = list(zTrend = TRUE))
					  
GFED4s.Grad    = list(obsFile       = "GFED4s_v2.nc",
                      obsVarname    = "variable",
                      obsLayers     = 1:204,
                      obsStart      = 1997,
                      ComparisonFun = FullGrad,
                      plotArgs      = FractionBA.Grad)
					  
GFED4s.NMDE10    = list(obsFile       = "GFED4s_v2.nc",
                      obsVarname    = "variable",
                      obsLayers     = 1:204,
                      obsStart      = 1997,
                      ComparisonFun = FullNMDE,
                      plotArgs      = FractionBA.Grad,
					  inherit       = "GFED4s.Spatial",
                      ExtraArgs     = list(mnth2yr = TRUE, scale_fact = 0.1))


					  
GFED4s.NMDE20    = list(obsFile       = "GFED4s_v2.nc",
                      obsVarname    = "variable",
                      obsLayers     = 1:204,
                      obsStart      = 1997,
                      ComparisonFun = FullNMDE,
                      plotArgs      = FractionBA.Grad,
					  inherit       = "GFED4s.Spatial",
                      ExtraArgs     = list(mnth2yr = TRUE, scale_fact = 0.05))
					  
GFED4s.NMDE50    = list(obsFile       = "GFED4s_v2.nc",
                      obsVarname    = "variable",
                      obsLayers     = 1:204,
                      obsStart      = 1997,
                      ComparisonFun = FullNMDE,
                      plotArgs      = FractionBA.Grad,
					  inherit       = "GFED4s.Spatial",
                      ExtraArgs     = list(mnth2yr = TRUE, scale_fact = 0.02))

GFED4s.IA      = list(obsFile       = "GFED4s_v2.nc",
                      obsVarname    = "variable",
                      obsLayers     = 1:204,
                      obsStart      = 1997,
                      ComparisonFun = FullNME,
                      plotArgs      = list(x = 1997:2009),
                      ExtraArgs     = list(byZ = TRUE, nZ = 12))

GFED4sSeason    = list(obsFile = "GFED4s_v2.nc",
                      obsVarname    = "variable",
                      obsLayers     = 1:204,
                      obsStart      = 1997,
                      ComparisonFun = FullSeasonal,
                      plotArgs      = TRUE)

## GFAS
GFAS           = list(obsFile       = "GFAS.nc",
                      obsVarname    = "cfire",
                      obsLayers     = 1:108,
                      obsStart      = 2000,
                      ComparisonFun = FullNME,
                      plotArgs      = GFAS,
                      ExtraArgs     = list(mnth2yr = TRUE))

## GFAS
GFASSeason     = list(obsFile       = "GFAS.nc",
                      obsVarname    = "cfire",
                      obsLayers     = 1:108,
                      obsStart      = 2000, 
                      ComparisonFun = FullSeasonal,
                      plotArgs      = TRUE)

GFAS.IA       = list(obsFile       = "GFAS.nc",
                     obsVarname    = "cfire",
                     obsLayers     = 1:108,
                     obsStart      = 2000,
                     ComparisonFun = FullNME,
                     plotArgs      = list(x = 2000:2008),
                     ExtraArgs     = list(byZ = TRUE, nZ = 12))
					 
## Meris
meris.Spatial  = list(obsFile       = "meris.nc",
                      obsVarname    = "variable",
                      obsLayers     = 1:36,
                      obsStart      = 2006,
                      ComparisonFun = FullNME,
                      plotArgs      = FractionBA.Spatial,
                      ExtraArgs     = list(mnth2yr = TRUE))
					  
					  
meris.Season   = list(obsFile       = "meris.nc",
                      obsVarname    = "variable",
                      obsLayers     = 1:36,
                      obsStart      = 2006, 
                      ComparisonFun = FullSeasonal,
                      plotArgs      = TRUE)

## MCD45
MCD45.Spatial  = list(obsFile       = "MCD45.nc",
                      obsVarname    = "variable",
                      obsLayers     = 1:96,
                      obsStart      = 2001,
                      ComparisonFun = FullNME,
                      plotArgs      = FractionBA.Spatial,
                      ExtraArgs     = list(mnth2yr = TRUE))
					  
MCD45.Season   = list(obsFile       = "MCD45.nc",
                      obsVarname    = "variable",
                      obsLayers     = 1:96,
                      obsStart      = 2001, 
                      ComparisonFun = FullSeasonal,
                      plotArgs      = TRUE)
					  
MCD45.IA       = list(obsFile       = "MCD45.nc",
                      obsVarname    = "variable",
                      obsLayers     = 1:96,
                      obsStart      = 2001,
                      ComparisonFun = FullNME,
                      plotArgs      = list(x = 2001:2008),
                      ExtraArgs     = list(byZ = TRUE, nZ = 12))
					  
NRfire        = list(obsFile       = "NRfire-nr_fire.nc",
                     obsLayers     = 1:9,
                     ComparisonFun = FullNME,
                     plotArgs      = NRfire)
					 
meanFire        = list(obsFile       = "NRfire-mean_fire.nc",
                     obsLayers     = 1:9,
                     ComparisonFun = FullNME,
                     plotArgs      = meanFire)
