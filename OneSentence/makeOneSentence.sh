#! /usr/bin/env bash

INDIR="data20Years"
[[ -d $INDIR ]] || ln -s ../EbotScripts/$INDIR .

arr=`ls $INDIR/* | tr '/' ' ' | sed 's/[-]/ /g' |awk '{print $2}'|uniq`

for TERM in $arr
do
    small=`ls $INDIR/${TERM}-pubmed.xml | tr '/' ' ' | sed 's/-/ /g'| awk '{print $2}'| sed 's/+/ /g'`
    perl pubmed_text_analyzer2.pl "$small" $INDIR/$TERM-pubmed.xml > $TERM.html
done

#Special cases
perl pubmed_text_analyzer2.pl IPA $INDIR/IPA+Ingenuity+Pathway+Analysis-pubmed.xml > IPA.html
perl pubmed_text_analyzer2.pl "Ingenuity Pathway Analysis" $INDIR/IPA+Ingenuity+Pathway+Analysis-pubmed.xml > Ingenuity+Pathway+Analysis.html


