## 02 virus family data to bat phylogeny
## briana.a.betke-1@ou.edu

## clean environment & plots
rm(list=ls())
graphics.off()

## packages
library(tidyverse)
library(ape)
#library(Hmisc) #caps corrected in previous files
#library(plyr)

## load species-level virus data
setwd("/Users/brianabetke/Desktop/batlinks")
virus=read.csv("virus association data/bat-virus family links.csv")

## load in Upham phylogeny
tree=read.nexus('phylos/MamPhy_fullPosterior_BDvr_Completed_5911sp_topoCons_NDexp_MCC_v2_target.tre')

## load in taxonomy
taxa=read.csv('phylos/taxonomy_mamPhy_5911species.csv',header=T)
taxa=taxa[taxa$ord=="CHIROPTERA",]
taxa$tip=taxa$Species_Name

## trim phylo to bats
tree=keep.tip(tree,taxa$tiplabel)

## fix tip
tree$tip.label=sapply(strsplit(tree$tip.label,'_'),function(x) paste(x[1],x[2],sep=' '))
taxa$species=sapply(strsplit(taxa$tip,'_'),function(x) paste(x[1],x[2],sep=' '))

## correct VIRION names
virus$species=virus$Host
virus$Host=NULL

## which names in VIRION aren't in Upham
setdiff(virus$species,taxa$species)

# fix genus modifications
virus$species <- gsub("Neoeptesicus|Cnephaeus","Eptesicus", virus$species)

# more difs
setdiff(virus$species,taxa$species)

## match manually
virus$species=plyr::revalue(virus$species,
                            c("Artibeus cinereus" = "Dermanura cinereus",
                              "Artibeus glaucus"="Dermanura glaucus",
                              "Artibeus toltecus"="Dermanura toltecus",
                              "Doryrhina cyclops"="Hipposideros cyclops",
                              "Epomophorus dobsonii" = "Epomops dobsonii",
                              "Epomophorus pusillus" = "Micropteropus pusillus",
                              "Glossophaga mutica" = "Glossophaga soricia",
                              "Hypsugo alaschanicus"="Pipistrellus alaschanicus",
                              "Hypsugo pulveratus"="Pipistrellus pulveratus",
                              "Hypsugo savii"="Pipistrellus savii",
                              #"Kerivoula furva" = "Kerivoula titania",
                              "Laephotis capensis"="Neoromicia capensis",
                              "Lyroderma lyra"="Megaderma lyra",
                              "Macronycteris commersonii"="Hipposideros commersoni",
                              "Macronycteris gigas"="Hipposideros gigas",
                              "Macronycteris vittatus"="Hipposideros vittatus",
                              #"Miniopterus africanus"="Miniopterus inflatus",
                              #"Molossus nigricans"="Molossus rufus",
                              "Mops plicatus"="Chaerephon plicatus",
                              "Mops pumilus" = "Chaerephon pumilus",
                              "Murina feae"="Murina aurata",
                              "Neoromicia somalicus"="Neoromicia somalica",
                              #"Myotis oxygnathus"="Myotis blythii",
                              "Nycticeinops crassulus"="Pipistrellus crassulus",
                              #Otomops harrisoni
                              "Rhinolophus hildebrandti" = "Rhinolophus hildebrandtii",
                              "Perimyotis subflavus"="Pipistrellus subflavus",
                              "Plecotus gaisleri"="Plecotus teneriffae",
                              "Pseudoromicia brunnea"="Neoromicia brunnea",
                              "Pseudoromicia tenuipinnis"="Neoromicia tenuipinnis"
                            ))

## recheck missing
setdiff(virus$species,taxa$species)

## remove missing
virus=virus[!virus$species%in%setdiff(virus$species,taxa$species),]

# ## do we have duplicate species names after taxonomic matching?
# virus[duplicated(virus$species),] # there are duplicates because of the links

# need to update the links with the new names
# new links col
virus$new_links <- paste(virus$species, virus$VirusFamily, sep="-") 

## clean taxonomy file
taxa=taxa[c("species","gen","fam","clade","MSW3_sciName_matched","tip")]

## merge with species
data=merge(virus,taxa,by="species",all.x=T)

## remove X col
data$X <- NULL

# write csv
write.csv(data, "flat files/virus data to bat phylo.csv",row.names = FALSE)

