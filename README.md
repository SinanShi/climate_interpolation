Climate Data Interpolation
=====================

Usage:
--------
1. Run src/main.r in R.


 GCM simulations: 
-----------------------
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


