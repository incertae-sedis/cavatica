install.packages("xml2")
library(xml2)

# read in file as character string
setwd("/Users/jenchang/github/cavatica/Cluster")
filename<-"DATAHERE/GraphLab-fulltext.xml"
ss<-readChar(filename,file.info(filename)$size)

x <- read_xml(ss)
xml_children(x)
PMID <- xml_find_all(x,".//article-title")
PMID <- xml_find_all(x,".//surname")
PMID <- xml_find_all(x,".//pub-date")
PMID <- xml_find_all(x,".//p")
PMID
xml_children(x)
article <-xml_find_all(x,".//article")
article
title <-xml_find_all(x,".//sec")
title

library(RISmed)
citation("RISmed")
