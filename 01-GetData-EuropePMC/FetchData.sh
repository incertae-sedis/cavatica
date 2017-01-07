#! /usr/bin/env bash
set -u
set -e

#OUTDIR=DATAHERE
#[[ -d $OUTDIR ]] || mkdir $OUTDIR

arr=`awk -F',' 'NR>1 {print $1}' ../config.txt`

for TERM in $arr
do	    
    echo "Searching Europe PMC between 1996 and 2016: $TERM"
    wget http://www.ebi.ac.uk/europepmc/webservices/rest/search?query=$TERM
done

