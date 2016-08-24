#! /usr/bin/env bash
set -e
set -u

arr=`ls data20Years/* | tr '/' ' ' | sed 's/[-]/ /g' |awk '{print $2}'|uniq`

for TERM in $arr
do
    echo "$TERM======="
    echo "  papers: " `cat data20Years/$TERM-papers.tsv| wc -l`
    echo "  authors: " `awk '{print $2}' data20Years/$TERM-coauthors.tsv | wc -l`
    echo " "
done
