library(ncdf)
library(raster)
library(rgeos)
library(maps)
library(fields) 

dir<-file.path()
source(paste(dir,"utile.r",sep=""))
source(paste(dir,"readClim.r",sep=""))
source(paste(dir,"meanClim.r",sep=""))
source(paste(dir,"splineClim.r",sep=""))
source(paste(dir,"getQuantileMap.r",sep=""))     


