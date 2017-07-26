Note this project is still under development.

## Set-up

## Downloading the system

The projects code and version history is accessible from github:
[github.com/douglask3/fireMIPbenchmarking](https://github.com/douglask3/fireMIPbenchmarking)

1. Clone the git repo. In command line, this is:
>> > git clone https://github.com/douglask3/fireMIPbenchmarking.git
>> > cd fireMIPbenchmarking

To update:
>> git pull 


### Gradding Data

Benchmark data is on the fireMIP server. Contact [Stijn Hantson](http://www.imk-ifu.kit.edu/staff_2107.php) for info. Benchmark datasets should be copied straight from the sever into the projects 'data/benchmarkData/' dir.

Model output should be downloaded into 'data/ModelOutputs/' dir. By default, the system is setup to have one lot of model output per model in a dir for the name provided in the first column of the "Model.RAW" table in 'cfg/modelInfo.r'. So, for example, copying all contents of 'SF1' for LPJglob into 'data/ModelOutputs/LPJ-GUESS-GlobFIRM/'. 

If you want to have multiple experiments (i.e, SF1 and SF2/..) then setting the 'experiment' variable to the sub-dir within each model folder *should* open that experiment, although as of b486c8e, this is untested. For example, have the following structure:

data/ModelOutputs/LPJ-GUESS-GlobFIRM/SF1/<<files>>
data/ModelOutputs/LPJ-GUESS-GlobFIRM/SF2/WWF/<<files>>
data/ModelOutputs/LPJ-GUESS-GlobFIRM/SF2/fixedCO2/<<files>>

This dir structure should be conistent across all models you wish to open (which I'm not sure it is on the fireMIP server).
	
If you wish to store data outside of the project, you can either use symbolic links or set the new path by altering 'data_dir.ModelOutputs' in 'cfg/params.r/'.


## Configuring masking and comparisons

Most of the fire comparison paramters are already setup, so if might be able to skip this section. However, if you wish to correct, modify, or create new comparisons, then you will need to modify or create a new 'cfg/variable.xxx.r' file, where xxx is the comparison group. Using 'cfg/varibale.fire.r' as an example:

1. In **Model.Variable**, the top row lists the names for the comparison. These can be named anything, and is used to reference that variable late in the cfg and when making benchmark outputs. The 2nd line are the unit size of the obsvered variable to be opened compared to some standard unit (the standard unit is normally SI in most of the pre-defined comparisons, but as long as your consitant, you can pick whatever unit you like). As 'GFED4xxx' are all fractional burnt area, the 2nd row are of size 1 compared to the standrd unit of fractional area. If they had been %, then this would be 100 (cos it would be 100 times bigger than the standard unit of franction area). If you wanted the standrd unit to be %, then these would all be changed to 0.01, cos there 0.01 x the size of the new standard unit. The 3rd line is the temporal resultion of the observed. At the moment, it will accept 'Annual', 'Monthly', or 'daily'.

The 4th row is the start year of the comparison. The 5th row is how this should be converted for annual average over the full period. 'mean' means the mean of all years, while 'sum' is the sum of all years. If in doubt, this is normally set to 'mean'. 

The first four rows are repeated for each model, but in a slightly different order (I don't know why, and I need to fix that at some point). The 1st row is the variable name again, but this time it shoudl match the variable name in the model output. For most models, this is found either in the output filename or variable name within their nc file. The 2nd row is model output unit vs the same standard unit used for the observation (CLM for all burnt areas, for exmaple, is in % so is set to 100 as it's 100 times bigger than fractional area). Te 3rd row is the start year and the fourth is temporal resolution of the model output. This does not have to be the same as the observation, and if they are different, is used to interpolation or aggrigation to the obesvered timestep.

This is reapeated for each model.



2. I'll skip the plotting info for a sec. 

The bit under **Full comparison info** provides model detail for each variable defined in the original table. Each list should be <<comparison name>>.extension. "extension" can be anything, but comparison name must match the name in the 1st row of the Model.Variable table I just described. There are a number of fields, some of which are optional. Complusary arguemnts are in bold.
					 
* ***obsFile*** is the filename, relative to ``data_dir.BenchmarkData`` that the
  observation is contained in
* *obsVarname* is the varname in if obsFile is a netcdf file. If not provided, the system will open the first spatial variable it finds in the nc file. For MM comparisons, where mltiple items are used in the calculation, a vector of variable names can be provided to either ``length(items)`` or ``length(items)-1`` if the ``extraItem`` is provided in ``ExtraArgs`` field (see below)
* *ComparisonFun* the function which will be used to make the comparison.
   Available functions include:
   
   - ``FullNME`` for Normalised Mean Error (NME) comparisons for gridded data
   - ``FullNME.site`` for point/site based NME comparisons.
   - ``FullSesonal`` for seaonal comparisons, comparising phase using Mean Phase Difference (MPD) and concentration with NME.  ``PhaseSeason`` and ``ConcSeason`` will be options added later for partical seasonal comparisons
   - ``FullMM`` for Manhattan Metric (MM) comparisons
   
Normalised Mean Squared Error (NMSE) and Square Cord Difference (SCD) are not yet implemented, but shouldn't take to much work if anyone wants to volenteer?

* *obsLayers* are the time/z dimension layers to be used. for example, as the GFED4 obs starts in May 95 and comtains one layer per month, using layers 8:163 selects the 8th layer (Jan 96) through (length(8:163)) 156 months or 11 years. If not provided, all layers will be used.
* *plotArgs* are the paramters used for plotting, more info below. If left blank,or plotArgs set to ``FALSE``, some plots will still be made but using standard, predefined plotting parameters.
* *ExtraArgs*. There are a number of extra arguemnts that ca be added for come comparisons, which can be proved in a list here. The most common ones are:

	- *mnth2yr* which, if set to TRUE, will sum months when converting seasonal to annual average.
	- *byZ* which switches from spatial NME comparisons to inter-annual NME comparisons.
	- *nZ* is the number of time layers in a month when performing Inter-annual comparisons (for example, if monthly observations, nZ = 12)
	- *extraItem*. If perfoming MM comparisons, an extra item can be provided as "the area not covred by other items". FOr example, if performing tree cover vs grass cover vs bare ground comparisons, tree and grass cover can be provided by the obsFile (and by providing two obsVarnames), and bare soil can be calculated as the left over area of the cell. ``extraItems`` should be set as the total of each cell/site in units provided in the ``Model.Variable`` table, and the extra item is calculated as ``extraItem - sum(other items)``.
	- *itemNames* are the names of each item for MM comparisons to be used for plotting and score outputs.
	
	
For example:

GFED4.Spatial = list(obsFile       = "Fire_GFEDv4_Burnt_fraction_0.5grid9.nc",
                     obsVarname    = "mfire_frac",
                     obsLayers     = 8:163,
                     ComparisonFun = FullNME,
                     plotArgs      = FractionBA.Spatial ,
                     ExtraArgs     = list(mnth2yr = TRUE))
	
3. Plotting arguments
Some of the plotting arguments can be quiet long lists, so it is often worth defining these in sperate lists are setting ``plotArgs`` as equal to this list when defining  your ``<<comparison name>>.extension`` list. This is what is implemented in ``cfg\Variable.fire``. Plotting argemnts that can be provided depend on the comparison being performed:

* For spatial NME and MM comparisons:

	- *cols* is a vector of colours to be used for plotting the observation and model output.
	- *dcols* is a vector of colours when plotting the difference between model output and obsvered.
    - *limits* defines the levels of the colourmap for modelled and observed plots. If ``length(limits) > length(cols) + 1`` then cols will be interploated to stretch the colours over the full number of levels. dlimits - *dlimits* is the same but for the model 0 obsevered differnce plots.
	
* For site based NME compairons

	- *cols* and *limits* are the same as for spatial NME, but will only be used for maps of model output
	- *xlab* will provide the x-axis label for observed vs modelled
	- *ylab* the same for the y-axis
	
For example:

NPP = list(cols    = c('white',"#DDDD00","#33EE00",
					   "#001100"),
		   limits  = c(10, 50, 100, 200, 400, 600, 1000),
           xlab    = 'observed NPP (gC/m2)',
           ylab    = 'simulated NPP (gC/m2)')
	
* For interannual NME comparisons:

	- `x` defines the x-axis tick marks, and should be one for each year]

* For seasonal comparisons, seasonal plots use default only colours (which can be modified elsewhere), and so ``plotArgs = TRUE`` will provided these default plots, and any other value will not.


## Running the system

Once this setup, you just need to define 3 variables, either in an R terminal or an r script file:

- *name*. The name of the the comparison group you want to run (i.e, the group name in ``cfg/Variable.<<group name>>.r``
- *comparisons*, a list of vectors containing the comparison names you want to perfom. Providing more than one vector in the list will run those comparisons in smaller sub-groups, although with the current implemntation, that doesnt make much differences. Each comparison name listed in the vector will run all <<comparison name>>.xxx defined in the ``cfg/Variable.<<group name>>.r`` file. If comparisons is set to ``NULL``, then all comparisons defined in the relevent file will be performed.

These should then be followed by ``source('run.r')``, which will then run the comparison.

For example:

>> names = 'fire'
>> comparisons = list(c("GFEDsSeason", "GFASSeason"))
>> source('run.r')

On windows machines, you may get warnings about not being able to create some directories. Ignore these, thats fine.

The first time you run this, it will probably take a long time, as model output will need to be interplolated and regridded to observations. However, all this is saved in a newly created 'temp/' dir, so any subequant runs of the same comparison will be much faster. The system should track any changes you make to the parameters that might affect the interpolation/redgridding, so will normally make new temp files if and when needed. However, old temp files are not deleted when no longer used, and there's always a chance I've missed a update track. So after making serveral changes or when you have frozen a new workflow, it would be test to mannually delete the 'temp/' dir and contents and run afresh.

Once completed, you can see output in a number of places:

- The 'figs/' dir will have plots you should browse
- The 'outputs/' dir will have a load of comparison tables. These are a little messy still, but will be tidied at some point
- If you are working in an R terminal, or if you want to add more anaylis code below your initial 3 lines in the r script, then regridded and remasked observations and model output, as well as comparison information and scores, are provided in a new, global r-variable call 'out'. In R-terminal, typing 'out' will give this:

> out
            fire  
GFEDsSeason List,3
GFASSeason  List,3

where each list of length 3 provides:
out[['GFEDsSeason', 'fire']][[1]] - comparison scores for null and model outputs
out[['GFEDsSeason', 'fire']][[2]] - regridded, masked & interpolated observations
out[['GFEDsSeason', 'fire']][[3]] - regridded, masked & interpolated model outputs


## Other things you can setup

* in *cfg/params.r*
``openOnly = TRUE`` Will skip all plotting and comparisons, and just open, regrid, interploate and re-mask the data. The 'out' variable will now look like this:

            fire  
GFEDsSeason List,2
GFASSeason  List,2

where the first item in the each list is the opened observed and the 2nd is a list with each opened model.

``nRRs = N`` will perform N boostraps for the randomly-resampled null model.

Changing SeasonConcCols though to SeasonPahseDlimits will change the colormap for seasonal plots in a simular way to changing `cols`, trough to `dlimits` in plotting arguments for NME and MM spatial plots (see above)

If you benchmark or model output data are stored outside the project or in none-standard paths, these can be set in:
data_dir.ModelOutputs  = 'data/ModelOutputs/'
data_dir.BenchmarkData = 'data/benchmarkData/'

However, these dirs will assume the same structure as the ones outlined under 'Set-up'


* In *cfg/modelInfo.r*

Model.RAW provides a line for each model of:
	<<Model Name>> = c('<<model dir>>', <<model opening fun>>)
	
This would normally remain unchanged. However, if a new model needs adding, just add the model name, the directory name for model outputs within ``data_dir.ModelOutputs`` and the function used to open model outputs. If model outputs are already using fireMIP standrd structure, then the model *should* open using ``process.default``.


``Model.plotting`` has a line for each model, with the name used in plots and the colour of the line used for multi-model plots (such as inter-annual variablity).

Goodluck!

Doug.
