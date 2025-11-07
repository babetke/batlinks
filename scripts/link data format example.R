## dummy h-v association edgelist
tmp=data.frame(host=c("a","a","b","c","b","d"),
               virus=c("v1","v2","v3","v1","v4","v1"))

## unique
tmp$link=paste0(tmp$host,"-",tmp$virus)
tmp$association=1

## expand grid
all=expand.grid(host=unique(tmp$host),
            virus=unique(tmp$virus))

## unique
all$link=paste0(all$host,"-",all$virus)

## merge
test=merge(all,tmp[c("link","association")],by="link",all.x=T)

## if NA, pseudoabsence
test$known=ifelse(is.na(test$association),0,test$association)

