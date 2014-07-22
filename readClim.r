#Read climate NCDF data to data list#
#
readClim<-function(file,type,window=NULL,year_select){
	model_name<-strsplit(file,"/")[[1]][length(strsplit(file,"/")[[1]])-1]
	cat("reading",type,": model[",model_name,"]\n")
	clim_past<-list()
	nc<-open.ncdf(file)
	clim_past$lon<-get.var.ncdf(nc,"lon")
	clim_past$lat<-get.var.ncdf(nc,"lat")
	clim_past$val<-get.var.ncdf(nc,type)

	brick_raster<-brick(file)
	clim_past$year_index<-substring(names(brick_raster),2,5)
	clim_past$month_index<-as.integer(substring(names(brick_raster),7,8))
	clim_past$nrows<-brick_raster@nrows
	clim_past$ncols<-brick_raster@ncols
	clim_past$dim_xmin<-extent(brick_raster)@xmin
	clim_past$dim_xmax<-extent(brick_raster)@xmax
	clim_past$dim_ymin<-extent(brick_raster)@ymin
	clim_past$dim_ymax<-extent(brick_raster)@ymax
	Month<-unique(clim_past$month_index)

	#convert lon if necessary range of lon->[-180,180]
	if(min(clim_past$lon)>-1){
		clim_past$lon<-clim_past$lon-180
	}
	
	if(length(Month)!=12)  stop(Month)
	
 	#Kelvin-->Celcius
	if(max(clim_past$val,na.rm=TRUE)>100 & type=="tas") clim_past$val<-clim_past$val-273.15
	
	#cut window
	clim_past<-extractSpaceWindow(clim_past,window)
 	clim_past<-extractTime(clim_past,year_select)
} 
