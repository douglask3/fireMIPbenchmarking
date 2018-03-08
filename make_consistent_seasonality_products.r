source("cfg.r")
memSafeFile.initialise('temp/')

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
			  
Monthly   = c(bareground_VCF 		= NA,
			  treecover_VCF			= NA,
			  lai_MODIS  	 		= TRUE,
			  lai_AVHRR  	 		= TRUE,
			  fapar_monthly_SeaWiFS = TRUE,
			  fapar_annual_SeaWiFS  = FALSE,
			  GPP_ANN			    = TRUE,    
			  GPP_HB_ANN		    = TRUE,
			  TER_ANN               = TRUE,
			  TER_HB_ANN            = TRUE,
			  GPP_MARS              = TRUE,
			  GPP_HB_MARS           = TRUE,
			  TER_MARS     			= TRUE,
			  TER_HB_MARS           = TRUE,
			  GPP_RF				= TRUE,
			  GPP_HB_RF             = TRUE,
			  TER_RF				= TRUE,
			  TER_HB_RF			    = TRUE,
			  BA_GFED4s				= TRUE,
			  carbon_veg_avitabile  = FALSE)	

mask_file = 'data/CRUNCEP.precip.r0d5.1997.2013.nc'
			  
filenames[] = paste(data_dir.BenchmarkData, filenames, sep ='/')

mask = is.na(raster(mask_file))

mnths2annualAverage <- function(dat) {
	nl = nlayers(dat)
	yrs = 1:(nl/12)
	dat = layer.apply(yrs, function(yr) mean(dat[[(12*(yr-1) + 1):(12*yr)]]))
	return(dat)
}

regridAndOut <- function(filename, start, month, out_name, comment = c()) {
	comment = c("original filename" = filename,
				"script filename"   = 'make_consistent_seasonality_products.r',
				"mask from"			= "CRUNCEP.precip.r0d5.1997.2013.nc",
				monthly 			= month,
				comment,
				Contact 			= ContactDetails)
				
	dat = brick(filename)
	if (!is.na(start)) dat = dat[[start:nlayers(dat)]]
	nl = nlayers(dat)
	
	if (is.na(month)) {
		dat = mnths2annualAverage(dat)
		month = FALSE
	}
	
	out_fname <- function(nm = '') paste(outputs_dir, out_name, nm, '.nc', sep = '')
	
	resampeMask <- function(r) {
		r = raster::resample(r, mask)
		r[mask] = NaN
		r[r > 9E9] = NaN
		return(r)
	}
	
	dat = memSafeFunction(dat, resampeMask)
	writeRaster.local <- function(...) 
		writeRaster.gitInfo(..., overwrite = TRUE, comment = comment)

	aa = mean(dat)
	if (month) {
		nl = nl - baseN(nl, 12)
		dat = dat[[1:nl]]
		clim = climateologize(dat)
		pc = PolarConcentrationAndPhase(dat)
		aa = aa * 12	
		
		writeRaster.gitInfo(pc[[1]], out_fname('-phase'), overwrite = TRUE)
		writeRaster.gitInfo(pc[[2]], out_fname('-concentration'), overwrite = TRUE)
		writeRaster.gitInfo(clim, out_fname('-climateology'), overwrite = TRUE)
	}
	writeRaster.gitInfo(dat, out_fname(), overwrite = TRUE)
	writeRaster.gitInfo(aa, out_fname('-annual_average'), overwrite = TRUE)	
}

mapply(regridAndOut, filenames, Layr2000, Monthly, names(filenames))