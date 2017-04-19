#! /usr/bin/env bash
set -u
set -e

OUTDIR=DATAHERE
[[ -d $OUTDIR ]] || mkdir $OUTDIR

arr=""

# User can pass in a term, instead of using config.txt
if [ $# -ge 1 ]
then
    arr=$1
else
    arr=`awk -F',' 'NR>1 {print $1}' ../config.txt`
fi

touch $OUTDIR/logfile.txt
for TERM in $arr
do
    date
    date >> $OUTDIR/logfile.txt
    echo "Searching Pubmed between 1996 and 2016: $TERM"
    echo "Searching Pubmed between 1996 and 2016: $TERM" >> $OUTDIR/logfile.txt
   
    perl searchPubmedBtwnPubDates.pl $TERM $OUTDIR/$TERM-pmids.txt
    wc -l $OUTDIR/$TERM-pmids.txt
    wc -l $OUTDIR/$TERM-pmids.txt >> $OUTDIR/logfile.txt
    
    echo "    if number of ids is greater than 500, this may take a few minutes. Please be patient."
    perl warpAroundfetchPubmedData.pl $OUTDIR/$TERM-pmids.txt $OUTDIR/$TERM-pubmed.xml > /dev/null # stops the pubmed script reporting messages, fetches 500 records at a time
    perl convert2tsv.pl $OUTDIR/$TERM-pubmed.xml > $OUTDIR/$TERM-papers.tsv
    perl getPM2Author.pl $OUTDIR/$TERM-pubmed.xml > $OUTDIR/$TERM-authors.tsv

    echo "Searching Pubmed Central between 1996 and 2016: $TERM"
    echo "Searching Pubmed Central between 1996 and 2016: $TERM" >> $OUTDIR/logfile.txt
    perl searchPMCBtwnPubDates.pl $TERM $OUTDIR/$TERM-pmcids.txt
    wc -l $OUTDIR/$TERM-pmcids.txt
    wc -l $OUTDIR/$TERM-pmcids.txt >> $OUTDIR/logfile.txt
    echo "    if number of ids is greater than 500, this may take a few minutes. Please be patient."
    perl warpAroundfetchPMCfulltext.pl $OUTDIR/$TERM-pmcids.txt $OUTDIR/$TERM-fulltext.xml > /dev/null
    KEYWORD=`echo $TERM | sed 's/+/ /g'`
    perl convertPMC2tsv.pl "$KEYWORD" $OUTDIR/$TERM-pmc-papers.tsv $OUTDIR/$TERM-pmc-authors.tsv $OUTDIR/$TERM-fulltext.xml 2> /dev/null # silence if there's incomplete author information
    wc -l $OUTDIR/$TERM-*.tsv
    wc -l $OUTDIR/$TERM-*.tsv >> $OUTDIR/logfile.txt
    echo "---------------------" >> $OUTDIR/logfile.txt
done

