#! /usr/bin/env bash
# Auth: Jennifer Chang
# Date: 2018/04/23
# Desc: Run a search term

set -e
set -u

ARR=(wilson)
CODEDIR=../../code

for TERM in "${ARR[@]}"
do
    echo "===== Fetch PubMed and PMC XML files"
    [[ -f "${TERM}_pm.xml" ]] || echo "${CODEDIR}/pubmed_xml.sh ${TERM}_pm.ids > ${TERM}_pm.xml"
    [[ -f "${TERM}_pm.xml" ]] || ${CODEDIR}/pubmed_xml.sh ${TERM}_pm.ids > ${TERM}_pm.xml
    [[ -f "${TERM}_pmc.xml" ]] || echo "${CODEDIR}/pmc_xml.sh ${TERM}_pmc.ids > ${TERM}_pmc.xml"
    [[ -f "${TERM}_pmc.xml" ]] || ${CODEDIR}/pmc_xml.sh ${TERM}_pmc.ids > ${TERM}_pmc.xml

    echo "===== Generate authors and paper lists"
    [[ -f "${TERM}_authors_pm.tsv" ]] || ${CODEDIR}/authorlist_pm.pl ${TERM}_pm.xml > ${TERM}_authors_pm.tsv
    [[ -f "${TERM}_papers_pm.tsv" ]] || ${CODEDIR}/paperlist_pm.pl ${TERM}_pm.xml > ${TERM}_papers_pm.tsv
    [[ -f "${TERM}_authors_pmc.tsv" ]] || ${CODEDIR}/bothlist_pmc.pl "." ${TERM}_papers_pmc.tsv ${TERM}_authors_pmc.tsv ${TERM}_pmc.xml

    echo "===== Generate Paper Count barcharts"
    [[ -f "${TERM}_pm.tiff" ]] || ${CODEDIR}/mkBarchart.R ${TERM}_papers_pm.tsv ${TERM}_pm.tiff
    [[ -f "${TERM}_pmc.tiff" ]] || ${CODEDIR}/mkBarchart.R ${TERM}_papers_pmc.tsv ${TERM}_pmc.tiff
done

ls -ltr