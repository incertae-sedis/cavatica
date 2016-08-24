#! /usr/bin/env bash
set -u
set -e

OUTDIR=data
[[ -d $OUTDIR ]] || mkdir $OUTDIR

arr="neo4j gephi igraph cytoscape pathway+studio IPA+Ingenuity+Pathway+Analysis VisANT graphviz graphlab"

for TERM in $arr
do
    awk '{print $1,$2}' data20Years/$TERM-papers.tsv > $OUTDIR/$TERM-years.ssv
done
