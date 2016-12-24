#install.packages("RISmed")
#install.packages("ggplot2")
library(RISmed)
library(ggplot2)
dimwidth=8
dimheight=4.916

# =================================== Start Analysis
terms <- read.table("../config.txt",sep=" ",stringsAsFactors=FALSE,header=FALSE)
terms <- c(terms$V1)
query_term <- terms[1]
res <- EUtilsSummary(query_term,type='esearch',db='pubmed',datetype='pdat',mindate=1996,maxdate=2016,retmax=10000)
#QueryCount(res)

pmids <- EUtilsGet(res)

data <- data.frame(year=YearPubmed(EUtilsGet(res)),title=ArticleTitle(EUtilsGet(res)))
data <- data.frame(year=YearPubmed(pmids),title=ArticleTitle(pmids))

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

p

