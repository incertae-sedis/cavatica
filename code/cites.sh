#! /usr/bin/env bash
# Auth: Jennifer Chang
# Date: 2018/06/21

set -e
set -u

PMCID=$1

curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=pubmed&linkname=pubmed_pmc_refs&id=${PMCID}" | sed -n '/LinkName/,$p' |grep Id|awk -F'>' '{print $2}'|awk -F'<' '{print $1}'