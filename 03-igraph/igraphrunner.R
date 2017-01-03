#! /usr/bin/env Rscript

# -------------------------------------- Libraries
#install.packages("igraph")
library(igraph)
library(ggplot2)
library(readr)
# -------------------------------------- Functions

# Converts an edgelist to a graph
edge2graph <- function(x,directed=FALSE){
  if(dim(x)[2]<2) stop("Edgelist must have two columns")
  el <- as.matrix(x)
  el[,1] <- as.character(el[,1])
  el[,2] <- as.character(el[,2])
  return(graph.edgelist(el,directed=directed))
}

# -------------------------------------- Analysis
suppressMessages(terms <- read_delim("../config.txt",","))

g<-as.list(terms$term) # will contain list of graph objects
names(g)<-terms$term

for(i in 1:nrow(terms)){
  query_term<-terms$term[i]
  suppressMessages(data<-read_delim(paste("../DATA/",query_term,"-authors.tsv",sep=""),"\t"))
  g[[query_term]] <- edge2graph(data[,1:2])
}

# Graph Summaries
summaryG <- data.frame(graph=terms$term)
row.names(summaryG) <- terms$term
summaryG$graph=NULL

centG<-data.frame(degree=double(),betweenness=double(),graph=character())
for(ttt in terms$term){
  summaryG[ttt,"clusters"]<-clusters(g[[ttt]])$no
  centG<-rbind(centG,data.frame(degree=degree(g[[ttt]]),betweenness=betweenness(g[[ttt]]),graph=ttt))
}
summaryG
qplot(log(degree),log(betweenness),data=centG,color=graph,alpha=I(0.5))

dimwidth <- 8         # par("din")[1]  #figure dimensions
dimheight<- 4.916     # par("din")[2]
for(i in 1:nrow(terms)){
  query_term<-terms$term[i]
  dd<-degree.distribution(g[[query_term]])
  aa<-c(1:length(dd))
  p<-qplot(log(aa),log(dd),main=paste(query_term,"degree distribution"),xlab="log(degree)",ylab="log(nodes)")
  ggsave(filename=paste(query_term,"-degree.png",sep=""),plot=p,width=dimwidth,height=dimheight,dpi=600)
}
dd<-degree.distribution(g$Cytoscape)
str(dd)
aa<-c(1:length(dd))
p<-qplot(log(aa),log(dd),main="Cytoscape degree distribution",xlab="log(degree)",ylab="log(nodes)")
ggsave(filename=paste(query_term,"-pubmedcounts.png",sep=""),plot=p,width=dimwidth,height=dimheight,dpi=600)
names(dd$Cytoscape)
p
