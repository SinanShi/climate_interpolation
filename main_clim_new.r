#clim new
PLOT<<-TRUE
SELEC_MONTH_FUTURE<-c(1)
NYEARS<-1# average of nyears
source(paste(dir,"climate_interpolation/header.r",sep=""))
CLIMTYPE<-"tas"
dir<-"/home/sinan/workspace/RCP_exp1/"
if(CLIMTYPE=="tas"){
	HIGH_RES_DIR<-paste(dir,"climate_interpolation/High_Resolution_Clim/",sep="")
	MODELS_DIR<-paste(dir,"RCP26/",CLIMTYPE,"/",sep="")
	OUT_DIR<-paste(dir,"RESULTS/",sep="")
}
if(CLIMTYPE=="pre"){
	HIGH_RES_DIR<-paste(dir,"climate_interpolation/High_Resolution_Clim/",sep="")
	MODELS_DIR<-paste(dir,"RCP26/",CLIMTYPE,"/",sep="")
	OUT_DIR<-paste(dir,"RESULTS/",sep="")
}


GCM<-dir(MODELS_DIR)
NUM_GCM<-length(GCM)
CUT_WINDOW<-c(-15,45,25,52)#lon,lon,lat,lat
CONTROL_YEAR<-10

#read high resolution data
if(!exists("cru_raster_10min_window")){
	cru_table_10min<-read.csv(paste(HIGH_RES_DIR,"10_mn_temp.csv",sep=""),sep=";")
	cru_table_10min_window<-cutCruTable2Window(cru_table_10min)
	cru_raster_10min_window<-cruTable2raster(cru_table_10min_window)
}

for(i in 1:NUM_GCM){
	model_dir<-paste(MODELS_DIR,GCM[i],"/",sep="")
	nc_file<-paste(model_dir,list.files(path=model_dir,pattern=".nc"),sep="")
	if(length(nc_file)!=1){
		stop("more than 1 ncdf file in the directory!")
	}
	
	clim_control<-readClim(nc_file,type=CLIMTYPE,window=CUT_WINDOW,year_select=c(NA,2020))
	clim_control<-getEachMonth(clim_control)
	clim_future<-readClim(nc_file,type=CLIMTYPE,window=CUT_WINDOW,year_select=c(NA,2099))
	
	clim_future<-meanClim(clim_future,NYEARS,SELEC_MONTH_FUTURE)
	delta<-clim_future
	delta$val<-clim_future$val
	map_interpolated<-splineClim(clim_control,clim_future,cru_raster_10min_window)
	
}


