#! /usr/bin/env bash
# Auth: Jennifer Chang
# Date: 2019/09/22

set -e
set -u

while read pmcid
do
    echo ${pmcid}
    curl --location "https://www.ncbi.nlm.nih.gov/pmc/articles/${pmcid}/pdf" > ${pmcid}.pdf
    sleep 1
done < $1

