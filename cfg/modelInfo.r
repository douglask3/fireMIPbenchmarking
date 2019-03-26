################################################################################
## Model I/O                                                                  ##
################################################################################
Model.RAW = list(      #DIR                 #Processing
            CLM      = c('CLM2'                   , process.CLM     ),
            CTEM     = c('CLASS_CTEM'             , process.CTEM    ),
            INFERNO  = c('Inferno'                , process.INFERNO ),
            JSBACH   = c('JSBACH'                 , process.JSBACH ),
            LPJglob  = c('LPJ-GUESS-GlobFIRM'     , process.LPJ ),
            LPJspit  = c('LPJ-GUESS-SPITFIRE'     , process.LPJ ),
            LPJblze  = c('LPJ-GUESS-SIMFIRE-BLAZE', process.LPJ ),
            MC2      = c('MC2'                    , process.MC2     ),
            ORCHIDEE = c('ORCHIDEE'               , process.orchidee))

################################################################################
## Model plotting                                                             ##
################################################################################

Model.plotting = rbind( #Title            #Colour
            CLM      = c('CLM'               , 'red'        ),
            CTEM     = c('CTEM'              , 'green'      ),
            INFERNO  = c('inferno'           , 'blue'       ),
            JSBACH   = c('JSBACH'            , 'yellow'     ),
            LPJglob  = c('LPJ-GUESS-GlobFIRM', 'cyan'       ),
            LPJspit  = c('LPJ-GUESS-SPITFIRE', 'darkcyan'   ),
            LPJblze  = c('LPJ-GUESS-BLAZE'   , 'dodgerblue4'),
            MC2      = c('MC2'               , 'darkgoldenrod4' ),
            ORCHIDEE = c('ORCHIDEE'          , 'magenta'    ))

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
