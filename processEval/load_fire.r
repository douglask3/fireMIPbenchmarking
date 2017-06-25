source('cfg.r')

tempBAEfname = paste(temp_dir, 'BAGFAS', sep = '/')
tempVEGfname = paste(temp_dir, 'VEGCBN', sep = '/')

prFname = paste('../LimFIRE/data/cru_ts3.23/cru_ts3.23.',
			    c('1991.2000', '2001.2010', '2011.2014'),
				'.pre.dat.nc', sep = '')
				
prStart = 85

#########################################################################
## load  															   ##
#########################################################################
if (file.exists(tempBAEfname)) {
	load(tempBAEfname)
} else {
	source("run.fire.r")
	burntArea = list(obs = out[[2]], mod = out[[3]])
	emissions = list(obs = out[[5]], mod = out[[6]])

	save(burntArea, emissions, file = tempBAEfname)
}

if (file.exists(tempVEGfname)) {
	load(tempVEGfname)
} else {
	source("run.production.r")
	cveg = list(obs = out[[2]], mod = out[[3]])
	save(cveg, file = tempVEGfname)
}

index = prStart:(nlayers(burntArea[[1]]) + prStart -1)

pr0 = stack(prFname)[[index]]