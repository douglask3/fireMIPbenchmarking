################################################################################
## Model I/O                                                                  ##
################################################################################
Model.RAW = list(#DIR                 #Processing
                 "u-bl106_5"= c('u-bl106_5'                  , process.jules),		
		 Mort4.3    = c('JULES-ES-INFERNO-Mort4.3'   , process.jules),
		 Emissions3 = c('JULES-ES-INFERNO-Emissions3', process.jules))

################################################################################
## Model plotting                                                             ##
################################################################################
Model.plotting = rbind( #Title            #Colour
			"u-bl106_5"= c("u-bl106_5"       , 'black'  ),   
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
