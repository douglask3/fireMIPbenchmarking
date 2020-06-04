source("cfg.r")
sourceAllLibs("cfg/")

dir = 'data/benchmarkData/'

temp_file = 'temp/benchmarkDatasetFigures3.Rd'

pnames = list(c("a) GFED4s burnt area"    , 'b) GFED4s seasonal phase'    , 'c) GFED4s seasonal concentration'     ),
              c("d) GFED4 burnt area"     , 'e) GFED4 seasonal phase'     , 'f) GFED4 seasonal concentration'      ),
              c("g) MCD45 burnt area"     , 'h) MCD45 seasonal phase'     , 'i) MCD45 seasonal concentration'      ),
              c("j) Fire CCI41 burnt area", 'k) Fire CCI41 seasonal phase', 'l) Fire CCI41 seasonal concentration' ),
              c("m) Fire CCI51 burnt area", 'n) Fire CCI51 seasonal phase', 'o) Fire CCI51 seasonal concentration' ),
              c('p) GFAS fire emissions'  , 'q) GFAS seasonal phase'      , 'r) GAS seasonal concentration'        ),
              c('t) Hantson no. of fires'),
              c('u) Hantson mean fire size'),
              c('v) MODIS leaf area index'), 
              c("w) AVHRR leaf area index"),
              c('ad) Avitabile vegetative carbon'),
              c('ae) Carvalhais biomass carbon'),
              c("z) Jung GPP", 'y) Jung seasonal phase', 'z) Jung seasonal concentration'),
              c("aa) Site GPP"), 
              c("ab) Michaletz NPP"),
              c("ac) Site NPP"),
              c("af) EMDI NPP"))

pnameIAVplot = 's) Fire interannual variablity'

files = c('GFED4s_v2.nc', 'GFED4.nc', 'MCD45.nc', 'meris.nc', 'MODIS250_q_BA_regridded0.5.nc',
          'GFAS.nc', 'NRfire-nr_fire.nc', 'NRfire-mean_fire.nc',
          'lai_0.5x0.5_2000-2005.nc', 'lai_0.5x0.5_1982-2009.nc', 'avitabile_carbon_veg_05.nc',
          'Carvalhais.cVeg_50.360.720.1-1.nc',
          'CRUNCEPv6.ANN.GPP.monthly.1980_2013.nc', 'GPP6.csv', 'NNP_Michaletz_2014_single.csv',
          'NPP.csv', 'EMDI_NPP.csv')

scale = c(rep(12*100, 5),
          12*60 * 60 *24*30*1000, 1, 1, 
          1, 1,1,
          1/50,
          1000, 1, 1, 
          1, 1)

isSeasonal = c(TRUE, TRUE, TRUE, TRUE, TRUE,
               TRUE, FALSE, FALSE, 
               FALSE, FALSE, FALSE, FALSE,
               TRUE, FALSE, FALSE, FALSE, FALSE)

isIAV      = list(TRUE, TRUE, TRUE, FALSE, TRUE, 
                  TRUE, FALSE, FALSE, 
                  FALSE, FALSE, FALSE,
                  FALSE,          
                  FALSE, FALSE, FALSE, 
                  FALSE, FALSE)

startYr   = c(1998, 1998, 2006, 2001, 2001,
              2001, NaN, NaN,
              NaN, NaN, NaN,
              NaN, NaN, NaN,
              NaN, NaN, NaN)

line_col = c('red', 'orange', 'cyan', 'blue', '#330033',
             'black', NaN, NaN,
              NaN, NaN, NaN,
              NaN, NaN, NaN,
              NaN, NaN, NaN)

line_lty = c(1, 1, 1, 1, 1, 
             2, NaN, NaN,
              NaN, NaN, NaN,
              NaN, NaN, NaN,
              NaN, NaN, NaN)

layers    = list(1:204, 1:204, 1:96, 1:36, 1:156,       
                 1:175, 1, 1, 
                 12:71, 228:336, 1,
                 1,
                 1:360, NULL,NULL,
                 NULL, NULL)

addLegend = c(FALSE, FALSE, FALSE, FALSE, NA, 
              TRUE, TRUE, TRUE,
              TRUE, TRUE, TRUE, 
              TRUE, TRUE, TRUE, FALSE, 
              FALSE, TRUE) 

extend_max = list(NULL, NULL, NULL, NULL, FALSE, 
                  TRUE, TRUE, TRUE,
                  TRUE, TRUE, TRUE, 
                  TRUE,
                  TRUE, TRUE, NULL, 
                  NULL, TRUE) 

maxLab     = list(NULL, NULL, NULL, NULL, 100, 
                  NULL, NULL, NULL,
                  NULL, NULL, NULL,
                  NULL,
                  NULL, NULL, NULL,
                  NULL, NULL) 

BA_limits = GFED4s.Spatial$plotArgs$limits*100
limits = list(BA_limits, BA_limits, BA_limits, BA_limits, BA_limits,
	      GFAS$plotArgs$limits, NRfire$plotArgs$limits, meanFire$plotArgs$limits,
              LAImodis$plotArgs$limits,  LAImodis$plotArgs$limits, cveg$plotArgs$limits,
              cveg$plotArgs$limits,
              GPP$limits, GPP$limits, NPP$limits,
              NPP$limits, NPP$limits)

limits = lapply(limits, function(i) c(0,i))

BA_cols = GFED4s.Spatial$plotArgs$cols		   
cols = list(BA_cols, BA_cols, BA_cols, BA_cols, BA_cols,
	      GFAS$plotArgs$cols, NRfire$plotArgs$cols, meanFire$plotArgs$cols,
              LAImodis$plotArgs$cols,  LAImodis$plotArgs$cols, cveg$plotArgs$cols,
              cveg$plotArgs$cols,
              GPP$cols, GPP$cols, NPP$cols,
              NPP$cols, NPP$cols)


openNcDat <- function(file, layers, isSeasonal, isIAV) {
    print(file)
    dat = brick(file)[[layers]]
    out = mean(dat)
    test = out > 9E9
    out[test] = NaN
    dat[test] = NaN
    if (isSeasonal) out = c(out, PolarConcentrationAndPhase(dat, phase_units='months'))
    if (isIAV) {
        yrs = 1:(nlayers(dat)/12)
        sumYrs <-function(yr) {
            mn = (12*(yr-1) + 1):(12*yr)
            return(sum(dat[[mn]]))
        }
        iav = layer.apply(yrs, sumYrs)
        iav = iav * raster::area(iav[[1]])
        iav = layer.apply(iav, sum.raster)
        iav = list(unlist(iav))
        out = c(out, iav)
    } 
    return(out)
}

openCsvDat <- function(file) {
    dat = read.csv(file)
    print(colnames(file))
    return(dat)
}

openDat <- function(file, ...) {
    nc_test = grepl('.nc', file, fixed = TRUE)
    if (nc_test) dat = openNcDat(file, ...)
    else dat = openCsvDat(file)
    return(dat)
}

if (file.exists(temp_file)) {
    load(temp_file)
} else {     
    dat = mapply(openDat, paste0(dir, files), layers, isSeasonal, isIAV)
    save(dat, file = temp_file)
}

plotMap <- function(r, limits, cols) 
    plotStandardMap(r, '', limits, cols, add_legend = FALSE)

plotLegend <- function(cols, limits, plot_loc = c(0.35, 0.85, 0.03, 0.06), ...) {
	add_raster_legend2(cols = cols, limits = limits, ylabposScling = 1.1,srt = 0,
						   transpose = FALSE, plot_loc = plot_loc, 
						   add = TRUE, nx  = 1.75, oneSideLabels = FALSE, ...)
}

lmat = t(matrix(1:18, nrow = 3))
lmat = rbind(lmat, c(32, 19, 20),21:23, c(24,25,0), 28:30, c(26, 27, 31)) 
png('figs/BenchmarkFig.png', height = 18, width = 10, units = 'in', res = 300)
layout(lmat)
par(mar = rep(0,4))
plotMaps <- function(r, scale, nm, addLegend, limits, cols, extend_max, maxLab) {
    print(nm)
    print(extend_max)
    if (is.raster(r)) {
        plotMap(r * scale, limits, cols)
        mtext(side = 3, nm, adj = 0.05, line = -1.2)
        if (addLegend) plotLegend(cols, limits, extend_max = extend_max, maxLab = maxLab) 
    } else if (is.data.frame(r)) {
        plotMap(dat[[1]][[1]]/9E9, c(9E9, 9E9), c("white", "white"))
        r[,3] = cut_results(r[,3], limits)

        colsp =  make_col_vector(cols, ncol = length(limits)+1)[r[,3]]
        points(r[,2], r[,1], pch = 19, cex = 0.5, col = colsp)
        colsp = make.transparent(colsp, 0.95)
        for (cex in seq(2, 0.1, -0.1))
            points(r[,2], r[,1], pch = 19, cex = 0.5, col = colsp)

        mtext(side = 3, nm, adj = 0.05, line = -1.2 ) 
        if (addLegend) plotLegend(cols, limits, extend_max = extend_max, maxLab = maxLab)   
    } else if (is.list(dat)) {
        plotMap(r[[1]] * scale, limits, cols)
        mtext(side = 3, nm[[1]], adj = 0.05, line = -1.2)   
        if (is.na(addLegend) || addLegend)
            plotLegend(cols, limits,extend_max = extend_max, maxLab = maxLab)

        plotMap(r[[2]][[1]], SeasonPhaseLimits, SeasonPhaseCols)
        mtext(side = 3, nm[[2]], adj = 0.05, line = -1.2)
        if (!is.na(addLegend) && addLegend)
            SeasonLegend(SeasonPhaseLimits, SeasonPhaseCols, mar = rep(0,4),
                         add = TRUE, xp = 0.72, yp = 0.05, radius = 0.05)

        plotMap(r[[2]][[2]], SeasonConcLimits , SeasonConcCols )
        mtext(side = 3, nm[[3]], adj = 0.05, line = -1)
        if(!is.na(addLegend) && addLegend)
            plotLegend(SeasonConcCols, SeasonConcLimits*100, maxLab=100)
    } else {
        browser()
    }
    return(r)
}

dat = mapply(plotMaps, dat, scale, pnames, addLegend, limits, cols, extend_max, maxLab)
    

iav_test = sapply(dat, length)==3 & sapply(dat, function(i) is.raster(i[[1]]))

dat = lapply(dat[iav_test], function(i) i[[3]])
startYr = startYr[iav_test]
line_col = line_col[iav_test]
line_lty =line_lty[iav_test] 

endYr = startYr + sapply(dat, length) - 1
dat0 = dat


dat = dat0
dat[1:4] = lapply(dat[1:4], '/', 10000)
dat[[5]] = dat[[5]] *60 * 60 *24*30/1000

d_range = range(unlist(dat[1:4])) 
p_range = d_range
p_range[1] = p_range[1]   - 50
Yrs =  mapply(':', startYr, endYr)   
par(mar = c(2, 3.2, 1.5, 3.2))
plot(c(1998, 2012), p_range, type = 'n', xlab = '', ylab = '')
grid()
emis = dat[[5]]

scale_d <- function(x) {
    x = (x - min(emis) + 0.02) / (max(emis) - min(emis)+0.05)
    x = x * diff(d_range) + d_range[1]
}
dat[[5]] =  scale_d(dat[[5]])
mapply(lines, Yrs, dat, col = line_col, lty = line_lty, lwd = 2)

labels = seq(0.0, 4000, 100)
at = scale_d(labels)
axis(4, at = at, labels = labels)
mtext(side = 2, 'Burnt area (Mha)', line = 2)    
mtext(side = 4, 'Emission (TgC)', line = 2.1)  

legend('bottom', col = line_col, lty = line_lty, lwd = 2,
       c('GFED4s', 'GFED', 'Fire CCI41', 'Fire CCI51', 'GFAS'), bty = 'n', ncol = 3,
      x.intersp=0.0, y.intersp=0.67)
mtext(side = 3, 's) Inter-annual', adj = 0.05)
dev.off()
