source("cfg.r")
source("cfg/Variable.fire.r")
graphics.off()

BA_limits = GFED4s.Spatial$plotArgs$limits * 100
BA_cols = GFED4s.Spatial$plotArgs$col

BA_dlimits = GFED4s.Spatial$plotArgs$dlimits * 100
BA_dcols = GFED4s.Spatial$plotArgs$dcol
SeasonConcLimits  = c(0, 0.02, 0.05, 0.1, 0.2, 0.5)
SeasonConcDlimits = c(-0.1, -0.05, -0.02, 0.02, 0.05, 0.1)

filename_dat = 'temp/spatial_fire_sm_variables2.Rd'

if (file.exists(filename_dat)) {
    load(filename_dat)
} else {
    source("cfg/Variable.other.r")
    openOnly = TRUE
    names = 'other'
    comparisons = list(c("SoilMoistureS.Season"))
    res = NULL

    source("run.r")
    out_sm = out
    test = !sapply(out_sm[[1]][[2]], is.null)
    out_sm = out_sm[[1]][[2]][test]
    pc_out_sm = lapply(out_sm, PolarConcentrationAndPhase, phase_units = 'months')

    source("cfg/Variable.fire.r")
    names = 'fire'
    comparisons = list(c("GFED4s.Spatial"))

    source("run.r")
    out_fire = out
    fire_obs = out_fire[[1]][[1]]
    out_fire = out_fire[[1]][[2]][test]
    pc_out_fire = lapply(out_fire, PolarConcentrationAndPhase, phase_units = 'months')
    a_out_fire = lapply(out_fire, function(i) mean(i)*12*100)

    save(out_sm, pc_out_sm, fire_obs, out_fire, pc_out_fire, a_out_fire, file = filename_dat)
}

mean.phase <- function(x) {
    an = x * 2 * pi / 12
    xc = sin(an)
    yc = cos(an)
    out = atans(sum(xc), sum(yc), 'months')
    #if (out >6) out = out - 12
    return(out)
}
mean.phase.raster <- function(r) {
    out = r[[1]]
    test = (max(r) - min(r)) <6
    out[ test] = apply(r[ test], 1, mean)
    out[!test] = apply(r[!test], 1, mean.phase)
    return(out)
}

diff.phase <- function(r1, r2) {
    r = r1 - r2

    test = r<(-6)
    r[test] = r[test] + 12

    test = r > 6
    r[test] = r[test] - 12
    return(r)
}
p_sm_mean = mean.phase.raster(layer.apply(pc_out_sm, function(i) i[[1]]))
p_out_sm_diff = lapply(pc_out_sm, function(i) diff.phase (i[[1]], p_sm_mean))

c_sm_mean = mean(layer.apply(pc_out_sm, function(i) i[[2]]))
c_out_sm_diff = lapply(pc_out_sm, function(i) i[[2]] - c_sm_mean)

a_fire_mean = mean(layer.apply(a_out_fire, function(i) i))
a_out_fire_diff = lapply(a_out_fire, function(i) i - a_fire_mean)

png("figs/sm_season_maps.png", height = 9, width = 7.2, units = 'in', res = 300)
layout(rbind(c(1, 1, 1, 10, 19),
             c(1, 2, 1, 10, 19),
             c(0, 2, 0, 11, 20),
             c(3, 3, 3, 12, 21),
             c(4, 4, 4, 13, 22),
             c(5, 5, 5, 14, 23),
             c(6, 6, 6, 15, 24),
             c(7, 7, 7, 16, 25),
             c(8, 8, 8, 17, 26),
             c(8, 9, 8, 17, 26),
             c(8, 9, 8, 18, 27)),
       heights = c(0.8, 0.2, 0.2, rep(1, 5), 0.8, 0.2, 0.2), widths = c(0.45, 0.5, 0.05, 1, 1))
    
par(mar = rep(0, 4), oma = c(0, 0, 0.5, 0))   

letterN = 1
plotMapFun <- function(..., txt) {
    plotStandardMap(..., txt = '')
    mtext(paste0(letters[letterN], ') ', txt), side = 3, adj = 0.05, line = -1)
    letterN <<- letterN + 1
}
txt = 'S.m. phase'
plotMapFun(p_sm_mean, limits = SeasonPhaseLimits, cols = SeasonPhaseCols,
                txt = paste(txt, '- mean'), add_legend = FALSE)
par(mar = c(1.5, 0, 0, 0))
SeasonLegend(SeasonPhaseLimits, SeasonPhaseCols)
par(mar = rep(0, 4))
mapply(plotMapFun, p_out_sm_diff, txt = Model.plotting[test,1], #paste(txt, Model.plotting[test,1]),
       MoreArgs =  list(limits = SeasonPhaseDlimits, cols = SeasonPhaseDcols, add_legend = FALSE))
par(mar = c(1.5, 0, 0, 0))
SeasonLegend(SeasonPhaseDlimits, SeasonPhaseDcols)
par(mar = rep(0, 4))
plotNonSeason <- function(txt, rm, rd, cols, lims, dcols, dlims, ...) {
    plotMapFun(rm, limits = lims, cols = cols,
                    txt = txt, add_legend = FALSE)
    add_raster_legend2(cols = cols, limits = lims, dat = rm,
                        add = FALSE, transpose = FALSE, srt = 0,
                        plot_loc = c(0.1, 0.9, 0.4, 0.7), oneSideLabels = NA, ...)
    mapply(plotMapFun, rd, txt = '',
           MoreArgs =  list(limits = dlims, cols = dcols,
                            add_legend = FALSE))

    add_raster_legend2(cols = dcols, limits = dlims,
                       dat = rd[[1]],
                       add = FALSE, transpose = FALSE, extend_max = TRUE, extend_min = TRUE,
                       plot_loc = c(0.1, 0.9, 0.4, 0.7), oneSideLabels = NA, srt = 0)
}

plotNonSeason('S.m. conc.', c_sm_mean, c_out_sm_diff, SeasonConcCols, SeasonConcLimits,
              SeasonConcDcols, SeasonConcDlimits, maxLab= 1)
plotNonSeason('Burnt area ', a_fire_mean, a_out_fire_diff, BA_cols, BA_limits,
              BA_dcols, BA_dlimits, maxLab= 100)

dev.off()


