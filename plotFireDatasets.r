################################
## cfg   				      ##
################################
source("cfg.r")
graphics.off()

mar0 = c(0,0, 2, 0)

datasets = c("GFED4  Burnt Area"      = "GFED4.nc",
             "GFED4s Burnt Area"      = "Fire_GFEDv4_Burnt_fraction_0.5grid9.nc",
			 "MERIS  Burnt Area"      = "meris_v2.nc",
			 "MCD45  Burnt Area"      = "MCD45.nc",
			 "GFAS Fire Emission"     = "GFAS.nc",
 			 "Hantson Mean fire size" = "NRfire-mean_fire.nc",
             "Hantson No. of fires"   = "NRfire-nr_fire.nc")
			 

Seasonal = c(TRUE ,
		     TRUE ,
			 TRUE ,
			 TRUE,
			 TRUE,
			 FALSE,
			 FALSE)
			 
colours= list(c('white', "#EE8811", "#FF0000", "#110000"),
		  	  c('white', "#EE8811", "#FF0000", "#110000"),
			  c('white', "#EE8811", "#FF0000", "#110000"),
			  c('white', "#EE8811", "#FF0000", "#110000"),
		  rev(c('white', "#EE8811", "#FF0000", "#110000")),
			  c('white', "#CCCC11", "#E9E900", "#110000"),
			  c('white', "#EE1188", "#F00099", "#110000"))

limits = list(c(0.001,.01,.02,.05,.1,.2),
		      c(0.001,.01,.02,.05,.1,.2),
		      c(0.001,.01,.02,.05,.1,.2),
		      c(0.001,.01,.02,.05,.1,.2),
			  c(0.01, 0.1, 1, 10, 100),
		      c(0.001,.01,.05,.1,.2,.5),
			  c(0.001,.01,.05,.1,.2,.5) * 10000)

scaling = c(1, 1, 1, 1, 60 * 60 * 24 * 30 * 1000, 1, 1)		

mask = NULL	  

plotDataset <- function(name, path, seasonal, scale, lims, cols) {
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
	mtext(aatitle, line = -2)
	add_raster_legend2(cols = cols, limits = lims, transpose = FALSE,
	                   plot_loc = c(0.2, 0.4, 0.8, 0.9), mar = c(-0.5, 0,0,0),
			           add = FALSE)
	
	if (seasonal) {
		plotStandardMap(pc[[1]], '', SeasonPhaseLimits, SeasonPhaseCols, add_legend = FALSE)
		mtext(paste(name, 'season timing', sep = '\n'), line = -2)
		plot_raster_from_raster(pc[[2]], limits = SeasonConcLimits, cols = SeasonConcCols, add_legend = FALSE, y_range = c(-60, 90))
		mtext(paste(name, 'season length', sep = '\n'), line = -2)
	}	
}


pdf('figs/burntAreaProducts.pdf', width = 12, height = 7)


lmat = rbind(c(1 , 5 ,  9, 13, 17),
			 c(2 , 6 , 10, 14, 18),
			 c(3 , 7 , 11, 15, 19),
			 c(4 , 8 , 12, 16, 20),
			 c(21, 23, 25, 26, 0 ),
			 c(22, 24,  0,  0, 0 ))

#lmat = matrix(1:nplots, nrow = 4)
#lmat[] = 0
#lmat[1:nplots] = 1:nplots

layout(lmat, heights = c(1, 0.3, 1, 1, 1, 0.3))
par(mar = mar0)

mapply(plotDataset, names(datasets), datasets, Seasonal, scaling, limits, colours)
 

par(mar = c(0,0,0, 20))
	SeasonLegend(SeasonPhaseLimits, SeasonPhaseCols, dat = pc[[1]])
par(mar = mar0)

add_raster_legend2(cols = SeasonConcCols, limits = SeasonPhaseLimits, 
		                  transpose = FALSE,
	                      plot_loc = c(0.2, 0.8, 0.8, 0.9), mar = c(-0.5, 0,0,0),
			              add = FALSE)

dev.off.gitWatermarkStandard()