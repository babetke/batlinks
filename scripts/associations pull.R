## Bat-virus association pull
## briana.a.betke-1@ou.edu

## clean environment & plots
rm(list=ls()) 
graphics.off()

## packages
library(tidyverse)
library(vroom)
library(ape)

## load VIRION
# V8 of virion
virion <- vroom(file = "/Users/brianabetke/outputs/15692263/virion.csv.gz")

# update host names to capitalize to be consistent with PREDICT names
virion$Host <- Hmisc::capitalize(virion$Host)

# Pull all chiroptera, including PREDICT which is capitalized
bats <- virion %>% filter(HostOrder == "chiroptera"| HostOrder =="Chiroptera")

# NCBI ratified hosts and viruses
bats <- bats %>% filter(HostNCBIResolved==T & VirusNCBIResolved==T)

# clear out NAs for host, virus, and virus family
bats <- bats %>% drop_na(Host, Virus) %>% filter(!is.na(VirusFamily))

# trim to PCR and iso detections only 
bats <- bats %>% filter(DetectionMethod == "PCR/Sequencing" | DetectionMethod == "Isolation/Observation") 

# Unique associations
bats <- bats %>% mutate(sp_links = paste(Host,Virus,sep = "-")) %>% filter(!duplicated(sp_links))

# associations only
bats <- bats %>% select(sp_links, Host, Virus, VirusFamily)

# should we mark zoonotic associations?
# pull human viruses
humans <- virion %>% filter(Host == "Homo sapiens")
humans <- humans %>% filter(HostNCBIResolved==T & VirusNCBIResolved==T)
humans <- humans %>% drop_na(Host, Virus) %>% filter(!is.na(VirusFamily))
humans <- humans %>% filter(DetectionMethod == "PCR/Sequencing" | DetectionMethod == "Isolation/Observation") 
hvir <- unique(humans$Virus)

# label as 1 if in common with bats
bats <- bats %>% mutate(zoonotic = ifelse(Virus %in% hvir,1,0))

# family associations
bats <- bats %>% select(sp_links, Host, Virus, VirusFamily, zoonotic) %>% mutate(fam_links = paste(Host,VirusFamily, sep="-"))

# look at unique
fams <- bats %>% filter(!duplicated(fam_links)) %>% select(fam_links, Host, VirusFamily)

# should the zoonotic species be aggregated? just to keep track of how many
# zoonotic detections within the family there are?

# save as flat files or virus data for now

write.csv(bats, "/Users/brianabetke/Desktop/batlinks/batlinks/virus association data/bat-virus species associations.csv", row.names = FALSE)
write.csv(fams, "/Users/brianabetke/Desktop/batlinks/batlinks/virus association data/bat-virus family associations.csv", row.names = FALSE)

