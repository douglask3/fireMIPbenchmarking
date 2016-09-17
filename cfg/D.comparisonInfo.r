################################################################################
## Plotting Info                                                              ##
################################################################################

## GFED4
GFED4.Spatial = list(cols    = c('white', "#EE8811", "#FF0000", "#110000"),
                         dcols   = c('#0000AA', '#2093FF', '#C0D0FF','white',
                                        '#FFD793', "#F07700", "#AA0000"),
                         limits  = c(0.001,.01,.02,.05,.1,.2),
                         dlimits = c(-0.2,-0.1,-0.5,-0.01,0.01,0.05,0.1, 0.2))

GFED4.IA      = list(x = 1997:2009)


GFED4s.Spatial = list(cols    = c('white', "#EE8811", "#FF0000", "#110000"),
                         dcols   = c('#0000AA', '#2093FF', '#C0D0FF','white',
                                        '#FFD793', "#F07700", "#AA0000"),
                         limits  = c(0.001,.01,.02,.05,.1,.2),
                         dlimits = c(-0.2,-0.1,-0.5,-0.01,0.01,0.05,0.1, 0.2))

GFED4s.IA      = list(x = 1997:2009)


## meris
meris.Spatial = list(cols    = c('white', "#EE8811", "#FF0000", "#110000"),
                                dcols   = c('#0000AA', '#2093FF', '#C0D0FF','white',
                                            '#FFD793', "#F07700", "#AA0000"),
                                limits  = c(0.001,.01,.05,.1,.2,.5),
                                dlimits = c(-0.2,-0.1,-0.5,-0.01,0.01,0.05,0.1, 0.2))

MCD45.Spatial = meris.Spatial


## GFAS
GFAS = list(cols    = c('white', "#EE8811", "#FF0000", "#110000"),
            dcols   = c('#0000AA', '#2093FF', '#C0D0FF','white',
                        '#FFD793', "#F07700", "#AA0000"),
            limits  = c(0.00000000001, 0.0000000001,0.000000005,0.000000001,0.00000005,0.00000001),
            dlimits = c(-0.2,-0.1,-0.5,-0.01,0.01,0.05,0.1, 0.2))


## Carbon
Carbon                = list(cols    = c('white',"#CCCC11","#999900",
                                         "#001100"),
                             dcols   = c('#220044','#AA02AA','#FF99FF','white',
                                         '#FFFF99',"#AAAA02","#224400"),
                             limits  = c(0, 500, 1000, 5000, 10000),
                             dlimits = c(-10000, -5000, -1000, 1000, 5000, 10000))

Height                = list(cols    = c('white',"#BBBB00","#CCCC00",
                                         "#111100"),
                             dcols   = c('#000099','#0000FF','#CCCCFF','white',
                                        '#FFFF00',"#CCCC00","#444400"),
                             limits  = c(0.1, 1, 2, 5, 10)*2,
                             dlimits = c(-20, -10, -5, -2, 2, 5, 10, 20))

fAPAR.Spatial         = list(cols    = c('white',"#AAFFAA","#00FF00",
                                         "#001100"),
                             dcols   = c('#0000AA','#9302FF','#D0C0FF','white',
                                        '#D7FF93',"#77F000","#00AA00"),
                             limits  = c(.05, .1, .2, .4, .6),
                             dlimits = c(-0.4,-0.2,-0.1,0.1,0.2,0.4))

fAPAR.ia              = list(x = 1998:2005)

VegComparison         = list(cols    = c('white',"#88EE11","#00FF00",
                                         "#001100"),
                             dcols   = c('#AA0000','#FF9320','#FFD0C0','white',
                                        '#D7FF93',"#77F000","#00AA00"),
                             limits  = c(1, 2, 5, 10, 20, 50),
                             dlimits = c(-20,-10,-5, 5, 10, 20))

NPP                   = list(cols    = c('white',"#DDDD00","#33EE00",
                                         "#001100"),
                             limits  = c(100, 200, 400, 600, 1000),
                             xlab    = 'observed NPP (gC/m2)',
                             ylab    = 'simulated NPP (gC/m2)')

GPP                   = list(cols    = c('white',"#00F3CC","#00EE33",
                                         "#001100"),
                             limits  = c(200, 400, 600, 1000, 1500, 2000),
                             xlab    = 'observed GPP (gC/m2)',
                             ylab    = 'simulated GPP (gC/m2)')




################################################################################
## Full comparisons info                                                      ##
################################################################################
GFED4.Spatial = list(obsFile       = "Fire_GFEDv4_Burnt_fraction_0.5grid9.nc",
                         obsVarname    = "mfire_frac",
                         obsLayers     = 1:156,
                         ComparisonFun = FullNME,
                         plotArgs      = GFED4.Spatial,
                         ExtraArgs     = list(mnth2yr = TRUE))

GFED4.IA      = list(obsFile       = "Fire_GFEDv4_Burnt_fraction_0.5grid9.nc",
                         obsVarname    = "mfire_frac",
                         obsLayers     = 1:156,
                         ComparisonFun = FullNME,
                         plotArgs      = GFED4.IA,
                         ExtraArgs     = list(byZ = TRUE, nZ = 12))

GFED4.Season  = list(obsFile       = "Fire_GFEDv4_Burnt_fraction_0.5grid9.nc",
                         obsVarname    = "mfire_frac",
                         obsLayers     = 8:127,
                         ComparisonFun = FullSeasonal,
                         plotArgs      = TRUE)
                         
                         GFAS = list(obsFile       = "GFAS.nc",
                               obsVarname    = "cfire",
                               obsLayers     = 1:120,
                               obsStart      = 2000,
                               ComparisonFun = FullNME,
                               plotArgs      = GFAS,
                               ExtraArgs     = list(mnth2yr = TRUE))



GFED4s.Spatial = list(obsFile       = "GFED4s_v2.nc",
                       obsVarname    = "variable",
                       obsLayers     = 1:144,
                       obsStart      = 1998,
                        ComparisonFun = FullNME,
                       plotArgs      = GFED4s.Spatial,
                       ExtraArgs     = list(mnth2yr = TRUE))

GFED4s.IA      = list(obsFile = "GFED4s_v2.nc",
                         obsVarname    = "variable",
                         obsLayers     = 1:144,
                         obsStart      = 1998,
                         ComparisonFun = FullNME,
                         plotArgs      = GFED4s.IA,
                         ExtraArgs     = list(byZ = TRUE, nZ = 12))

GFED4s.Season  = list(obsFile = "GFED4_v2.nc",
                         obsVarname    = "variable",
                         obsLayers     = 1:144,
                         obsStart      = 1998,
                         ComparisonFun = FullSeasonal,
                         plotArgs      = TRUE)

meris.Spatial = list(obsFile       = "meris.nc",
                                obsVarname    = "variable",
                                obsLayers     = 1:36,
                                obsStart      = 2006,
                                ComparisonFun = FullNME,
                                plotArgs      = meris.Spatial,
                                ExtraArgs     = list(mnth2yr = TRUE))

MCD45.Spatial = list(obsFile       = "MCD45.nc",
                                obsVarname    = "variable",
                                obsLayers     = 1:108,
                                obsStart      = 2001,
                                ComparisonFun = FullNME,
                                plotArgs      = MCD45.Spatial,
                                ExtraArgs     = list(mnth2yr = TRUE))


lifeForm          = list(obsFile       = "veg_cont_fields_CRU.nc",
                         obsVarname    = c("Tree_cover", "Herb"),
                         ComparisonFun = FullMM,
                         plotArgs      = VegComparison,
                         ExtraArgs     = list(extraItem = 100,
                                              itemNames = c('Tree', 'Herb', 'Bare')))


## Height
Height            = list(obsFile       = "height_Simard.nc",
                         obsVarname    = "height",
                         ComparisonFun = FullNME,
                         plotArgs      = Height)

## NPP
NPP               = list(obsFile       = "NPP.csv",
                         obsVarname    = "csv",
                         obsLayers     = 1:9,
                         ComparisonFun = FullNME.site,
                         plotArgs      = NPP)

## GPP
GPP               = list(obsFile       = "GPP6.csv",
                         obsVarname    = "csv",
                         obsLayers     = 1:9,
                         ComparisonFun = FullNME.site,
                         plotArgs      = GPP)


## Fapar
fAPAR.Spatial     = list(obsFile       = "SeaWiFs_fapar_annual.nc",
                         obsVarname    = "fapar",
                         obsLayers     = 1:8,
                         ComparisonFun = FullNME,
                         plotArgs      = fAPAR.Spatial)

fAPAR.season     = list(obsFile       = 'SeaWiFS_fapar_monthly.nc',
                        obsVarname    = "fapar",
                        obsLayers     = NULL,
                        ComparisonFun = FullSeasonal,
                        plotArgs      = TRUE)



fAPAR.ia         = list(obsFile       = "SeaWiFs_fapar_annual.nc",
                        obsVarname    = "fapar",
                        obsLayers     = 1:8,
                        ComparisonFun = FullNME,
                        plotArgs      = fAPAR.ia,
                        ExtraArgs     = list(byZ = TRUE))
