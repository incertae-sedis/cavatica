#! /usr/bin/env bash

INDIR="../01-GetData-Ebot/DATAHERE"
[[ -d $INDIR ]] || echo "No input files. Run 01-GetData-Ebot scripts first"
[[ -d $INDIR ]] || exit 0

arr=""

# User can pass in a term, instead of using config.txt
if [ $# -ge 1 ]
then
    arr=$1
else
    arr=`awk -F',' 'NR>1 {print $1}' ../config.txt`
fi

for TERM in $arr
do
    echo "Processing $TERM"
    query=`echo $TERM |sed 's/+/ /g'`
    perl pubmed_text_analyzer2.pl "$query" $INDIR/$TERM-pubmed.xml > $TERM.html
    perl pubmed_fulltext_analyzer_v4.pl "$query" $INDIR/$TERM-fulltext.xml > $TERM-full.html
    uniq pmid.txt ${TERM}-pmid.txt
    uniq pmcid.txt ${TERM}-pmcid.txt
    wc -l ${TERM}-pmid.txt
    wc -l $INDIR/${TERM}-pmids.txt
    wc -l $INDIR/${TERM}-pmcids.txt
    wc -l ${TERM}-pmcid.txt
    wc -l $INDIR/${TERM}-pmc-papers.tsv
    echo " ${TERM}.html saved"
    echo " ${TERM}-full.html saved"
done

# specific for VisANT
#TERM="VisANT"
#echo "Processing $TERM"
#query="VisA"
#perl pubmed_text_analyzer3.pl "$query" $INDIR/$TERM-pubmed.xml > $TERM.html
#uniq pmid.txt ${TERM}-pmid.txt
#wc -l ${TERM}-pmid.txt
#wc -l $INDIR/${TERM}-pmids.txt
#perl pubmed_fulltext_analyzer_v4_C.pl "$query" $INDIR/$TERM-fulltext.xml > $TERM-full.html
#uniq pmcid.txt ${TERM}-pmcid.txt
#wc -l ${TERM}-pmcid.txt
#wc -l $INDIR/${TERM}-pmcids.txt
#echo " ${TERM}.html saved"
#echo " ${TERM}-full.html saved"




