#! /usr/bin/env bash
# Auth: Jennifer Chang
# Date: 2018/03/24
# Desc: Fetch PubMed xml entries, 100 at a time

# ======================= Variables
NUM=0;
QUERY="";
FILE=100;

# ======================= Main
[[ -d .pmtmp ]] && rm -rf .pmtmp
mkdir .pmtmp

while read IDS; do
    if [ $NUM -ge 100 ]
    then
	echo "===== Fetching ids $((FILE-99)) to $FILE" >&2
	curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed${QUERY}&retmode=xml&tool=ebot" > .pmtmp/${FILE}.xml
	sleep 0.2;
	NUM=1;
	QUERY="&id=${IDS}";
	FILE=$((FILE+100));
    else
	NUM=$((NUM+1))
	QUERY="$QUERY&id=${IDS}"
    fi
done < $1

# ======================= if number of IDs is not a multiple of 100, fetch last group
if [ $NUM -gt 0 ]
then
    echo "===== Fetching ids $((FILE-99)) to $((FILE-100+NUM))" >&2
    curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed${QUERY}&retmode=xml&tool=ebot" > .pmtmp/${FILE}.xml
fi
# ======================= printout all the fetched pubmed XML
cat .pmtmp/*.xml 
