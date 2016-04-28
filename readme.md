
## Model.Variable

list of small tables for each variable (top item in list) and how each model RAW
output for that variable. It goes:
rbind(c(VARIBALE NAME 1, VARIABLE NAME 2, ....),
      c(VAL vs SI 1    , VAL vs SI 2    , ....),
      c(TIME STEP 1    , TIME STEP 2    , ....))

where:
    VARIABLE NAME is the name of the variable, listed below the '.' in the
    comparison info for obsrvations, or the variable name in the raw model
    outputs nc files
    VAL vs SI is the scale the value takes compared to teh relanvent SI units:
        fractional: fraction
        mass      : kg
        etc

        i.e. if the varibale is provided in %, then 100 should be provided as
        this is 100 times bigger than the unit for fraction. SImularly, if a
        vraiable is in grams, than 1/1000 should be provided as this is 1000
        times small than kg.
