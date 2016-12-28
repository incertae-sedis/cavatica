#! /usr/bin/env bash

INDIR="../01-GetData-Ebot/DATAHERE"
[[ -d $INDIR ]] || echo "No input files. Run 01-GetData-Ebot scripts first"
[[ -d $INDIR ]] || exit 0

arr=`awk -F',' 'NR>1 {print $1}' ../config.txt`

for TERM in $arr
do
    echo "Processing $TERM"
    query=`echo $TERM |sed 's/+/ /g'`
    perl pubmed_text_analyzer2.pl "$query" $INDIR/$TERM-pubmed.xml > $TERM.html
    uniq pmid.txt ${TERM}-pmid.txt
    wc -l ${TERM}-pmid.txt
    wc -l $INDIR/${TERM}-pmids.txt
    echo " ${TERM}.html saved"
done




