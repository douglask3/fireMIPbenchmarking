source("cfg.r")

controlFile = '../fireMIPbenchmarking/data/ModelOutputs/Inferno/Inferno_S1_burntArea.nc'
fixedLuFile = '../fireMIPbenchmarking/data/Inferno_S2_burntArea_FLA.nc'
fixedPdFile = '../fireMIPbenchmarking/data/Inferno_S2_burntArea_FPo.nc'


colours= c('#000033', '#0022AA',  '#00EEFF', 'white', '#FFEE00', '#AA2200')
limits = c(-20, -10, -5, -2, -1, -0.1, 0.1, 2, 2, 5)

index = 3564:3720

control = stack(controlFile)[[index]]
fixedLu = stack(fixedLuFile)[[index]]
fixedPd = stack(fixedPdFile)[[index]]

control = convert_pacific_centric_2_regular(control)
fixedLu = convert_pacific_centric_2_regular(fixedLu)
fixedPd = convert_pacific_centric_2_regular(fixedPd)

control = mean(control)* (60*60*24*30) * 100 * 12
fixedLu = mean(fixedLu)* (60*60*24*30) * 100 * 12
fixedPd = mean(fixedPd)* (60*60*24*30) * 100 * 12

popdens = stack('../LimFIRE/outputs/population_density2000-2014.nc')
popdens = mean(popdens)
popdens = raster::resample(popdens, control)

crop = stack('../LimFIRE/outputs/cropland2000-2014.nc')
crop = mean(crop)
crop = raster::resample(crop, control)

#par(mfrow = c(2,1))
openFigure <- function(fname) {
	png(fname, height = 2, width = 5, units = 'in', res = 300)
	par(mar = rep(0,4))
}
openFigure('figs/noPeople-INFERNO.png')
	plot_raster_from_raster(control - fixedPd, limits = limits, cols = colours, add_legend = FALSE, y_range = c(-60, 90))
dev.off()

openFigure('figs/noLand-INFERNO.png')
	plot_raster_from_raster(control - fixedLu, limits = limits, cols = colours, add_legend = FALSE, y_range = c(-60, 90))
dev.off()

openFigure('figs/noNothing-INFERNO.png')
	plot_raster_from_raster(2*control - fixedLu - fixedPd, limits = limits, cols = colours, add_legend = FALSE, y_range = c(-60, 90))
dev.off()

plotScatter <- function(fname, x, experiment, xlab = 'population density', log = '', xmin = 0, xmax = 1) {
	png(fname)

		impact = (control - experiment) 
		test = impact < 0
		impact[test] = impact[test] / experiment[test]
		test = !test
		impact[test] = impact[test] / control[test]
		
		plot(x, impact * 100, log = log, xlim = c(0.0, 100), ylim = c(-100, 100), xlab = 'cropland (%)', ylab = 'Impact (% burnt area)')
		
		vary = x[]
		varx = impact[]
		mask = !is.na(vary) & !is.na(varx)
		x      = seq(0, 100, length.out = 1000)
		#if (log == 'x') x      = exp(x)
		y      = predict(loess( varx[mask] ~ vary[mask]), x)
		lines (x, y*100 , lwd = 2, col = 'red')
	dev.off()
}

plotScatter('figs/INFERBOfireVsPeople.png', popdens, fixedPd, log = 'x', xmin = -5, xmax = 6)
plotScatter('figs/INFERBOfireVsCrop.png'  , crop, fixedLu, xlab = 'cropland (%)')