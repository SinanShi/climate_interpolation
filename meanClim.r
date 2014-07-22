 
meanClim<-function(clim_list,meanyear_period,month_select=c(1:12)){
	year_start<-min(as.integer(clim_list$year_index))
	year_end<-max(as.integer(clim_list$year_index))
	dim3_output<-length(unique(as.integer(clim_list$year_index)))/meanyear_period
	if((dim3_output-as.integer(dim3_output))!=0) {
		stop("number of years",length(unique(clim_list$year_index)), 
		"can not be divided by meanyear_period",meanyear_period,"\n")
	}
	year_select_index<-seq(year_start,year_end,by=meanyear_period)
	
	clim_list_new<-clim_list
	clim_list_new$val<-array(NA,c(dim(clim_list$val)[1:2],12*(dim3_output)))
	clim_list_new$month_index<-vector()
	clim_list_new$year_index<-vector()
	y<-year_start
	for(i in 1:dim3_output){
		clim_select<-selectClimYear(clim_list,seq(y,(y+meanyear_period-1)))	
		clim_select<-getEachMonth(clim_select)
		for(j in 1:12){ 
			clim_list_new$val[,,(12*(i-1)+j)]<-clim_select$val[,,j]
		}
		clim_list_new$year_index<-c(clim_list_new$year_index,clim_select$year_index)
		clim_list_new$month_index<-c(clim_list_new$month_index,clim_select$month_index)
		y<-y+meanyear_period
	}
		
	clim_list_new<-selectClimMonth(clim_list_new,month_select)
	return(clim_list_new)
}