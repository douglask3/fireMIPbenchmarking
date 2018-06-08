################################################################################
## Model I/O                                                                  ##
################################################################################
dir = '../LimFIRE/outputs/'
dirs = list.dirs(dir, full.names = FALSE)

dirs = dirs[grep('ensemble_', dirs)]
ensemble_names = sapply(dirs, function(i) strsplit(i, 'outputs//')[[1]][2])
niterations = length(ensemble_names)

dirs = paste(dirs, '/', sep = '')

Model.RAW = lapply(dirs, c, process.ConFIRE)

names(Model.RAW) = ensemble_names

################################################################################
## Model plotting                                                             ##
################################################################################

ensFun <- function(nm, nmb) {
	Title =  paste("conFire_", nm, sep = '')
	col = rainbow(niterations)[nmb]
	return(c(Title, col))
}

Model.plotting = t(mapply(ensFun, ensemble_names, 1:length(ensemble_names)))
rownames(Model.plotting) = ensemble_names

################################################################################
## Model catigory                                                             ##
################################################################################			
			#					  CLM    CTEM              INFERNO     JSBACH       LPJglob    LPJSpit,   Blaze    MC2         ORCHIDEE
ModelSplits = list(vegModel = list(
	 VegModelGroup = c('CLM'       , 'CTEM' , 'JULES'    , 'JSBACH'  , 'LPJ'     ,   'LPJ'   , 'LPJ'    , 'MC2'    , 'ORCHIDEE'),
	Dymanic        = c('P'         , 'P'    ,'SD'        , 'P'       , 'D'       , 'D'       , 'D'      , 'D'      , 'P'       )),
				  fireModel = list(
	FireModelGroup = c('Li '       , 'CTEM' , 'INFERNO'  , 'SPITFIRE', 'GLOBFIRM', 'SPITFIRE', 'SIMFIRE', 'MC-fire', 'SPITFIRE'),
	Empirical      = c('P'         , 'P'    , 'SP'       , 'P'       , 'E'       , 'P'       , 'E'      , 'SP'     , 'P'       )),
				  ROSvsEM = list(
	Empirical      = c('P'         , 'P'    , 'INFERNO'  , 'P'       , 'E'       , 'P'       , 'E'      , 'P'      , 'P'       )),
				  fireControls = list(
	HumanIgntions  = c('Fixed'    , 'Fixed', 'Fixed'     , 'Varying', 'Exc'     , 'Varying' , 'Exc'    , 'Exc'    , 'Fixed'   ), 
	NaturalIgntions= c('CG'       , 'CGEf' , 'CGEf'      , 'CGEf'    , 'Exc'     , 'CGEf'    , 'Exc'    , 'Exc'    , 'CGEf+'   ),
	HumanSupression= c('Explict'  , 'Exc'  , 'Explict'   , 'Implict' , 'Exc'     , 'Implict' , 'Explict', 'Exc'    , 'Implict' )),	
				  modelRes = list(
	SpatialRes     = c(2           , 1      , 4          , 3         , 1         ,  1        , 1        , 1        , 1         ),
	TempralRes     = c('Sub-daily' , 'Daily', 'Sub-daily', 'Daily'   , 'Annual'  , 'Daily'   , 'Annual' , 'Monthly', 'Daily'   ))  
	)