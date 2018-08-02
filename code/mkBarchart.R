#! /usr/bin/env Rscript
# Auth: Jennifer Chang
# Date: 2018/04/23

# ===== Process Arguments
args = commandArgs(trailingOnly=TRUE)
if(length(args)<2){
  print("Not enough arguments")
  quit(save="no",status=1)
  #suppressMessages(terms <- read_delim("../config.txt",","))
}else{
  infile=args[1]
  outfile=args[2]
} 

# ===== Libraries

# ----- check.packages | Smith Danielle, https://gist.github.com/smithdanielle/9913897
check.packages <- function(pkg){
    new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
    if (length(new.pkg)) 
        install.packages(new.pkg, dependencies = TRUE, repos = "http://cran.us.r-project.org")
    sapply(pkg, require, character.only = TRUE)
}
pkgs<-c("ggplot2","readr")
check.packages(pkgs)

library(ggplot2)
library(readr)

# ===== Variables
#par("din")[1]
#par("din")[2]
dimwidth <- 19.05 # 8         # par("din")[1]  #figure dimensions
dimheight<- 11.85 # 4.916     # par("din")[2]

# ===== Load Data
print(paste("Loading: ",infile))
suppressMessages(data<-read_delim(infile,"\t"))

query_term<-infile
minyear=min(as.numeric(data$year), na.rm=TRUE)
maxyear=max(as.numeric(data$year), na.rm=TRUE)

if(length(args)>2) minyear=as.numeric(args[3])
if(length(args)>3) maxyear=as.numeric(args[4])

# ===== Barchart
title=paste("Papers in ",infile,"'; n=",length(data$year),sep="")
(p<-qplot(data$year,fill=I('royalblue'),binwidth=0.5,xlab="Year of Publication",ylab="Number of papers",
          main=title)+
          scale_x_continuous(breaks=seq(minyear,maxyear,1),limits=c((minyear-0.5),(maxyear+0.5)))+
          theme_classic()+
          geom_text(stat='count',aes(label=..count..),vjust=-0.25)+
          theme(axis.text.x = element_text(angle = 45, hjust = 1)))

# ===== Adjust if all counts are less than 10
#if(ggplot_build(p)$layout$panel_ranges[[1]]$y.range[2]<10){
#  p<-qplot(data$year,fill=I('royalblue'),binwidth=0.5,xlab="Year of Publication",ylab="Number of papers",
#           main=title)+
#    scale_x_continuous(breaks=seq(minyear,maxyear,1),limits=c((minyear-0.5),(maxyear+0.5)))+
#    scale_y_continuous(breaks=seq(0,10,2),limits=c(-0.5,10))+
 #   theme_classic()+
 #   geom_text(stat='count',aes(label=..count..),vjust=-0.25)+
#    theme(axis.text.x = element_text(angle = 45, hjust = 1))
#}

# ===== Save Barchart
ggsave(filename=outfile, plot = p,
       width = dimwidth, height=dimheight, units = "cm",
       dpi = 300)
print(paste(" ",outfile," saved",sep=""))
