# pkgs <- c("RISmed","ggplot2")
#install.packages(pkgs)
library(RISmed)
library(ggplot2)
dimwidth=8
dimheight=4.916
# =================================== Start Analysis
terms <- read.table("../config.txt",sep=",",stringsAsFactors=FALSE,header=TRUE)
i=8
query_term <- terms$term[i]
start <-terms$start[i]
end <- terms$end[i]
res <- EUtilsSummary(query_term,type='esearch',db='pubmed',datetype='pdat',mindate=start,maxdate=end,retmax=10000)
#QueryCount(res)

pmids <- EUtilsGet(res)

data <- data.frame(year=YearPubmed(pmids),title=ArticleTitle(pmids))


p<-qplot(data$year,fill=I('royalblue'),binwidth=0.5,xlab="Year of Publication",ylab="Number of papers",
         main=paste("PubMed Articles containing '",query_term,"'; n=",length(data$year),sep=""))+
  scale_x_continuous(breaks=seq(1996,2016,1),limits=c(1995.5,2016.5))+
  theme_bw()+
  geom_text(stat='count',aes(label=..count..),vjust=-0.25)+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

if(ggplot_build(p)$layout$panel_ranges[[1]]$y.range[2]<10){
    p<-qplot(data$year,fill=I('royalblue'),binwidth=0.5,xlab="Year of Publication",ylab="Number of papers",
           main=paste("PubMed Articles containing '",query_term,"'; n=",length(data$year),sep=""))+
    scale_x_continuous(breaks=seq(1996,2016,1),limits=c(1995.5,2016.5))+
    scale_y_continuous(breaks=seq(0,10,2),limits=c(-0.5,10))+
    theme_bw()+
    geom_text(stat='count',aes(label=..count..),vjust=-0.25)+
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}

ggsave(filename=paste(query_term,"-pubmedcounts.png",sep=""),plot=p,width=dimwidth,height=dimheight,dpi=600)

# Get data
# slotNames(pmids) # list all names
data <- data.frame(pmid=PMID(pmids),year=YearPubmed(pmids),title=ArticleTitle(pmids),journal=Title(pmids),affiliation=Affiliation(pmids))
write.table(data,file=paste(query_term,"-papers.tsv",sep=""),sep="\t",row.names=FALSE,col.names=TRUE,quote=FALSE)

head(MedlineTA(pmids),n=100)
