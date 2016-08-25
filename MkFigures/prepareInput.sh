#! /usr/bin/env bash
set -u
set -e

OUTDIR=data
[[ -d $OUTDIR ]] || mkdir $OUTDIR

INDIR=data20Years
[[ -d $INDIR ]] || ln -s ../EbotScripts/$INDIR .

arr=`ls $INDIR/* | tr '/' ' ' | sed 's/[-]/ /g' |awk '{print $2}'|uniq`

for TERM in $arr
do
    awk '{print $1,$2}' $INDIR/$TERM-papers.tsv > $OUTDIR/$TERM-years.ssv
done
