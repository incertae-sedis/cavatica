#! /usr/bin/env bash
set -e
set -u

INDIR=data20Years
[[ -d $INDIR ]] || ln -s ../EbotScripts/$INDIR .

arr=`ls $INDIR/*-coauthors.tsv | tr '/' ' ' | sed 's/[-]/ /g' |awk '{print $2}'|uniq`

OUTDIR=data
[[ -d $OUTDIR ]] || mkdir $OUTDIR

for TERM in $arr
do
    cat $INDIR/$TERM-coauthors.tsv| awk -F'\t' '{print $1,$2}' > $OUTDIR/$TERM-network.ssv
    echo $TERM " done"
done


