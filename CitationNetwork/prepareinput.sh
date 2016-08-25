#! /usr/bin/env bash
set -e
set -u

INDIR=data20Years
[[ -d $INDIR ]] || ln -s ../EbotScripts/$INDIR .

OUTDIR=data
[[ -d $OUTDIR]] || mkdir $OUTDIR

arr=`ls $INDIR/* | tr '/' ' ' | sed 's/[-]/ /g' |awk '{print $2}'|uniq`

for TERM in $arr
do
    perl makecitation.pl $INDIR/$TERM-fulltext.xml > $OUTDIR/$TERM-cit.tsv
done
