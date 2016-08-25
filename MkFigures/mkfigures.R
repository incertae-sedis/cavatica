#! /usr/bin/env Rscript

library(ggplot2)

#par("din")[1]
#par("din")[2]

dimwidth=8
dimheight=4.916

tools<-c(system("ls data/* | tr '/' ' '| sed 's/-/ /g' | awk '{print $2}'| uniq",intern=TRUE))

for(query_term in tools){
  data<-read.table(paste("data/",query_term,"-years.ssv",sep=""),sep=" ",header=TRUE)
  
  p<-qplot(data$year,fill=I('royalblue'),binwidth=0.5,xlab="Year of Publication",ylab="Number of papers",
    main=paste("PubMed Articles containing '",query_term,"'; n=",length(data$year),sep=""))+
    scale_x_continuous(breaks=seq(1996,2016,1),limits=c(1995.5,2016.5))+
    theme_bw()+
    geom_text(stat='count',aes(label=..count..),vjust=-0.25)+
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

  if(ggplot_build(p)$panel$ranges[[1]]$y.range[2]<10){
    p<-qplot(data$year,fill=I('royalblue'),binwidth=0.5,xlab="Year of Publication",ylab="Number of papers",
      main=paste("PubMed Articles containing '",query_term,"'; n=",length(data$year),sep=""))+
      scale_x_continuous(breaks=seq(1996,2016,1),limits=c(1995.5,2016.5))+
      scale_y_continuous(breaks=seq(0,10,2),limits=c(-0.5,10))+
      theme_bw()+
      geom_text(stat='count',aes(label=..count..),vjust=-0.25)+
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  }

  ggsave(filename=paste(query_term,"-pubmedcounts.png",sep=""),plot=p,width=dimwidth,height=dimheight,dpi=600)
}

```