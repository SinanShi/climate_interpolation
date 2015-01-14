#Read climate NCDF data to data list#
#year_select: the range of years, while the value is equal to NA, it starts from the smallest year of the file or largest
readClim<-function(file,type,window=NULL,year_select){
	model_name<-strsplit(file,"/")[[1]][length(strsplit(file,"/")[[1]])-1]
	cat("reading",type,": model[",model_name,"]\n")
	clim<-list()

	brick_raster<-brick(file)
	nc_year<-as.numeric(substring(names(brick_raster),2,5))
	if(is.na(year_select[1]))
	{
		year_select[1]<-min(nc_year)
	}
	else
	{
		if(year_select[1]<min(nc_year))  
			stop("year_select outranged!  ",year_select[1],"<",min(nc_year))
	}
	if(is.na(year_select[2]))
	{
		year_select[2]<-max(nc_year)
	}else
	{
		if(year_select[2]>max(nc_year))  
			stop("year_select outranged!  ",year_select[2],">",min(nc_yeaer))
	}
	
	nc_year_index_select<-which(nc_year>=year_select[1]&nc_year<=year_select[2])
	nc_start<-min(nc_year_index_select)
	nc_count<-max(nc_year_index_select)-min(nc_year_index_select)+1
	
	
	
	clim$year_index<-substring(names(brick_raster),2,5)[nc_year_index_select]
	clim$month_index<-as.integer(substring(names(brick_raster),7,8))[nc_year_index_select]
	clim$nrows<-brick_raster@nrows
	clim$ncols<-brick_raster@ncols
	clim$dim_xmin<-extent(brick_raster)@xmin
	clim$dim_xmax<-extent(brick_raster)@xmax
	clim$dim_ymin<-extent(brick_raster)@ymin
	clim$dim_ymax<-extent(brick_raster)@ymax
	Month<-unique(clim$month_index)
	
	nc<-open.ncdf(file)
	clim$lon<-get.var.ncdf(nc,"lon")
	clim$lat<-get.var.ncdf(nc,"lat")
 	clim$val<-get.var.ncdf(nc,type,start=c(1,1,nc_start),count=c(-1,-1,nc_count))

	#convert lon if necessary range of lon->[-180,180]
	if(min(clim$lon)>-1){
		clim$lon<-clim$lon-180
	}
	
	if(length(Month)!=12)  stop(Month)
	
 	#Kelvin-->Celcius
	if(max(clim$val,na.rm=TRUE)>100 & type=="tas") clim$val<-clim$val-273.15
	
	#cut window
	clim<-extractSpaceWindow(clim,window)
 	clim
} 


