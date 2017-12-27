#! /usr/bin/env bash

TERM=$1
curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=${TERM}&retmax=1000&usehistory=y&mindate=1996/01/01&maxdate=2017/01/01&datetype=PDAT&tool=ebot" | grep "<Id>"| sed 's/<Id>//g' |sed 's/<\/Id>//g'
sleep 1;