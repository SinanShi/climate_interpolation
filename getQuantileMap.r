 
getQuantileMap<-function(list_interpolated,probs){ 
	cat("start computing quantile map...\n")
	sim_name<-names(list_interpolated)
	sim_num<-length(sim_name)
	QuantileMap<-list_interpolated[[sim_name[1]]]
	QuantileMap$val<-array(NA, dim(QuantileMap$val))
	for(p in 1:length(probs)){
		QuantileMap[[paste("val_p",probs[p],sep="")]]<-array(NA, dim(QuantileMap$val))
	}
	QuantileMap$val<-NULL
	#check month and year index identical
	for(i in 1:sim_num){
		if((!identical(list_interpolated[[sim_name[1]]]$year_index,list_interpolated[[sim_name[i]]]$year_index))
		||(!identical(list_interpolated[[sim_name[1]]]$month_index,list_interpolated[[sim_name[i]]]$month_index))){
			stop("map year and month index must be identical.\n")
		}
	}
	
	for(i in 1:length(list_interpolated[[sim_name[1]]]$year_index)){
		map_multisim<-array(NA,c(dim(list_interpolated[[1]]$val)[1:2],sim_num))
		for(j in 1:sim_num){
			map_multisim[,,j]<-list_interpolated[[sim_name[j]]]$val[,,i]
		}
		qmap_single<-apply(map_multisim,c(1,2), quantile, probs = probs,  na.rm = TRUE)
		
		if(length(probs)==1)  QuantileMap[[paste("val_p",probs,sep="")]][,,i]<-qmap_single
		else{
			for(p in 1:length(probs)){
				QuantileMap[[paste("val_p",probs[p],sep="")]][,,i]<-qmap_single[p,,]
				}
		}
		cat("\b\b\b\b\b\b\b\b",as.integer(i/length(list_interpolated[[sim_name[1]]]$year_index)*100),"%",sep="")
	}
	cat("\b\b\b\b\b\b\b\b\b\b\b\n")
	return(QuantileMap)
	
}