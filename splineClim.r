splineClim<-function(clim_past,clim_future,cru_hr_raster){
	cat("interpolating (spline)...\n")
	output<-list()
	output$val<-array(NA,c(dim(cru_hr_raster$val)[1:2],length(clim_future$month_index)))
	output$year_index<-vector()
	output$month_index<-vector()
	
	for(i in 1:length(clim_future$month_index)){
		delta<-clim_future$val[,,i]-clim_past$val[,,which(clim_past$month_index==clim_future$month_index[i])]
		input_dataframe<-raster2dataframe(delta,clim_future$lon,clim_future$lat)
		Sp<- Tps(input_dataframe[,1:2],input_dataframe$val, scale.type="unscaled")
 		delta_interpolated<-predict.surface(Sp,nx=dim(cru_hr_raster$val)[1],ny=dim(cru_hr_raster$val)[2])
 		output$val[,,i]<-delta_interpolated$z+cru_hr_raster$val[,,clim_future$month_index[i]]
 		output$year_index<-c(output$year_index,clim_future$year_index[i])
 		output$month_index<-c(output$month_index,clim_future$month_index[i])
 		
 		
 		if(PLOT==TRUE){
			par(mfrow=c(2,2))
			image.plot(clim_future$lon,clim_future$lat,delta)
			image.plot(delta_interpolated)
			title(paste(clim_future$year_index[i],"-",clim_future$month_index[i]))
			image.plot(output$val[,,i])
		}
	}
	output$lon<-delta_interpolated$x
	output$lat<-delta_interpolated$y
	return(output)
}
		
		
		
		
splineClim2<-function(delta, cru_hr_raster,type){
	cat("interpolating (spline)...\n")
	output<-list()
	output$val<-array(NA,c(dim(cru_hr_raster$val)[1:2],length(delta$month_index)))
	output$year_index<-vector()
	output$month_index<-vector()
# 	


	for(i in 1:length(delta$month_index)){
		input_dataframe<-raster2dataframe(delta$val[,,i],delta$lon,delta$lat)
		Sp<- Tps(input_dataframe[,1:2],input_dataframe$val, scale.type="unscaled",lon.lat=TRUE)
		delta_interpolated<-predict.surface(Sp,nx=dim(cru_hr_raster$val)[1]*1.5,
											ny=dim(cru_hr_raster$val)[2]*1.5, 
											extrap=T)
		delta_interpolated_<-superPosMap(
			delta_interpolated$z,delta_interpolated$x,delta_interpolated$y,
			cru_hr_raster$lon,cru_hr_raster$lat)
		
		clim_type<-strsplit(type,split="")[[1]][1]
	
# 		if(clim_type=="t")
			output$val[,,i]<-delta_interpolated_+cru_hr_raster$val[,,delta$month_index[i]]
# 		if(clim_type=="p")
# 			output$val[,,i]<-delta_interpolated_*cru_hr_raster$val[,,delta$month_index[i]]
			
 		output$year_index<-c(output$year_index,delta$year_index[i])
 		output$month_index<-c(output$month_index,delta$month_index[i])
#  		
 		if(PLOT==TRUE){
			#bitmap(paste(NAME,"_",i,".jpeg",sep=""))
			par(mfrow=c(2,2))
			image.plot(delta$lon,delta$lat,delta$val[,,i])
 			image.plot(cru_hr_raster$lon,cru_hr_raster$lat,delta_interpolated_)
			
			image.plot(cru_hr_raster$lon,cru_hr_raster$lat,cru_hr_raster$val[,,delta$month_index[i]])
			image.plot(output$val[,,i])
			title(paste(delta$year_index[i],"-",delta$month_index[i]))
			#dev.off()
			#browser()
		}
 	}
# 		
	output$lon<-cru_hr_raster$lon
	output$lat<-cru_hr_raster$lat
	return(output)
}
		
