daily_pc = 100/30.4167
sec_frac = 1/(60*60*24*30)

###########################################################
## Burnt area                                            ##
###########################################################
sec2mon2kg = 1/(60 * 60 * 24 * 1000)
Model.Variable  = list( #Line 1  variable name; Line 2  scaling; Line 3 - timestep
    varname  = rbind(c("ANN_GPP_HB", "ANN_GPP", "ANN_TER_HB", "ANN_TER", "MARS_GPP_HB", "MARS_GPP", "MARS_TER_HB", "MARS_TER", "RF_GPP_HB", "RF_GPP", "RF_TER_HB", "RF_TER"),
                    1,
                    'Monthly',
                    1980,
                    'mean'),
    CLM      = rbind(rep("gpp"   , 12),
                    sec2mon2kg,
                    1950,
                    'Monthly'),
    CTEM     = rbind(rep("gpppft", 12),
                    sec2mon2kg,
                    1860,
                    "Monthly"),
    INFERNO  = rbind(rep("gpp"   , 12),
                    sec2mon2kg,
                    1700,
                    "Monthly"),
    JSBACH   = rbind(rep("gpppft", 12),
                    sec2mon2kg,
                    1950,
                    "Monthly"),
    LPJglob  = rbind(rep("gpp"   , 12),
                    sec2mon2kg,
                    1950,
                    "Monthly"),
    LPJspit  = rbind(rep("gpp"   , 12),
                    sec2mon2kg,
                    1950,
                    "Monthly"),
    LPJblze  = rbind(rep("gpp"   , 12),
                    sec2mon2kg,
                    1950,
                    "Monthly"),
    MC2      = rbind(rep("gpp"   , 12),
                    1,
                    1900,
                    "Annual"),
    ORCHIDEE = rbind(rep("gpp", 12),
                    sec2mon2kg,
                    1950,
                    "Monthly"))

################################################################################
## Plotting Info                                                              ##
################################################################################

## GFED4
JUNG.Spatial = list(cols    = c('white', "#EE8811", "#FF0000", "#110000"),
                     dcols   = c('#0000AA', '#2093FF', '#C0D0FF','white',
                                 '#FFD793', "#F07700", "#AA0000"),
                     limits  = c(0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1, 2, 5),
                     dlimits = c(-0.2,-0.1,-0.5,-0.01,0.01,0.05,0.1, 0.2)*10)

JUNG.IA      = list(x = 1997:2009)


################################################################################
## Full comparisons info                                                      ##
################################################################################
JUNG.Spatial = list(obsFile        = "CRUNCEPv6.XXX.YYY.monthly.1980_2013.nc",
                     obsVarname    = "YYY",
                     obsLayers     = 1:360,
                     ComparisonFun = FullNME,
                     plotArgs      = JUNG.Spatial,
                     ExtraArgs     = list(mnth2yr = TRUE))

JUNG.IA      = list(obsFile        = "CRUNCEPv6.XXX.YYY.monthly.1980_2013.nc",
                     obsVarname    = "YYY",
                     obsLayers     = 1:360,
                     ComparisonFun = FullNME,
                     plotArgs      = JUNG.IA,
                     ExtraArgs     = list(byZ = TRUE, nZ = 12))

JUNG.Season  = list(obsFile        = "CRUNCEPv6.XXX.YYY.monthly.1980_2013.nc",
                     obsVarname    = "YYY",
                     obsLayers     = 1:360,
                     ComparisonFun = FullSeasonal,
                     plotArgs      = TRUE)

replacXY <- function(xxx, yyy, cfg) {

    rplc <- function(i, zzz, ZZZ) {
        if (is.character(i)) {
            i = strsplit(i, ZZZ)[[1]]
            if (length(i) > 1) i = paste(i, collapse = zzz)
            else if (i == "") i = zzz
        }
        return(i)
    }
    cfg = lapply(cfg, rplc, xxx, 'XXX')
    cfg = lapply(cfg, rplc, yyy, 'YYY')
    return(list(cfg))
}

## function for replacing XXX YYY
c(ANN_GPP_HB.Spatial, ANN_GPP.Spatial, MARS_GPP_HB.Spatial, MARS_GPP.Spatial,
  RF_GPP_HB.Spatial, RF_GPP.Spatial) :=
            mapply(replacXY,
                   c('ANN'   , 'ANN', 'MARS'  , 'MARS', 'RF'   , 'RF' ),
                   c('GPP_HB', 'GPP', 'GPP_HB', 'GPP' ,'GPP_HB', 'GPP'),
                   MoreArgs = list(JUNG.Spatial))
				   
c(ANN_GPP_HB.Season, ANN_GPP.Season, MARS_GPP_HB.Season, MARS_GPP.Season,
  RF_GPP_HB.Season, RF_GPP.Season) :=
            mapply(replacXY,
                   c('ANN'   , 'ANN', 'MARS'  , 'MARS', 'RF'   , 'RF' ),
                   c('GPP_HB', 'GPP', 'GPP_HB', 'GPP' ,'GPP_HB', 'GPP'),
                   MoreArgs = list(JUNG.Season))
