Climate Data Interpolation
=====================

##Usage:

* Run src/main.r in R.

##GCM IPCC simulations (Old): 

### Available
1.  bccr_bcm2_0 
1.  ccma_cgcm3_1
1.  ccma_cgcm3_1_t63
1.  cnrm_cm3 
1.  csiro_mk3_0 
1.  gfdl_cm2_0 
1.  gfdl_cm2_1
1.  giss_aom
1.  giss_model_e_h
1.  iao_fgoals1_0_g
1.  ingv_echam4
1.  inmcm3_0
1.  ipsl_cm4
1.  miroc3_2_hires
1.  miroc3_2_medres
1.  miub_echo_g
1.  mpi_echam5
1.  mri_cgcm2_3_2a
1.  ncar_pcm1
1.  ukmo_hadcm3
1.  ukmo_hadgem1

### Not Available

1. ncar_ccsm3_0 (past file was divided by 4 different files)
1. giss_model_e_r (future only on year 2106)

Remarks:
--------
* warnings come from spline function
* In function `splineClim.r`, Line: `12`
	- predict.surface (before R 2.5)
	- predictSurface (after R 3.0)

## GCM simulations (New): 
	
ESGF database: <http://esgf-node.ipsl.fr/esgf-web-fe/>

* searching criterion: 
	*  project:CMIP5
	*  experiment family:RCP
	*  time frequency:mon
	*  product:output1
	*  ensemble:r1i1p1
	*  experiment:rcp26
	*  realm:atmos
* RCP 26 (17):
	 [1] "bcc-csm1-1"   "bcc-csm1-1-m" "CanESM2"      "CNRM-CM5"     "FGOALS-g2"   
	[6] "GFDL-CM3"     "GISS-E2-H"    "GISS-E2-R"    "HadGEM2-AO"   "HadGEM2-ES"  
	[11] "IPSL-CM5A-LR" "IPSL-CM5A-MR" "MPI-ESM-LR"   "MPI-ESM-MR"   "MRI-CGCM3"   
	[16] "NorESM1-M"    "NorESM1-ME"  
* RCP 45 (33): [1] "bcc-csm1-1"       "bcc-csm1-1-m"     "CanCM4"           "CanESM2"         
	[5] "CCSM4"            "CESM1-BGC"        "CESM1-CAM5"       "CESM1-CAM5-1-FV2"
	[9] "CMCC-CM"          "CMCC-CMS"         "CNRM-CM5"         "EC-EARTH"        
	[13] "FGOALS-g2"        "GFDL-CM2p1"       "GFDL-CM3"         "GFDL-ESM2G"      
	[17] "GFDL-ESM2M"       "GISS-E2-H"        "GISS-E2-H-CC"     "GISS-E2-R"       
	[21] "GISS-E2-R-CC"     "HadCM3"           "HadGEM2-AO"       "HadGEM2-CC"      
	[25] "HadGEM2-ES"       "inmcm4"           "IPSL-CM5A-LR"     "IPSL-CM5A-MR"    
	[29] "IPSL-CM5B-LR"     "MPI-ESM-LR"       "MRI-CGCM3"        "NorESM1-M"       
	[33] "NorESM1-ME"  
* RCP 85 (26):   [1] "bcc-csm1-1"       "bcc-csm1-1-m"     "CanESM2"          "CESM1-CAM5-1-FV2"
	[5] "CMCC-CESM"        "CMCC-CM"          "CMCC-CMS"         "CNRM-CM5"        
	[9] "FGOALS-g2"        "GFDL-ESM2M"       "GISS-E2-H"        "GISS-E2-H-CC"    
	[13] "GISS-E2-R"        "GISS-E2-R-CC"     "HadGEM2-AO"       "HadGEM2-CC"      
	[17] "HadGEM2-ES"       "inmcm4"           "IPSL-CM5A-MR"     "IPSL-CM5B-LR"    
	[21] "MPI-ESM-LR"       "MPI-ESM-MR"       "MRI-CGCM3"        "MRI-ESM1"        
	[25] "NorESM1-M"        "NorESM1-ME"
* __Common models__
	 [1] "bcc-csm1-1"   "bcc-csm1-1-m" "CanESM2"      "CNRM-CM5"     "FGOALS-g2"   
	 [6] "GISS-E2-H"    "GISS-E2-R"    "HadGEM2-AO"   "HadGEM2-ES"   "IPSL-CM5A-MR"
	 [11] "MPI-ESM-LR"   "MRI-CGCM3"    "NorESM1-M"    "NorESM1-ME"  
