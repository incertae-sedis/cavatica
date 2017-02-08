#! /usr/bin/env bash
set -u
set -e

#OUTDIR=DATAHERE
#[[ -d $OUTDIR ]] || mkdir $OUTDIR

arr=`awk -F',' 'NR>1 {print $1}' ../config.txt`

for TERM in $arr
do	    
    echo "Searching Europe PMC: $TERM"
    wget http://www.ebi.ac.uk/europepmc/webservices/rest/search?query=$TERM
done

