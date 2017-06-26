################################
## cfg   				      ##
################################
source("cfg.r")
graphics.off()

mar0 = c(0,0, 2, 0)

SeasonConcLimits = c(0, 0.5, 0.7, 0.8, 0.9, 0.95)

datasets = c("GFED4  Burnt Area"      = "GFED4.nc",
             "GFED4s Burnt Area"      = "Fire_GFEDv4_Burnt_fraction_0.5grid9.nc",
			 "MERIS  Burnt Area"      = "meris_v2.nc",
			 "MCD45  Burnt Area"      = "MCD45.nc",
			 "GFAS Fire Emission"     = "GFAS.nc",
 			 "Hantson Mean fire size" = "NRfire-mean_fire.nc",
             "Hantson No. of fires"   = "NRfire-nr_fire.nc",
			 "Avitabile AG biomass"   = "avitabile_carbon_veg_05.nc")
			 

Seasonal = c(TRUE ,
		     TRUE ,
			 TRUE ,
			 TRUE,
			 TRUE,
			 FALSE,
			 FALSE,
			 FALSE)
			 
colours= list(c('white', "#EE8811", "#FF0000", "#110000"),
		  	  c('white', "#EE8811", "#FF0000", "#110000"),
			  c('white', "#EE8811", "#FF0000", "#110000"),
			  c('white', "#EE8811", "#FF0000", "#110000"),
		  rev(c('white', "#EE8811", "#FF0000", "#110000")),
			  c('white', "#CCCC11", "#E9E900", "#110000"),
			  c('white', "#EE1188", "#F00099", "#110000"),
			  c('white', "#BBBB00", "#CCCC00", "#111100"))

limits = list(c(0.001,.01,.02,.05,.1,.2) * 100,
		      c(0.001,.01,.02,.05,.1,.2) * 100,
		      c(0.001,.01,.02,.05,.1,.2) * 100,
		      c(0.001,.01,.02,.05,.1,.2) * 100,
			  c(0.01, 0.1, 1, 10, 100),
		      c(0.001,.01,.05,.1,.2,.5) * 10000,
			  c(0.001,.01,.05,.1,.2,.5),
			  c(0.01, 0.1, 1, 2, 5, 10, 20))

scaling = c(1, 1, 1, 1, 60 * 60 * 24 * 30 * 1000, 1, 1, 0.1)	

units = c('%', '%', '%', '%', 'gC/m2', 'hectare', '/km2')

mask = NULL	  

plotDataset <- function(name, unit, path, seasonal, scale, lims, cols) {
	print(lims)
	path = paste(data_dir.BenchmarkData, path, sep = '/')
	dat = stack(path)
	aa = mean(dat) * scale
	if (name == "GFED4s Burnt Area") mask <<- is.na(aa)
		else if (!is.null(mask)) aa[mask] = NaN
		
	
	if (seasonal) {
		aa = aa * 12
		pc =  PolarConcentrationAndPhase(dat, n = 12, phase_units = 'months')
	}
	
	plot_raster_from_raster(aa, limits = lims, cols = cols, add_legend = FALSE, y_range = c(-60, 90))
	if (seasonal) aatitle = paste(name, 'Annual Average', sep = '\n')
		else aatitle = name
	mtext(aatitle, line = 0)#
	mtext(unit, cex = 0.8, side = 1, line = -1)
	
	par(mar = c(1, 0, 0, 0))
	add_raster_legend2(cols = cols, limits = lims, transpose = FALSE,
	                   plot_loc = c(0.05, 0.35, 0.95, 1.0), mar = c(0, 0,-30,0),
			           add = FALSE, ylabposScling = 3)
	par(mar = mar0)
	if (seasonal) {
		plotStandardMap(pc[[1]], '', SeasonPhaseLimits, SeasonPhaseCols, add_legend = FALSE)
		mtext(paste(name, 'season timing', sep = '\n'), line = 0)
		plot_raster_from_raster(pc[[2]], limits = SeasonConcLimits, cols = SeasonConcCols, add_legend = FALSE, y_range = c(-60, 90))
		mtext(paste(name, 'season length', sep = '\n'), line = 0)
	}	
}


png('figs/burntAreaProducts.png', width = 12, height = 7, units = 'in', res = 300)


lmat = rbind(c(1 , 5 ,  9, 13, 17),
			 c(2 , 6 , 10, 14, 18),
			 c(3 , 7 , 11, 15, 19),
			 c(4 , 8 , 12, 16, 20),
			 c(21, 23, 25, 27, 28),
			 c(22, 24, 26,  0, 0 ))

#lmat = matrix(1:nplots, nrow = 4)
#lmat[] = 0
#lmat[1:nplots] = 1:nplots

layout(lmat, heights = c(1, 0.3, 1, 1, 1, 0.3))
par(mar = mar0, oma = c(0,0,2,0))

mapply(plotDataset, names(datasets), units, datasets, Seasonal, scaling, limits, colours)
 

par(mar = c(0,0,0, 20))
	SeasonLegend(SeasonPhaseLimits, SeasonPhaseCols, dat = pc[[1]])
par(mar = c(8.5,0,0, 0))

add_raster_legend2(cols = SeasonConcCols, limits = SeasonConcLimits, 
		                  transpose = FALSE,
	                      plot_loc = c(0.05, 0.35, 0.95, 1.0), mar = c(-0.5, 0,0,0),
			              add = FALSE, ylabposScling = 3)

dev.off.gitWatermarkStandard()