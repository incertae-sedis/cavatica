#! /usr/bin/env bash
# Auth: Jennifer Chang
# Date: 2018/05/21

# ====== Variables
TERM=$1
#START=1998/01/01
#ENDIN=2018/01/01
RETMAX=100000

# ===== Analysis
#curl -g "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pmc&term=\"${TERM}\"&retmax=${RETMAX}&usehistory=y&mindate=${START}&maxdate=${ENDIN}&datetype=PDAT" | sed 's/<RetMax>/|<RetMax>/g' |sed 's/<RetStart>/|<RetStart>/g'|tr '|' '\n' > temp.pm
curl -g "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pmc&term=${TERM}&retmax=${RETMAX}&usehistory=y&sort=pub+date" |\
 sed 's/<RetMax>/|<RetMax>/g; s/<RetStart>/|<RetStart>/g' |\
 tr '|' '\n' > temp.pm
grep "^<Count" temp.pm  >&2
grep "^<RetMax" temp.pm >&2

cat temp.pm |grep "<Id>" |\
 sed 's/<Id>//g; s/<\/Id>//g' |\
 tr '\t' ' ' | sed 's/ //g' |\
 awk -F'\t' '{print "PMC"$1}'

sleep 1;
