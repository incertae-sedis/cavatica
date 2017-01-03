#! /usr/bin/env bash

sed -n '/#From/,$p' mult.tsv | awk -F'\t' '{print $2,"\t",$8}' |sort -k2,1 > trends.txt
