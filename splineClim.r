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