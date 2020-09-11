########################
## cfg and set stuff ##
#######################
source("cfg.r")

# location of model output
mod_dir = "LGM/data/ModelOutputs/"

# variable name in model nc files
mod_varname = "tas_anom"

# location of file for observations
obs_file = 'LGM/data/benchmarkData/data_MAT_all.csv'

modgrid = FALSE

################
## open stuff ##
################
mod_files = list.files(mod_dir, full.name = TRUE)
mods = lapply(mod_files, brick, varname = mod_varname)
mods = lapply(mods, mean)

obs = read.csv(obs_file)

#############
## compare ##
#############
makeComparison <- function(mod) {
    ## finds location of obs in model cells
    xy = xyFromCell(mod, c(1:length(mod)))
    
    xstep = min(abs(diff(xy[,1])))
    ystep = min(abs(diff(xy[,1])))
    idIze <- function(cords) {        
        xid = which(abs(cords['lon'] -  xy[,1]) < ystep/2)
        yid = which(abs(cords['lat'] -  xy[,2]) < ystep/2)
        intersect(xid, yid)[1]
    }
    xyid = apply(obs[,1:2], 1, idIze)
    if (modgrid) xyidU = unique(xyid) else xyidU = xyid
    
    ## pairs obs and simulation
    vmod = values(mod)
    amod = raster::area(mod)
    obsSim <- function(xyidU) {
        out = c(mean(obs[which(xyid == xyidU),3]), vmod[xyidU]) 
        if (modgrid) out = c(out, amod[xyidU]) else out = c(out, 1)
        return(out)
    }
    
    ## runs the comparisons
    obsSims = sapply(xyidU, obsSim)
    score(NME(obsSims[1,], obsSims[2,], w =  obsSims[3,]))
}

scores = sapply(mod, makeComparison)

null_scores = summary(null.NME(obs[,3]))

############
## output ##
############
out = cbind(null_scores[1], null_scores[2],
            null_scores[3]- null_scores[4], null_scores[3]+ null_scores[4],
            scores)
colnames(out) = c("median_null", "mean_null", "RR_lower_null", "RR_upper_null", mod_files)
write.csv(file = paste0(mod_varname, '_annual_avaerage_NME.csv'), out)
