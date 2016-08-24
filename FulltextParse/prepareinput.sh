#! /usr/bin/env bash
set -u
set -e

INDIR="data20Years"
OUTDIR=data
[[ -d $OUTDIR ]] || mkdir $OUTDIR

arr="neo4j gephi igraph graphlab cytoscape"
#pathway+studio IPA+Ingenuity+Pathway+Analysis"

for TERM in $arr
do
    cat $INDIR/$TERM-fulltext.xml | \
	sed 's/<italic>//g' | sed 's/<\/italic>//g'| \
	sed 's/<bold>//g' | sed 's/<\/bold>//g' \
 	> $OUTDIR/$TERM-flattened.xml
done
