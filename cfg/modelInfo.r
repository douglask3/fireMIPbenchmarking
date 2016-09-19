################################################################################
## Model I/O                                                                  ##
################################################################################

Model.RAW = list(      #DIR                 #Processing
            CLM      = c('CLM'               , process.CLM     ),
            CTEM     = c('CTEM'              , process.CTEM    ),
            INFERNO  = c('Inferno'           , process.INFERNO ),
            JSBACH   = c('JSBACH'            , process.JSBACH ),
            LPJglob  = c('LPJ-GUESS-GlobFIRM', process.default ),
            LPJspit  = c('LPJ-GUESS-SPITFIRE', process.default ),
            LPJblze  = c('LPJ-GUESS-BLAZE'   , process.default ),
            MC2      = c('MC2'               , process.default ),
            ORCHIDEE = c('ORCHIDEE'          , process.orchidee))

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
