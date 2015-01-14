library(ncdf)
library(raster)
library(rgeos)
library(maps)
library(fields) 

source(paste(dir,"climate_interpolation/","utile.r",sep=""))
source(paste(dir,"climate_interpolation/","readClim.r",sep=""))
source(paste(dir,"climate_interpolation/","meanClim.r",sep=""))
source(paste(dir,"climate_interpolation/","splineClim.r",sep=""))
source(paste(dir,"climate_interpolation/","getQuantileMap.r",sep=""))     


