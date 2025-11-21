## 03-Bat trait merge
## briana.a.betke-1@ou.edu

## clean environment & plots
rm(list=ls()) 
graphics.off()

## packages
library(tidyverse)

# read in trait data
traits <- readRDS("/Users/brianabetke/Desktop/batlinks/bat traits/synurbic and traits only.rds")

# clean out aggregated species virus data
traits <- traits %>% select(!c(vfam, Virus, dum_virus, zoo_sp, zfam, dum_zvirus))

# read in virus data
virus <- read.csv("/Users/brianabetke/Desktop/batlinks/flat files/virus data to bat phylo.csv")

# merge
data <- merge(virus[c("species","fam_links","VirusFamily","association","status","new_links")], traits, by = "species", all.x = T)

# save as rds for easier data cleaning
saveRDS(data,"/Users/brianabetke/Desktop/batlinks/flat files/virus data to bat traits.rds")

# csv for dan
write.csv(data, "/Users/brianabetke/Desktop/batlinks/flat files/virus data to bat traits.csv")

# look at how many anthro species are not included
# this should be unique bat species
anthro <- data %>% filter(Synurbic ==1) 
length(unique(anthro$species)) #244 anthro roosty species out of 511 species in traits.



