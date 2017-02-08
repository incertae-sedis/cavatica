#! /usr/bin/env bash
set -e
set -u

INDIR=../DATA
[[ -d $INDIR ]] || echo "No input files. Run 01-GetData-Ebot scripts first"
[[ -d $INDIR ]] || exit 0

arr=`awk -F',' 'NR>1 {print $1}' ../config.txt`
for TERM in $arr
do
    net=`echo ${TERM} | sed 's/+/ /g' |awk '{print $1}'`
    perl communityFormat.pl ${net}-community.tsv |sort -k2,1nr > ${net}-by-community.tsv
    echo "${net}: ";
    awk '{print $1}' ${net}-by-community.tsv |sort | uniq -c |sort -r| head -n3
done

