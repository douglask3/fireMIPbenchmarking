
source('cfg.r')
names = c('fire', "LAI", 'vegCarbon')
comparisons  = list(c("GFED4s.Spatial",  "GFAS"), c("LAImodis"), c("carvalhais_cveg"))
units =             c('frac Month-1' = '%', 'gC m-2 mn-1' = 'g C ~m-2~ ~yr-1~', 
                      'm2 m-2' = '~m2~ ~m-2~', 'Mg Ha-1' = 'Mg ~ha-1~')
startYear    =      c(1998, 2000, 1997, 2001)
timestep     =      c('Months', 'Months', 'Months', 'Years')
plotSeason   =      c(TRUE            ,  FALSE , FALSE, FALSE)
titles       = list(list(c('a) GFED4s burnt area', 
			   'g) Simulated burnt area', 
			   'm) Performance in burnt area'),
			 c('b) GFED4s seasonal phase', 
			   'h) Simulated seasonal phase',    
			   'n) Performance in seasonal phase'),
			 c('c) GFED4s seasonal concentration',
  			   'i) Simulated seasonal concentration', 
			   'o) Performance in seasonal concentration')),
		    list(c('d) GFAS fire emissions', 
			   'j) Simulated fire emissions',
                           'p) Performance in fire emissions')),		
		    list(c('e) MODIS Leaf Area Index',
			   'k) Simulated Lead Area Index',
			   'q) Performance in Leaf Area Index')),
                    list(c('f) Carvalhais vegetative carbon',
                           'l) Simulated vegetative carbon',
                           'r) Performance in vegetative carbon')))
		   
scale  = list(1200, 12, 1, c(12/120, 1/12))
						   
res = 0.5
openOnly = TRUE
range = c(1.2, 2.0, 3.0, 5.0)
range = 5
e_lims = list(c(1, 1))

nmodLims  = seq(10, 90, 10)
nmodeCols = rev(c('#276419', '#4d9221', '#7fbc41', '#b8e186',# '#f7f7f7',)
              '#f1b6da', '#de77ae', '#c51b7d', '#8e0152'))

source('run.r')
limits = list(GFED4s.Spatial$plotArgs$limits*100,
		   GFAS$plotArgs$limits,
                   LAImodis$plotArgs$limits,
		   cveg$plotArgs$limits)
		   
cols   = list(GFED4s.Spatial$plotArgs$cols,
		   GFAS$plotArgs$cols,
                   LAImodis$plotArgs$cols,
		   cveg$plotArgs$cols)

if (length(names) > 1) out = unlist(out, recursive = FALSE)

plotAgreement <- function(x, txt, limits = nmodLims, cols = nmodeCols, e_lims, ...) {
        ePatternRes = (4/3) * 32.5/res(x)[1]
	plotStandardMap(x, '',  limits = limits, cols = cols,
			add_legend = FALSE, e_polygon = FALSE, ePatternRes = ePatternRes, 
					ePatternThick = 0.7, limits_error = e_lims, ...)
	mtext(txt, side = 3, adj = 0.1, line = -1.2)
}

plotLegend <- function(cols, limits, plot_loc = c(0.3, 0.7, 0.7, 0.9), ...) {
	add_raster_legend2(cols = cols, limits = limits, ylabposScling = 1.1,srt = 0,
						   transpose = FALSE, plot_loc = plot_loc, 
						   add = FALSE, nx  = 1.75, ...)
}

plotSpatialNmod <- function(dat, txt, index, limits, cols, range, scale,
                            varunit, units, startYear, timestep, e_lims, ...) {
    if (FALSE) {
        fnames = sapply(txt[[1]], function(i) strsplit(i, ') ')[[1]][2])
        vname  = paste(strsplit(fnames[1], ' ')[[1]][-1], collapse = '_')

        dir = paste0('outputs/', vname, '/')
        makeDir(dir)

        fnames = gsub(' ', '_', fnames, fixed = TRUE)
        fnames[1] = paste0(dir, fnames[1])

        zname = paste('no.', timestep, 'since', startYear)
    
        writeOut <- function(r, fname) {
            if (nlayers(r) == 1) zname = 'Annual Average'
            writeRaster.gitInfo(r, file = fname, varname = vname, varunit = varunit, 
                                zname = zname, overwrite = TRUE)
        }

        writeOut(dat[[1]], fnames[1])

        fnames = paste0(dir, names(dat[[2]]), '-', fnames[2])
        mapply(writeOut, dat[[2]], fnames)
    }
    if (length(scale) == 1) scale = rep(scale, 2)
    obs = mean(dat[[1]][[index]])
	
    plotAgreement(obs * scale[1], txt[[1]][1], limits, cols)
	
        MeanFun <- function(r) {
            index = index[sapply(index, function(i) any(i == 1:nlayers(r)))]
            return(mean(r[[index]]))
        }
	mod = layer.apply(dat[[2]], MeanFun)
        mn = mean(mod, na.rm = TRUE)
        mn[is.na(obs)] = NaN
	plotAgreement(mn * scale[2], txt[[1]][2], limits, cols,
				  e = sd.raster(mod), e_lims = e_lims)
	
	lower = obs / range
	upper = obs * range
	upper[upper < 0.001] = 0.001
	nmod = mean(mod >= lower & mod <= upper, na.rm = TRUE) * 100
	mask = sum(is.na(mod))
	mask = min.raster(mask) < mask
	nmod[mask] = NaN
        
	plotAgreement(nmod, txt[[1]][3], e_lims = e_lims)
	plotLegend(cols, limits, extend_max = TRUE, units = units)#, e_lims = e_lims)
}



plotSeasonalNmod <- function(dat, txt, index, range, e_lims, ...) {
	
	mnthRange =  6 * (1- 1/range)
	obs = PolarConcentrationAndPhase(dat[[1]][[index]], phase_units = 'months')
	mod = lapply(dat[[2]][-c(5,8)], function(i) PolarConcentrationAndPhase(i[[index]], phase_units = 'months'))
	
	obsP = obs[[1]]
	plotAgreement(obsP, txt[[2]][1], SeasonPhaseLimits, SeasonPhaseCols, e_lims)
	SeasonLegend(SeasonPhaseLimits, SeasonPhaseCols, dat = modPmean,
				 mar = rep(0,4), add = TRUE, xp = 1.08, e_lims = e_lims)
	
	modP = layer.apply(mod, function(i) i[[1]])
	
	xP = mean(cos(modP * 2 * pi / 12), na.rm = TRUE)
	yP = mean(sin(modP * 2 * pi / 12), na.rm = TRUE)
	modPmean = atans(yP, xP)
	modPmean[is.na(obsP)] = NaN
	
	xP = sd.raster(cos(modP * 2 * pi / 12))
	yP = sd.raster(sin(modP * 2 * pi / 12))
	modPsd = atans(yP, xP)
	modPsd[is.na(obsP)] = NaN
	
	plotAgreement(modPmean, txt[[2]][2], SeasonPhaseLimits, SeasonPhaseCols,
	              e_lims = e_lims, e = modPsd / 3)
	SeasonLegend(SeasonPhaseLimits, SeasonPhaseCols, dat = modPmean, mar = rep(0,4),
				 add = TRUE, xp = 0.08)#, e_lims = e_lims)
	
	diff = abs(obsP - modP)
	nmod = diff < mnthRange | diff > 12 - mnthRange	
	nmod = mean(nmod, na.rm = TRUE) * 100
	plotAgreement(nmod, txt[[2]][3], e_lims = e_lims)
	
	plot.new()
	plot.new()
	
	obsC = obs[[2]]
	plotAgreement(obsC, txt[[3]][1], SeasonConcLimits, SeasonConcCols, e_lims)
	
	modC  = layer.apply(mod, function(i) i[[2]])
	modCm = mean(modC, na.rm = TRUE)
	modCm[is.na(obsP)] = NaN
	sdC = sd.raster(modC, FALSE) / sqrt(vartrunc("norm", 0, 1))
	sdC[is.na(obsP)] = NaN
	
	plotAgreement(modCm, txt[[3]][2], SeasonConcLimits, SeasonConcCols, 
	              e_lims = e_lims, e = sdC)
	
	lower = obsC ^ range
	upper = obsC ^ (1/range)
	
	nmod = mean(modC >= lower & modC <= upper, na.rm = TRUE) * 100
	plotAgreement(nmod, txt[[3]][3], e_lims = e_lims)
	
	plotLegend(SeasonConcCols, SeasonConcLimits, maxLab = 1)#, e_lims = e_lims)
}


plotVariable <- function(dat, pltSeason, txt, 
			 limits, cols, add_extra_leg, 
			  index = NULL, range, ...) {
    if (class(dat) == "list" && length(dat) == 1) dat = dat[[1]]
    #if (class(dat) == "list" && length(dat) == 2 && is.null(dat[[1]])) dat = dat[[2]]
    
    if (nlayers(dat[[1]]) == 1) index = 1
    else if (is.null(index)) index = 1:nlayers(dat[[1]])
	
    dat[[2]] = dat[[2]][!sapply(dat[[2]], is.null)]
	
    plotSpatialNmod(dat, txt, index, limits, cols, range, ...)
    if (pltSeason) {
	plot.new()
	plotSeasonalNmod(dat, txt, index, range, ...)
    }
	
    if (add_extra_leg)
        plotLegend(nmodeCols, nmodLims, 
                   plot_loc = c(0.1, 0.9, 0.7, 0.9),
		   labelss = c(0, nmodLims, 100))
    else plot.new()
}


for (r in range) for (es in e_lims) {		
    nrow = length(plotSeason) + sum(plotSeason) * 2
	
    lmat = index = t(matrix(c(1:3,4,4,5), ncol = 2))
    for (i in 2:nrow) lmat = rbind(lmat, index + (i-1) * 5)
	
    fname = paste('figs/nmodAgreement', '-R', r - 1, '-sd', paste(es, collapse='-'), '.png', sep = '')
    png(fname, height = 2 * nrow, width = 10, unit = 'in', res = 300)
	layout(lmat, heights = c(1, 0.2, 1, 0.01, 1, 0.2, 1, 0.2, 1, 0.2, 1, 0.2))
        par(mar = rep(0, 4), oma = c(0, 0, 2, 0))
		
	mapply(plotVariable, out, plotSeason, titles, limits, cols, c(F, F, F, T), 
               scale = scale, varunit = names(units), units = units, startYear = startYear,
               timestep = timestep, 
               MoreArgs = list(range = r, e_lims = es))			   
    dev.off()#.gitWatermarkStandard()
}


names = c('fire')
comparisons  = list(c("NRfire",  "meanFire"))
units =             c('no. fires' = 'no.', 'km2' = 'k~m2~')
startYear    =      c(2002, 2002)
timestep     =      c('Years', 'Years')
plotSeason   =      c( FALSE , FALSE)
titles       = list(list(c('a) Hantson no. of fires', 
			   'c) Simulated no. of fires',
                           'nn')),
		    list(c('b) Hantson mean fire size', 
			   'd) Simulated mean fire size',
                           'nn')))

scale  = c(1,1)
						   
res = NULL
openOnly = TRUE

source('run.r')

meanRaster.scaling <- function(r) {
    areaR = raster::area(r, na.rm = TRUE)
    out = sum.raster(r * areaR, na.rm = TRUE) / sum.raster(areaR, na.rm = TRUE)
    return(out)
}

scaleOut <- function(r) {
    obs_sc = meanRaster.scaling(r[[1]])
    rescale <- function(ri) {
        if (is.null(ri)) return(NULL)
        ri = mean(ri)
        ri[is.na(r[[1]][[1]])] = NaN
        mod_sc = meanRaster.scaling(ri)
        ri = ri * obs_sc / mod_sc
        return(ri)
    }
    r[[2]] = lapply(r[[2]], rescale)
    return(r)
}

out = lapply(out, scaleOut)


limits = list(NRfire$plotArgs$limits,
	      meanFire$plotArgs$limits)
		   
cols   = list(NRfire$plotArgs$cols,
	      meanFire$plotArgs$cols)

nrow = 2
nrow = length(plotSeason) + sum(plotSeason) * 2
lmat = index = t(matrix(c(1:3,4,4,5), ncol = 2))
for (i in 2:nrow) lmat = rbind(lmat, index + (i-1) * 5)
fname = paste('figs/fireSize_no.png', sep = '')
png(fname, height = 2.1 * nrow, width = 10, unit = 'in', res = 300)
    layout(lmat, heights = c(1, 0.2, 1, 0.2))
    par(mar = rep(0, 4), oma = c(0, 0, 2, 0))
    mapply(plotVariable, out, plotSeason, titles, limits, cols, c(F, T), 
           scale = scale, varunit = names(units), units = units, startYear = startYear,
               timestep = timestep, MoreArgs = list(range = r, e_lims = e_lims[[1]]))			   
dev.off()#.gitWatermarkStandard()

