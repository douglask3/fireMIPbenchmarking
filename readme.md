Note this project is still under development.

<hr>
## Project Repo
<hr>

The projects code and version history is accessible from github:
[github.com/douglask3/fireMIPbenchmarking](https://github.com/douglask3/fireMIPbenchmarking)

To clone this to you own computer:

    git clone https://github.com/douglask3/fireMIPbenchmarking.git

This will copy the current code and version history to a directory called `fireMIPbenchmarking`. To grab any updates, cd into `fireMIPbenchmarking`, and run:

    git pull https://github.com/douglask3/fireMIPbenchmarking.git

When I have finished initial development, I will provide a link for the latest 'stable' version of the project.

<hr>
## Benchmark data
<hr>

Benchmark data is on the fireMIP server. Contact [Stijn Hantson](http://www.imk-ifu.kit.edu/staff_2107.php) for info. Each model should be stored in the following way:

    <<PATH>>/<<NAME>>/<<EXP>>/<<OUTPUTS>>

Where:

* PATH is a common path to all models, which must be defined in the cfg file as ``outputs_dir.BenchmarkData``
* NAME is a unique name for the model. It doesn't not have to be the actual model name, but can be for example an abbriviation. So long as no other model shares that name
* EXP is the experiment (i.e "SF1")
* OUTPUTS: all the model outputs. These should be netcdf files. The can be individually zipped with gzip. And they are allowed to be in different directories.

<hr>
## Configuring
<hr>

There are several points in the 'cfg.r' where you can set the comparisons to be made, add new models, add extra observatioanl comparisons, and define which models and comparisons are to be made

### Set Parameters
<hr>

Here, you can set the following parameter:

    experiment   = 'SF1'

Sets the experiment directory. Here, its set to SF1

    mask_type    = 'common'

What mask to apply to the spatial comparisons. The options are still comoing online, but will include:

* 'common': Compares areas of where observations and all models have data
* 'commonHi': All models are resampled to the highest resolution of models and data (typically 0.5 degree) before applying the common grid
* 'commonLw': All models are resampled to the lowest resolution of models and data before applying the common grid
* 'Observations': models resampled to observations grid and compare for common grid between observation and model on a model by model basis
* 'Modelled':  observations resampled to model grid and compare for common grid between observation and model on a model by model basis.


### Paths
<hr>

    data_dir.ModelOuutputs = 'data/ModelOutputs/'

The path to model output data (<<PATH>> in model data section)

    data_dir.BenchmarkData = 'data/BenchData/'

The path to the benchmark datasets

    outputs_dir.modelMasks = outputs/Masks'

The path and start of pattern of the mask from model and observations, to be applied before metric comparison.

###  Model Information
<hr>

**Model.RAW** lists information about the model outputs and how ethy should be processed.
Each model forms an item in a list, and each item has three entires:

* *Directory name*, or <<NAME>> in model data section
* *Processing function*, the function used to process the particular model.
  Most models will get away with ``process.default``. If a new model needs a new
  function, this can be defined in a separate file and placed in 'libs' dir or its
  sub-directories, and it will be automatically sourced when the system is run
* *Start date*, in decimal years - the timing of the first day of the models run.

For example

    Model.RAW = list(
                    CLM  = c('CLM' , process.CLM , 1996),
                    CTEM = c('CTEM', process.CTEM, 1859))


**Model.Variable** Description soon
For example

    Model.Variable = list( #Line 1  variable name; Line 2  scaling; Line 3 - timestep
        varname  = rbind(c("BurntArea", "gpp"    , "ModelMask"),
                         c(100        , 1/1000   , 1          ),
                         c('Monthly'  , 'Annual' , "Monthly"  ),
                         c('mean'     , 'sum'    , "sum"      )),
        CLM      = rbind(c("BAF"      , "gpp"    , "cSoilt"   ),
                         c(100        , 1        , 1          ),
                         c('Daily'    , 'Monthly', "Monthly"  )),
        CTEM     = rbind(c("burntArea", "gpp"    , "cSoil"    ),
                         c(100        , 1        , 1          ),
                         c('Monthly'  , 'Daily'  , "Monthly"  )))


**Model.plotting** Description soon
For example

    Model.plotting = rbind(#Title  #Colour
                  CLM  = c('CLM' , 'red'     ),
                  CTEM = c('CTEM', 'green'   ))

###  Comparison Info
<hr>

Infomrmation for comparisons are in a list per comparison. There a number of common
items each list must contain, along with some extra items specific to the
comparison type:

* *ObsFile* is the filename, relative to ``data_dir.BenchmarkData`` that the
  observation is contained in
* *ComparisonFun* the function which will be used to make the comparison.
   Available functions include:

   - FullNME, ...
   - Others listed soon


#### Spatial
Spatial comparisons can be an NME comparisons of Annual Average or itemized MM comparisons.

*For NME*



  BurntArea.Spacial = list(obsFile       = "Fire_GFEDv4_Burnt_fraction_0.5grid9.nc",
                           obsVarname    = "mfire_frac",
                           obsLayers     = 8:127,
                           obsStart      = 1996,
                           ComparisonFun = FullNME,
                           plotArgs      = plotArgs)

where ``plotArgs`` are defined as:

  BurntArea.Spacial = list(cols    = c('white', "#EE8811", "#FF0000", "#110000"),
                           dcols   = c('#0000AA', '#2093FF', '#C0D0FF','white',
                                          '#FFD793', "#F07700", "#AA0000"),
                           limits  = c(0.001,.01,.02,.05,.1,.2),
                           dlimits = c(-0.2,-0.1,-0.5,-0.01,0.01,0.05,0.1, 0.2))


###  Model and Comparison selection
<hr>

More info coming soon

<hr>
## Participating Models
<hr>

More Info coming soon

<hr>
## Packages Used
<hr>

Packages are downloaded by running initalise.r ``./initalise.r`` in command line and ``source("initalise.r")`` from within R.

### benchmarkmetrics
<hr>

The actual metrics used are in an R-package, and are sourced and called by this project.

To use in this package separately in you own project

    install.packages('devtools')
    library(devtools)
    install_github('douglask3/benchmarkmetrics/benchmarkMetrics')
    library(benchmarkMetrics)

For info on how to use this package:

    ?benchmarkMetrics

[Click here](https://github.com/douglask3/benchmarkmetrics) for more info.

### TM2r
<hr>

This package will be used to calculate atmospheric seasonal concentrations of CO<sub>2</sub> from model outputs of fluxes from Net Primary Production, hetrotrophic respiration, and fire. [Click here](https://github.com/douglask3/tm2R) for code development. More info coming soon.

### gitBasedProjects
<hr>

gitBasedProjects is used to link comparison outputs to a specific point in the projects development, and to specific configurations the model will be run in. This is done by adding the git version number, url, date and time to:

* figures, as a watermark
* netcdf outputs and temporary files, as attributes
* csv tables, as footers.


To use in this package separately in you own project

    install.packages('devtools')
    library(devtools)
    install_github('douglask3/gitProjectExtras/gitBasedProjects')
    library(gitBasedProjects)

For info on how to use this package:

    ?gitBasedProjects

[Click here](https://github.com/douglask3/gitProjectExtras) for more info.

### Extra raster functions.
<hr>

More info coming soon.

Andy questions, [contact me](#contact)
