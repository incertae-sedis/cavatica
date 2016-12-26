#! /usr/bin/env Rscript

# -------------------------------------- Libraries
#install.packages("igraph")
library(igraph)
library(ggplot2)

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
Cyto <- readRDS("../DATA/Cytoscape-authors.RDS");

g<-list()  # Will contain all graphs
g$C <- edge2graph(coa[,1:2])
clusters(g$C)$no
