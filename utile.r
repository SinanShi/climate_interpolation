 
extractTime<-function(clim_list,year_select){
	if(max(year_select)>max(clim_list$year_index)||
		min(year_select)<min(clim_list$year_index)){
			cat("Year range:",min(clim_list$year_index),max(clim_list$year_index),"\n")
			stop("selected years out side of data range!\n")
	}
	year_select_index<-c(min(which(clim_list$year_index==min(year_select))):
		max(which(clim_list$year_index==max(year_select))))
	clim_list$val<-clim_list$val[,,year_select_index]
	clim_list$year_index<-clim_list$year_index[year_select_index]
	clim_list$month_index<-clim_list$month_index[year_select_index]
	return(clim_list)
}

extractSpaceWindow<-function(clim_list,window){
	if(is.null(window)){
		return(clim_list)
	}else{		
		ind_lon<-which(clim_list$lon>=window[1]&clim_list$lon<=window[2])
		ind_lat<-which(clim_list$lat>window[3]&clim_list$lat<window[4])
		clim_list$val<-clim_list$val[ind_lon,ind_lat,]
		clim_list$lon<-clim_list$lon[ind_lon]
		clim_list$lat<-clim_list$lat[ind_lat]
		return(clim_list)
	}
}
	
getEachMonth<-function(clim_list){
	mean_monthly<-array(0, c(dim(clim_list$val[,,1])[1:2],12))
	for(i in 1:12){
		index<-which(as.integer(clim_list$month_index)==i)
		for(j in 1:length(index)){
			mean_monthly[,,i]<-mean_monthly[,,i]+clim_list$val[,,index[j]]
		}
		mean_monthly[,,i]<-mean_monthly[,,i]/length(index)
	}
	clim_list$month_index<-c(1:12)
	minyear<-min(as.matrix(as.data.frame(strsplit(clim_list$year_index,"-"))))
	maxyear<-max(as.matrix(as.data.frame(strsplit(clim_list$year_index,"-"))))
	clim_list$year_index<-rep(minyear,12)
	clim_list$val<-mean_monthly
return(clim_list)
}
		
		
selectClimYear<-function(clim_list,year_select){
	if(min(clim_list$year_index)>min(year_select) || max(clim_list$year_index)<max(year_select))
		stop("selected year",min(year_select),max(year_select), "is outside of climate list range",
			min(clim_list$year_index),	max(clim_list$year_index))
	selectyear_index<-vector()
	for(i in 1:length(year_select)){
		selectyear_index<-c(selectyear_index,which(clim_list$year_index==year_select[i]))
	}
	
	clim_list$val<-clim_list$val[,,selectyear_index]
	clim_list$month_index<-clim_list$month_index[selectyear_index]
	clim_list$year_index<-clim_list$year_index[selectyear_index]
	return(clim_list)
}


selectClimMonth<-function(clim_list,month_select){
	if(min(clim_list$month_index)>min(month_select) || max(clim_list$month_index)<max(month_select))
		stop("selected month",min(month_select),max(month_select), "is outside of climate list range",
			min(clim_list$month_index),	max(clim_list$month_index))
	selectmonth_index<-vector()
	for(i in 1:length(month_select)){
		selectmonth_index<-c(selectmonth_index,which(clim_list$month_index==month_select[i]))
	}
	
	clim_list$val<-clim_list$val[,,selectmonth_index]
	clim_list$month_index<-clim_list$month_index[selectmonth_index]
	clim_list$year_index<-clim_list$year_index[selectmonth_index]
	return(clim_list)
}
	
raster2dataframe<-function(raster,lon_ind,lat_ind){
	lon<-vector()
	lat<-vector()
	val<-vector()
	k<-1
	for(i in 1:length(lon_ind)){
		for(j in 1:length(lat_ind)){
			lon[k]<-lon_ind[i]
			lat[k]<-lat_ind[j]
			val[k]<-raster[i,j]
			k<-k+1
		}
	}
	return(data.frame("lon"=lon,"lat"=lat,"val"=val))
}	
		

#--------------------			
#create high resolution climate [raster] in a window
#--------------------		
cutCruTable2Window<-function(gcm_hr){
	lon_hr<-gcm_hr$Lon #reversed
	lat_hr<-gcm_hr$Lat
	index_window<-which(lon_hr>CUT_WINDOW[1]&lon_hr<CUT_WINDOW[2]
							&lat_hr>CUT_WINDOW[3]&lat_hr<CUT_WINDOW[4])

	gcm_hr<-gcm_hr[index_window,]
	return(gcm_hr)
}


cruTable2raster<-function(gcm_hr){	
	index_column<-sort(unique(gcm_hr$Lon)) #lon index
	index_row<-sort(unique(gcm_hr$Lat)) #lat index	
	ncol<-length(index_column)
	nrow<-length(index_row)
	raster<-array(NA, dim=c(ncol,nrow,12))
	
	for(m in 1:12){
		month<-names(gcm_hr)[2+m]
		raw<-gcm_hr[,month]#get 1 month data in a window
		#create raster
		for(i in 1:length(raw))
			raster[which(index_column==gcm_hr$Lon[i]),which(index_row==gcm_hr$Lat[i]),m]<-raw[i]
	}
	outraster<-list()
	outraster[["lon"]]<-index_column
	outraster[["lat"]]<-index_row
	outraster[["val"]]<-raster
	
	return(outraster)
}
		

		
		


