#! /usr/bin/env bash
set -u
set -e

OUTDIR=DATAHERE
[[ -d $OUTDIR ]] || mkdir $OUTDIR

INDIR=../DATA
[[ -d $INDIR ]] || ln -s ../EbotScripts/$INDIR .

arr=`ls $INDIR/* | sed 's/[/-]/ /g' |awk '{print $3}'|uniq`

for TERM in $arr
do
    awk '{print $1,$2}' $INDIR/$TERM-papers.tsv > $OUTDIR/$TERM-years.ssv
done
