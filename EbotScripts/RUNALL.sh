#! /usr/bin/env bash
set -u
set -e

[[ -d data ]] || mkdir data

arr="igraph graphlab neo4j graphviz gephi visant cytoscape pathway+studio IPA+Ingenuity+Pathway+Analysis"

for TERM in $arr
do	    
    echo $TERM "loading... PMC search"

    perl searchpmc.pl $TERM data/$TERM-meta.txt
    perl pulloutPMC.pl data/$TERM-meta.txt > data/$TERM-pmcids.txt
    perl fetchPMCfulltext.pl data/$TERM-pmcids.txt data/$TERM-fulltext.xml
    perl mapPMC2PM.pl data/$TERM-meta.txt > data/$TERM-pmids.txt

    echo $TERM "loading... Pubmed search"
    perl searchpubmed.pl $TERM data/$TERM-pmidsD.txt

    echo $TERM "merge ids and fetch final"
    cat data/$TERM-pmidsD.txt data/$TERM-pmids.txt | sort | uniq > data/$TERM-pmidsA.txt
    perl fetchPubmedData.pl data/$TERM-pmidsA.txt data/$TERM-pubmedA.xml

    echo $TERM "generate final network files"
    perl convert2tsv.pl data/$TERM-pubmedA.xml > data/$TERM-papers.tsv
    perl getPM2Author.pl data/$TERM-pubmedA.xml > data/$TERM-coauthor.tsv
done
