#########################################
######  Combine odonata trait data ######
#########################################

# Powney et al. 2013 #

rm(list=ls()) # clear R

### Add data ###
odo_measures <- read.csv(paste0(getwd(),"/Data/Species_trait_measurements.csv",header=T) # add the species trait measurement data. 
odo_single <- read.csv(paste0(getwd(),"/Data/Odonata_traits_single.csv",header=T) # add the single trait per species flat file. 

### calculate the mean trait value per species - not split by sex ###
odo <- odo_measures[,c(-1:-5)] # drop unused columns

spp_list <- as.character(unique(odo$Species)) # extract a vector of species names 

spp_summary <- NULL # create the object to be filled
for (i in spp_list){
	spp_summary <- rbind(spp_summary,as.data.frame(t(colMeans(odo[odo$Species==i,3:length(odo)])))) # loop through each species and extract the mean value for each trait and build this into a data frame
}

spp_summary$Species <- spp_list # add species name onto the data frame
	
### join the new mean trait values to the single trait value per species dataset ###
odo_data <- merge(odo_single,spp_summary,all=TRUE)

### SAVE odo_data ###



