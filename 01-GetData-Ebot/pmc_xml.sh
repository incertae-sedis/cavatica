#! /usr/bin/env bash

mkdir .pmtmp
rm -rf .pmtmp
mkdir .pmtmp

while read IDS; do
#    echo $IDS
    curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pmc&id=${IDS}&retmode=xml&rettype=&retstart=&retmax=500&seq_start=&seq_stop=&strand=&complexity=&tool=ebot" > .pmtmp/${IDS}.xml
    sleep 1
done < $1

cat .pmtmp/*.xml 
