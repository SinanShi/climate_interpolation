#############################
#This program is to interpolate and analysis GCMs from different models,
#and generate a list of quantile confidence map from the interpolated data.
#interpolation method: spline
#interpolated data = high_res + spline(low_res_future-low_res_past)
#Basic data type:
#		|+-lon
#		|+-lat
#		|+-val [lon, lat, time] #time correspond to year_index and month_index
#		|+-year_index
#		|+-month_index
#		|+-nrows 
#		|+-ncols
#		|+-dim_xmin
#		|+-dim_xmax
#		|+-dim_ymin
#		|+-dim_ymax
#	
#list_interpolated: it stores all interpolated data that have been processed
#		|+-simulation: (e.g. bccr_bcm2_0)
#			|+-lon
#			|+-lat
#			|+-val [lon, lat, time] 
#			|+-year_index
#			|+-month_index
#
#QuantileMap: 
#		|+-lon
#		|+-lat
#		|+-val_p0.05 [lon, lat, time] 
#		|+-val_p0.5 [lon, lat, time] 
#		|+-val_p0.95 [lon, lat, time] 
#		|+....
#		|+-year_index
#		|+-month_index
#
#			Sinan SHI  22.07.2014
#############################
CLIMTYPE<-"tas"

#-----------
#setting working directories
#-----------
if(CLIMTYPE=="tas"){
	FUTURE_DIR<-paste(dir,"predicted_tas/SRESA1b_FUTURE/",sep="")
	PAST_DIR<-paste(dir,"predicted_tas/20C3M_PAST/",sep="")
	HIGH_RES_DIR<-paste(dir,"High_Resolution_Clim/",sep="")
	OUT_DIR<-paste(dir,"RESULTS/",sep="")
}
if(CLIMTYPE=="pre"){
	FUTURE_DIR<-paste(dir,"predicted_prec/SRESA1b_FUTURE/",sep="")
	PAST_DIR<-paste(dir,"predicted_prec/20C3M_PAST/",sep="")
	HIGH_RES_DIR<-paste(dir,"High_Resolution_Clim/",sep="")
	OUT_DIR<-paste(dir,"RESULTS/",sep="")
}

#-----------
#Setting configurations
#-----------
CUT_WINDOW<-c(-15,45,25,52)#lon,lon,lat,lat
#GCM<-dir(PAST_DIR)#compute all exsiting GCMs
GCM<-c("bccr_bcm2_0","ccma_cgcm3_1","ccma_cgcm3_1_t63", "cnrm_cm3" ,       
 "csiro_mk3_0","gfdl_cm2_0","gfdl_cm2_1","giss_aom",        
 "giss_model_e_h","iao_fgoals1_0_g","ingv_echam4",    
 "inmcm3_0", "ipsl_cm4","miroc3_2_hires","miroc3_2_medres",
 "miub_echo_g","mpi_echam5", "mri_cgcm2_3_2a","ncar_pcm1",       
"ukmo_hadcm3","ukmo_hadgem1" )   
NUM_GCM<-length(GCM)
CONTROL_YEAR_PAST<-c(1961:1990)
SELEC_YEAR_FUTURE<-c(2001:2090) #period have to be dividable to NYEARS
SELEC_MONTH_FUTURE<-c(1)
NYEARS<-30# average of nyears
PROBS_QUANTILE<-c(0.05,0.5,0.95)


PLOT<-TRUE
STORE<-"MEM" #To chose storaging data on hard "DISk"  or on "MEM"emory 
source(paste(dir,"header.r",sep=""))



#=============================
#main program
#=============================

time.exp<-format(Sys.time(), "%b%d-%H%M")
if(STORE=="DISK") out_dir<-paste(paste(OUT_DIR,CLIMTYPE,"/",time.exp,sep=""))
#read high resolution data
if(!exists("cru_raster_10min_window")){
	cru_table_10min<-read.csv(paste(HIGH_RES_DIR,"10_mn_temp.csv",sep=""),sep=";")
	cru_table_10min_window<-cutCruTable2Window(cru_table_10min)
	cru_raster_10min_window<-cruTable2raster(cru_table_10min_window)
}

list_interpolated<-list()
 for(i in 1:NUM_GCM){
	future_dir<-paste(FUTURE_DIR,GCM[i],"/",sep="")
	past_dir<-paste(PAST_DIR,GCM[i],"/",sep="")
	past_nc_file<-paste(past_dir,list.files(path=past_dir,pattern=".nc"),sep="")
	future_nc_file<-paste(future_dir,list.files(path=future_dir,pattern=".nc"),sep="")
	if(length(past_nc_file)!=1){
		stop("more than 1 file in the directory!")
	}
	
	#Reading data
	tas_past<-readClim(past_nc_file,type="tas",window=CUT_WINDOW,year_select=CONTROL_YEAR_PAST)
	tas_past<-getEachMonth(tas_past)
	tas_future<-readClim(future_nc_file,type="tas",window=CUT_WINDOW,year_select=SELEC_YEAR_FUTURE)
	
	#Processing data
	tas_future<-meanClim(tas_future,NYEARS,SELEC_MONTH_FUTURE)
	
	#interpolating data
	map_interpolated<-splineClim(tas_past,tas_future,cru_raster_10min_window)
	if(STORE=="MEM"){
		list_interpolated[[GCM[i]]]<-map_interpolated
	}
	if(STORE=="DISK"){
		cat("saving interpolated data into",out_dir,"\n")
		save(file=paste(out_dir,"/",GCM[i],"_tas.Rdata",sep=""),map_interpolated)
	}
}
#get quantile map	
QuantileMap<-getQuantileMap(list_interpolated, PROBS_QUANTILE)
	


			
	
	
	
		


 
