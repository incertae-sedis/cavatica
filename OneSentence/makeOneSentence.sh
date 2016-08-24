#! /usr/bin/env bash

INDIR="data20Years"
arr="igraph neo4j gephi cytoscape pathway+studio IPA+Ingenuity+Pathway+Analysis"

for TERM in $arr
do
    perl pubmed_text_analyzer2.pl $TERM $INDIR/$TERM-pubmed.xml > $TERM.html
done

#Special cases
perl pubmed_text_analyzer2.pl IPA $INDIR/IPA+Ingenuity+Pathway+Analysis-pubmed.xml > IPA.html
perl pubmed_text_analyzer2.pl "Ingenuity Pathway Analysis" $INDIR/IPA+Ingenuity+Pathway+Analysis-pubmed.xml > Ingenuity+Pathway+Analysis.html
perl pubmed_text_analyzer2.pl "pathway studio" $INDIR/pathway+studio-pubmed.xml > pathway+studio.html

