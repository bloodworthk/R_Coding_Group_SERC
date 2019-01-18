#### Soy Div Working Group Analysis ####
#Coders: Kathryn Bloodworth, Kristina Borst, Ben Taylor
#Purspose: Learning Stuff about Soybeans

#### Working Directories ####

#Ben WD
setwd("C:/Users/Benton/Desktop/Work Files/Courses Taught/R Study Group_SERC/Soy Div_R_Coding_Group_SERC")

#Kathryn WD
setwd("~/Dropbox (Smithsonian)/SERC Ecosystem Conservation/R_Coding_Working_Group/Soy_Div_2018_R_Coding_Group")


#Kristina WD

#### Read in the dataframes ####
#read in "Garden_Height_Leaves_Herbivory_Data_2018.csv" and call it plnts 
plnts <- read_csv("Garden_Height_Leaves_Herbivory_Data_2018.csv",  col_types = cols(bed_num = col_factor(levels = c("1",  "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14",  "15", "16")), 
                                                                                                                       date = col_date(format = "%m/%d/%Y"), 
                                                                            height_cm = col_number(), plant_num = col_character(), 
                                                                             warming = col_factor(levels = c("0", "1"))))

div<-read.csv("Diversity_Treatment_2018.csv")
herb<-read.csv("Warming_Garden_Percent_Herbivory_2018.csv")
ins<-read.csv("2018_Insect_Counts.csv")

#### Install Packages ####
#install.packages("ggplot2")
library(ggplot2)#load the package ggplot2
install.packages("tidyverse")#install the package tidyverse
library(tidyverse)#load the package tidyverse

### Starting to put the dataframes together for analyses ###
#Merging the diversity treatments into the plant height dataframe
div.mrg<-div[,c(2,5)]#makes a smaller diversity dataframe with just plant number and diversity
dat<-merge(plnts,div.mrg,by="plant_num", all.x=T,all.y=T)#makes a new dataframe with plnts and div combined

#Merging the insect count data into the plant height dataframe
ins.mrg<-ins[,c(3:8)]#gets just the columns in the ins data we need to merge
dat<-merge(dat,ins.mrg,by="plant_num",all.x=T,all.y=T)#merges the insect counts into the big "dat" dataframe
setdiff(plnts$plant_num,ins.mrg$plant_num)

#Merging the final assessment of herbivory into the dataframe
last.herb<-herb[herb$date=="8/24/2018",]
herb.mrg<-data.frame("plant_num"=sort(unique(last.herb$plant_num)),
                     "perc_herbivory"=with(last.herb, tapply(perc_herbivory,plant_num,mean, na.rm=T)))
dat<-merge(dat,herb.mrg,by="plant_num",all.x=T,all.y=T)


dat.fin<-dat[dat$date=="2018-09-20",]
dat.fin<-dat.fin[!is.na(dat.fin$plant_num),]

dat.fin$nasties<-(dat.fin$Aphids+dat.fin$Large_Ants+dat.fin$Small_Ants)



