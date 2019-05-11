#! /usr/bin/env Rscript
# Auth: Jennifer Chang
# Date: 2019/05/11

INFILE="pubmed_minION.csv"
OUTFILE="pubmed_minION_out.txt"

library(readr)
library(magrittr)
library(tidyverse)

my.data <- read_delim(INFILE,delim=",")

c.data <- my.data %>%
  mutate(PubMed_ID = URL %>% gsub("/pubmed/","",.),
         PMC_ID = Identifiers %>% gsub("PMID:[0-9]*","",.) %>% gsub("\\| PMCID:","",.),
         Title = Title,
         Authors=Description,
         Year = ShortDetails %>% gsub(".*\\.","",.) %>% gsub(" ","",.),
         Journal= ShortDetails %>% gsub("  \\d\\d\\d\\d","",.),
         URL=NULL,Resource=NULL,Db=NULL,Type=NULL,Identifiers=NULL,Description=NULL,EntrezUID=NULL) %>%
  select(PubMed_ID, PMC_ID, Year, Title, Authors, Journal,Details, ShortDetails, Properties) 

write_delim(c.data,OUTFILE,delim="\t")
