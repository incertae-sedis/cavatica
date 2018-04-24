#! /usr/bin/env bash
# Auth: Jennifer Chang
# Date: 2018/04/23
# Desc: Run a search term

set -e
set -u

ARR=(wilson)
ARR=(`grep -v "^term" config.txt |awk -F',' '{print $1}'|tr '\n' ' '`)
CODEDIR=../../code

touch logfile.txt
date
date >> logfile.txt

for TERM in "${ARR[@]}"
do
    echo -e "===== ${TERM}\n"

    echo -e "===== Search ${TERM} in PubMed\n"
    echo "perl ${CODEDIR}/searchPubmedBtwnPubDates.pl ${TERM} ${TERM}_pm.ids"
    [[ -f "${TERM}_pm.ids" ]] || perl ${CODEDIR}/searchPubmedBtwnPubDates.pl ${TERM} ${TERM}_pm.ids
    echo "${CODEDIR}/pubmed_xml.sh ${TERM}_pm.ids > ${TERM}_pm.xml"
    [[ -f "${TERM}_pm.xml" ]] || ${CODEDIR}/pubmed_xml.sh ${TERM}_pm.ids > ${TERM}_pm.xml
    
    echo "===== Generate authors and paper lists"
    [[ -f "${TERM}_authors_pm.tsv" ]] || ${CODEDIR}/authorlist_pm.pl ${TERM}_pm.xml > ${TERM}_authors_pm.tsv
    [[ -f "${TERM}_papers_pm.tsv" ]] || ${CODEDIR}/paperlist_pm.pl ${TERM}_pm.xml > ${TERM}_papers_pm.tsv

    echo "===== Generate Paper Count barcharts"
    [[ -f "${TERM}_pm.tiff" ]] || ${CODEDIR}/mkBarchart.R ${TERM}_papers_pm.tsv ${TERM}_pm.tiff 1996 2018
done

wc -l *pm.ids >> logfile.txt
ls -ltr *pm.xml >> logfile.txt
wc -l *pm.tsv >> logfile.txt

[[ -f pubmed.gel ]] || ${CODEDIR}/generateGel.sh > pubmed.gel

ls -ltr pubmed.gel

[[ -f multitool-pubmed.tsv ]] || exit;

[[ -f trends-temp.txt ]] || LC_CTYPE=C sed -n '/#From/,$p' multitool-pubmed.tsv | awk -F'\t' '{print $2,"\t",$8}' |sort -k2,1 > trends-temp.txt
[[ -f trends-temp2.txt ]] || perl ${CODEDIR}/printTransitions.pl trends-temp.txt > trends-temp2.txt
[[ -f trends-temp3.txt ]] || awk -F'\t' '{print $4}' trends-temp2.txt |sort | uniq -c > trends-temp3.txt
perl ${CODEDIR}/hack.pl trends-temp3.txt 

#for TERM in "${ARR[@]}"
#do
#    # ======================================================
#    echo -e "===== Search ${TERM} in PMC\n"
##    [[ -f "${TERM}_pmc.xml" ]] || echo "${CODEDIR}/pmc_xml.sh ${TERM}_pmc.ids > ${TERM}_pmc.xml"
##    [[ -f "${TERM}_pmc.xml" ]] || ${CODEDIR}/pmc_xml.sh ${TERM}_pmc.ids > ${TERM}_pmc.xml
#    echo "===== Generate authors and paper lists"
##    [[ -f "${TERM}_authors_pmc.tsv" ]] || ${CODEDIR}/bothlist_pmc.pl "." ${TERM}_papers_pmc.tsv ${TERM}_authors_pmc.tsv ${TERM}_pmc.xml
#
#done
#
#wc -l *pmc.ids >> logfile.txt
#ls -ltr *pmc.xml >> logfile.txt
#wc -l *pmc.tsv >> logfile.txt

