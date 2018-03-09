source("cfg.r")



filenames = c(bareground_VCF 		= 'bareground2000-2014.nc',
			  treecover_VCF			= 'treecover2000-2014.nc',
			  lai_MODIS  	 		= 'lai_0.5x0.5_2000-2005.nc',
			  lai_AVHRR  	 		= 'lai_0.5x0.5_1982-2009.nc',
			  fapar_monthly_SeaWiFS = 'SeaWiFS_fapar_monthly.nc',
			  fapar_annual_SeaWiFS  = 'SeaWiFs_fapar_annual.nc',
			  GPP_ANN			    = "CRUNCEPv6.ANN.GPP.monthly.1980_2013.nc",    
			  GPP_HB_ANN		    = "CRUNCEPv6.ANN.GPP_HB.monthly.1980_2013.nc",
			  TER_ANN               = "CRUNCEPv6.ANN.TER.monthly.1980_2013.nc",
			  TER_HB_ANN            = "CRUNCEPv6.ANN.TER_HB.monthly.1980_2013.nc",
			  GPP_MARS              = "CRUNCEPv6.MARS.GPP.monthly.1980_2013.nc",
			  GPP_HB_MARS           = "CRUNCEPv6.MARS.GPP_HB.monthly.1980_2013.nc",
			  TER_MARS     			= "CRUNCEPv6.MARS.TER.monthly.1980_2013.nc",
			  TER_HB_MARS           = "CRUNCEPv6.MARS.TER_HB.monthly.1980_2013.nc",
			  GPP_RF				= "CRUNCEPv6.RF.GPP.monthly.1980_2013.nc",
			  GPP_HB_RF             = "CRUNCEPv6.RF.GPP_HB.monthly.1980_2013.nc",
			  TER_RF				= "CRUNCEPv6.RF.TER.monthly.1980_2013.nc",
			  TER_HB_RF			    = "CRUNCEPv6.RF.TER_HB.monthly.1980_2013.nc",
			  BA_GFED4s				= 'GFED4s_v2.nc',
			  carbon_veg_avitabile  = "avitabile_carbon_veg_05.nc")
			  
Layr0     = c(bareground_VCF 		= 2000,
			  treecover_VCF			= 2000,
			  lai_MODIS  	 		= 2001,
			  lai_AVHRR  	 		= 2000,
			  fapar_monthly_SeaWiFS = 2000,
			  fapar_annual_SeaWiFS  = 2000,
			  GPP_ANN			    = 2000,    
			  GPP_HB_ANN		    = 2000,
			  TER_ANN               = 2000,
			  TER_HB_ANN            = 2000,
			  GPP_MARS              = 2000,
			  GPP_HB_MARS           = 2000,
			  TER_MARS     			= 2000,
			  TER_HB_MARS           = 2000,
			  GPP_RF				= 2000,
			  GPP_HB_RF             = 2000,
			  TER_RF				= 2000,
			  TER_HB_RF			    = 2000,
			  BA_GFED4s				= 2000,
			  carbon_veg_avitabile  = 2000)
			  
Layr2000 = c(bareground_VCF 		= 1,
			  treecover_VCF			= 1,
			  lai_MODIS  	 		= 12,
			  lai_AVHRR  	 		= 217,
			  fapar_monthly_SeaWiFS = 25,
			  fapar_annual_SeaWiFS  = 3,
			  GPP_ANN			    = 121,    
			  GPP_HB_ANN		    = 121,
			  TER_ANN               = 121,
			  TER_HB_ANN            = 121,
			  GPP_MARS              = 121,
			  GPP_HB_MARS           = 121,
			  TER_MARS     			= 121,
			  TER_HB_MARS           = 121,
			  GPP_RF				= 121,
			  GPP_HB_RF             = 121,
			  TER_RF				= 121,
			  TER_HB_RF			    = 121,
			  BA_GFED4s				= 121,
			  carbon_veg_avitabile  = 1)
			  
Monthly   = c(bareground_VCF 		= 'NA',
			  treecover_VCF			= 'NA',
			  lai_MODIS  	 		= 'TRUE',
			  lai_AVHRR  	 		= 'TRUE',
			  fapar_monthly_SeaWiFS = 'TRUE',
			  fapar_annual_SeaWiFS  = 'FALSE',
			  GPP_ANN			    = 'Scale',    
			  GPP_HB_ANN		    = 'Scale',
			  TER_ANN               = 'Scale',
			  TER_HB_ANN            = 'Scale',
			  GPP_MARS              = 'Scale',
			  GPP_HB_MARS           = 'Scale',
			  TER_MARS     			= 'Scale',
			  TER_HB_MARS           = 'Scale',
			  GPP_RF				= 'Scale',
			  GPP_HB_RF             = 'Scale',
			  TER_RF				= 'Scale',
			  TER_HB_RF			    = 'Scale',
			  BA_GFED4s				= 'Scale',
			  carbon_veg_avitabile  = FALSE)			  
			  
Units     = c(bareground_VCF 		= "%",
			  treecover_VCF			= "%",
			  lai_MODIS  	 		= "m2/m2",
			  lai_AVHRR  	 		= "m2/m2",
			  fapar_monthly_SeaWiFS = "",
			  fapar_annual_SeaWiFS  = "",
			  GPP_ANN			    = "gC m-2",    
			  GPP_HB_ANN		    = "gC m-2",
			  TER_ANN               = "gC m-2",
			  TER_HB_ANN            = "gC m-2",
			  GPP_MARS              = "gC m-2",
			  GPP_HB_MARS           = "gC m-2",
			  TER_MARS     			= "gC m-2",
			  TER_HB_MARS           = "gC m-2",
			  GPP_RF				= "gC m-2",
			  GPP_HB_RF             = "gC m-2",
			  TER_RF				= "gC m-2",
			  TER_HB_RF			    = "gC m-2",
			  BA_GFED4s				= "fraction",
			  carbon_veg_avitabile  = "gC m-2")
			  
Scaling   = c(bareground_VCF 		= 1,
			  treecover_VCF			= 1,
			  lai_MODIS  	 		= 1,
			  lai_AVHRR  	 		= 1,
			  fapar_monthly_SeaWiFS = 1,
			  fapar_annual_SeaWiFS  = 1,
			  GPP_ANN			    = 30,    
			  GPP_HB_ANN		    = 30,
			  TER_ANN               = 30,
			  TER_HB_ANN            = 30,
			  GPP_MARS              = 30,
			  GPP_HB_MARS           = 30,
			  TER_MARS     			= 30,
			  TER_HB_MARS           = 30,
			  GPP_RF				= 30,
			  GPP_HB_RF             = 30,
			  TER_RF				= 30,
			  TER_HB_RF			    = 30,
			  BA_GFED4s				= 1,
			  carbon_veg_avitabile  = 30)
	

mask_file = 'data/CRUNCEP.precip.r0d5.1997.2013.nc'
			  
filenames[] = paste(data_dir.BenchmarkData, filenames, sep ='/')

mask = is.na(raster(mask_file))

mnths2annualAverage <- function(dat) {
	nl = nlayers(dat)
	yrs = 1:(nl/12)
	dat = layer.apply(yrs, function(yr) mean(dat[[(12*(yr-1) + 1):(12*yr)]]))
	return(dat)
}

regridAndOut <- function(filename, start, yr1, month, out_name, unit, scale, comment = c()) {
	memSafeFile.remove()
	memSafeFile.initialise('temp/')
	comment = c("original filename" = filename,
				"script filename"   = 'make_consistent_seasonality_products.r',
				"mask from"			= "CRUNCEP.precip.r0d5.1997.2013.nc",
				monthly 			= month,
				comment,
				Contact 			= ContactDetails)
				
	dat = brick(filename)
	if (!is.na(start)) dat = dat[[start:nlayers(dat)]]
	nl = nlayers(dat)
	
	if (month == 'NA') {
		dat = mnths2annualAverage(dat)
		month = FALSE
	}
	
	out_fname <- function(nm = '') paste(outputs_dir, out_name, nm, '.nc', sep = '')
	
	resampeMask <- function(r) {
		r = raster::resample(r, mask)
		r[mask] = NaN
		r[r > 9E9] = NaN
		r = r * scale
		return(r)
	}
	
	dat = memSafeFunction(dat, resampeMask)
	
	writeRaster.local <- function(...) 
		writeRaster.gitInfo(..., overwrite = TRUE, comment = comment,
						    varname = out_name, varunit = unit)

	aa = mean(dat)
	
	if (month == 'Scale' || month == 'TRUE') {
		nl = nl - baseN(nl, 12)
		dat = dat[[1:nl]]
		clim = climateologize(dat)
		
		pc = PolarConcentrationAndPhase(dat, phase_units='months')
		if (month == 'Scale') aa = aa * 12	
		
		zraw = seq(yr1, by = 1/12, length.out = nl) + 1/24
		
		writeRaster.local(pc[[1]], out_fname('-phase'        ))
		writeRaster.local(pc[[2]], out_fname('-concentration'))
		writeRaster.local(clim   , out_fname('-climateology' ), 
						    zname = 'time', zunit = 'month')	
		
	} else  zraw = seq(yr1, length.out = nl)
	writeRaster.local(aa , out_fname('-annual_average'))
	if (nl > 1) {
		fname = out_fname()
		writeRaster.local(dat, fname, zname = 'time', zunit = 'year')
		nc = nc_open(fname, write = TRUE)
		ncvar_put(nc, 'time', zraw)
		nc_close(nc)
	}
}

mapply(regridAndOut, filenames, Layr2000, Layr0, Monthly, names(filenames), Units, Scaling)
memSafeFile.remove('temp/')