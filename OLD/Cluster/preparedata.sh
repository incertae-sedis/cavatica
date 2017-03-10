#! /usr/bin/env bash

set -e
set -u

OUTDIR=data
[[ -d $OUTDIR ]] || mkdir $OUTDIR

INDIR=data20Years
[[ -d $INDIR ]] || ln -s ../EbotScripts/$INDIR .

arr=`ls $INDIR/* | tr '/' ' ' | sed 's/[-]/ /g' |awk '{print $2}'|uniq`

arr=`ls $INDIR/* | tr '/' ' ' | sed 's/[-]/ /g' |awk '{print $2}'|uniq`

for TERM in $arr
do
    ./pullkeywords.pl $INDIR/${TERM}-pubmed.xml > $OUTDIR/${TERM}-terms.tsv
done
