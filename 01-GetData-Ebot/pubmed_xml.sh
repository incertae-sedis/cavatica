#! /usr/bin/env bash
# Auth: Jennifer Chang
# Date: 2018/03/24

# Fetch 100 IDs at a time

mkdir .pmtmp
rm -rf .pmtmp
mkdir .pmtmp

NUM=0;
QUERY="";
FILE=100;
while read IDS; do
    if [ $NUM -ge 100 ]
    then
	echo "===== Fetching ids $((FILE-99)) to $FILE" >&2
#	echo "curl \"https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed${IDS}&retmode=xml&tool=ebot\" > .pmtmp/${FILE}.xml" >&2
	curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed${QUERY}&retmode=xml&tool=ebot" > .pmtmp/${FILE}.xml
	sleep 0.2;
	NUM=1;
	QUERY="&id=${IDS}";
	FILE=$((FILE+100));
    else
	NUM=$((NUM+1))
	QUERY="$QUERY&id=${IDS}"
    fi
    #    
    #curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=${IDS}&retmode=xml&rettype=&retstart=&retmax=500&seq_start=&seq_stop=&strand=&complexity=&tool=ebot" > .pmtmp/${IDS}.xml
#    sleep 1
done < $1

if [ $NUM -gt 0 ]
then
    echo "===== Fetching ids $((FILE-99)) to $((FILE-100+NUM))" >&2
#    echo "curl \"https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed${IDS}&retmode=xml&tool=ebot\" > .pmtmp/${FILE}.xml" >&2
    curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed${QUERY}&retmode=xml&tool=ebot" > .pmtmp/${FILE}.xml
fi

cat .pmtmp/*.xml 
