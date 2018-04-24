#! /usr/bin/env bash

TERM=$1
START=1998/01/01
ENDIN=2018/01/01
curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pmc&term=${TERM}&usehistory=y&mindate=${START}&maxdate=${ENDIN}&datetype=PDAT&tool=ebot" | grep "<Id>"| sed 's/<Id>//g' |sed 's/<\/Id>//g'