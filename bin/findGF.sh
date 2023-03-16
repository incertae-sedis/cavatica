#! /usr/bin/env bash
set -e
set -u

INDIR=../DATA
[[ -d $INDIR ]] || echo "No input files. Run 01-GetData-Ebot scripts first"
[[ -d $INDIR ]] || exit 0

arr=`awk -F',' 'NR>1 {print $1}' ../config.txt`
for TERM in $arr; do
    net=`echo ${TERM} | sed 's/+/ /g' |awk '{print $1}'`
    echo "${net}" >> GrowthFactor.txt 
    perl calculateGrowthFactor.pl ${net}-by-community.tsv \
      |grep "SUM" \
      |awk '{print $2"\t"$3"\t"$4}' \
      |sed 's/COUNT://g' \
      |sed 's/SUM://g' \
      |sort -k2nr \
      >> GrowthFactor.txt
done

