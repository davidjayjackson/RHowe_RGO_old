library(data.table)
library(ggplot2)
library(lubridate)
library(tidyverse)
library(RSQLite)
rm(list=ls())
##
# Mainly for 1874 - 1981
##
rgo <- fread("./A/g1874.txt",sep=":",header = F)
rgo$Year <-substr(rgo$V1,1,4)
rgo$Month <-substr(rgo$V1,5,6)
rgo$Day <-substr(rgo$V1,7,8)
rgo$Time <-substr(rgo$V1,9,12)
rgo$csgcgt <-substr(rgo$V1,13,20)
rgo$X1 <-substr(rgo$V1,21,22)
rgo$noaa <-substr(rgo$V1,23,24)
rgo$X2 <-substr(rgo$V1,25,25)
rgo$oua <-substr(rgo$V1,26,29)
rgo$owsa <-substr(rgo$V1,30,34)
rgo$cua <-substr(rgo$V1,36,39)
rgo$cwsa <-substr(rgo$V1,41,44)
rgo$dcsd <-substr(rgo$V1,46,50)
rgo$pahn <-substr(rgo$V1,52,56)
rgo$cld <-substr(rgo$V1,58,62)
rgo$lns <-substr(rgo$V1,64,68)
rgo$pahn <-substr(rgo$V1,72,75)
# colname(rgo)<- c('Year',"Month","Day",'time',
# 'csgcgt','noaa','oua','owsa','cua','cwsa','dcsd',
# 'pahn','cld','lns','cmd') 
rgo1 <- rgo[,.(Year,Month,Day,cwsa,lns,cld)]

rgo2 <-dir("A",full.names=T) %>% map_df(fread,sep=":",header=F)
rgo2$Year <-substr(rgo2$V1,1,4)
rgo2$Month <-substr(rgo2$V1,5,6)
rgo2$Day <-substr(rgo2$V1,7,8)
rgo2$Time <-substr(rgo2$V1,9,12)
rgo2$csgcgt <-substr(rgo2$V1,13,20)
rgo2$X1 <-substr(rgo2$V1,21,22)
rgo2$noaa <-substr(rgo2$V1,23,24)
rgo2$X2 <-substr(rgo2$V1,25,25)
rgo2$oua <-substr(rgo2$V1,26,29)
rgo2$owsa <-substr(rgo2$V1,30,34)
rgo2$cua <-substr(rgo2$V1,36,39)
rgo2$cwsa <-substr(rgo2$V1,41,44)
rgo2$dcsd <-substr(rgo2$V1,46,50)
rgo2$pahn <-substr(rgo2$V1,52,56)
rgo2$cld <-substr(rgo2$V1,58,62)
rgo2$lns <-substr(rgo2$V1,64,68)
rgo2$pahn <-substr(rgo2$V1,72,75)
##
rgo2 <- rgo2[,.(Year,Month,Day,cwsa,lns,cld)]
rgo2$Year <- as.integer(rgo2$Year)
rgo2$Month <- as.integer(rgo2$Month)
rgo2$Day <- as.integer(rgo2$Day)
rgo2$cwsa <- as.integer(rgo2$cwsa)
rgo2$lns <- as.numeric(rgo2$lns)
rgo2$cld <- as.numeric(rgo2$cld)
str(rgo2)
##
## 1982 to 2016
##
rgoB <-dir("B",full.names=T) %>% map_df(fread,sep=":",header=F)
rgoB$Year <-substr(rgoB$V1,1,4)
rgoB$Month <-substr(rgoB$V1,5,6)
rgoB$Day <-substr(rgoB$V1,7,8)
rgoB$Time <-substr(rgoB$V1,9,12)
rgoB$csgcgt <-substr(rgoB$V1,13,20)
rgoB$X1 <-substr(rgoB$V1,21,22)
rgoB$noaa <-substr(rgoB$V1,23,24)
rgoB$X2 <-substr(rgoB$V1,25,25)
rgoB$oua <-substr(rgoB$V1,26,29)
rgoB$owsa <-substr(rgoB$V1,30,34)
rgoB$cua <-substr(rgoB$V1,36,39)
rgoB$cwsa <-substr(rgoB$V1,41,44)
rgoB$dcsd <-substr(rgoB$V1,46,50)
rgoB$pahn <-substr(rgoB$V1,52,56)
rgoB$cld <-substr(rgoB$V1,58,62)
rgoB$lns <-substr(rgoB$V1,64,68)
rgoB$pahn <-substr(rgoB$V1,72,75)
##
rgoB <- rgoB[,.(Year,Month,Day,cwsa,lns,cld)]
rgoB$Year <- as.integer(rgoB$Year)
rgoB$Month <- as.integer(rgoB$Month)
rgoB$Day <- as.integer(rgoB$Day)
rgoB$cwsa <- as.integer(rgoB$cwsa)
rgoB$lns <- as.numeric(rgoB$lns)
rgoB$cld <- as.numeric(rgoB$cld)
str(rgoB)
##
##  Combine rgo2 and rgoB
RGO <- rbind(rgo2,rgoB)
RGO$Ymd <- as.Date(paste(RGO$Year, RGO$Month, RGO$Day, sep = "-"))

##
## Create and insert data in sqlite3 db.
##
RGO$Ymd <- as.character(RGO$Ymd)
db <- dbConnect(SQLite(),dbname="RGO.sqlite3")
dbWriteTable(db,"sunspot",RGO,row.names=FALSE,overwrite=TRUE)
dbListTables(db)
























