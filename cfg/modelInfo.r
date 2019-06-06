################################################################################
## Model I/O                                                                  ##
################################################################################

Model.RAW = list(      #DIR                 #Processing			
			S2       = c('JULES-INFERNO-S2'       , process.jules   ),
			S3       = c('JULES-INFERNO-S3'       , process.jules   ),
			SF2      = c('JULES-INFERNO-SF2'      , process.jules   ),
			SF3      = c('JULES-INFERNO-SF3-2'    , process.jules   ))
Model.RAW = list(      #DIR                 #Processing			
			Mort4.3    = c('JULES-ES-INFERNO-Mort4.3'   , process.jules   ),
			Emissions3 = c('JULES-ES-INFERNO-Emissions3', process.jules   ))
################################################################################
## Model plotting                                                             ##
################################################################################

Model.plotting = rbind( #Title            #Colour
			S2       = c('S2'                , 'blue'   ),
			S3       = c('S3'                , 'green'  ),
			SF2      = c('S2 - Fire'         , 'purple' ),
			SF3      = c('S3 - Fire'         , 'red'    ))
Model.plotting = rbind( #Title            #Colour
			Mort4.3    = c('Mort4.3'         , 'blue'   ),
			Emissions3 = c('Emissions3'      , 'green'  ))

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
