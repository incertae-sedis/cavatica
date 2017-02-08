#! /usr/bin/env bash

sed -n '/#From/,$p' $1 | awk -F'\t' '{print $2,"\t",$8}' |sort -k2,1 > trends-temp.txt
perl printTransitions.pl trends-temp.txt > trends-temp2.txt
awk -F'\t' '{print $4}' trends-temp2.txt |sort | uniq -c > trends-temp3.txt
perl hack.pl trends-temp3.txt 
