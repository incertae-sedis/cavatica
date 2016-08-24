#! /usr/bin/env bash
set -u
set -e

OUTDIR=data20Years
[[ -d $OUTDIR ]] || mkdir $OUTDIR

arr="neo4j gephi" #"igraph graphlab cytoscape" # neo4j graphviz gephi visant cytoscape pathway+studio IPA+Ingenuity+Pathway+Analysis"

for TERM in $arr
do	    
    echo "Searching Pubmed between 1996 and 2016: $TERM"
    perl searchPubmedBtwnPubDates.pl $TERM $OUTDIR/$TERM-pmids.txt
    wc -l $OUTDIR/$TERM-pmids.txt
    perl fetchPubmedData.pl $OUTDIR/$TERM-pmids.txt $OUTDIR/$TERM-pubmed.xml
    perl convert2tsv.pl $OUTDIR/$TERM-pubmed.xml > $OUTDIR/$TERM-papers.tsv
    perl getPM2Author.pl $OUTDIR/$TERM-pubmed.xml > $OUTDIR/$TERM-coauthors.tsv

    echo "Searching Pubmed Central between 1996 and 2016: $TERM"
    perl searchPMCBtwnPubDates.pl $TERM $OUTDIR/$TERM-pmcids.txt
    wc -l $OUTDIR/$TERM-pmcids.txt
    perl fetchPMCfulltext.pl $OUTDIR/$TERM-pmcids.txt $OUTDIR/$TERM-fulltext.xml
done

