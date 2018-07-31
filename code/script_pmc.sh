#! /usr/bin/env bash
# Auth: Jennifer Chang
# Date: 2018/04/23
# Desc: Run a search term

set -e
set -u

# Place search terms in config.txt
ARR=(`grep -v "^term" config.txt |awk -F',' '{print $1}'|tr '\n' ' '`)
CODEDIR=../../code

touch logfile.txt
date
date >> logfile.txt

# ================================ PMC Search
for TERM in "${ARR[@]}"
do
    echo -e "===== Search ${TERM} in PMC\n"
    [[ -f "${TERM}_pmc.ids" ]] ||perl ${CODEDIR}/searchPMCBtwnPubDates.pl ${TERM} ${TERM}_pmc.ids
    [[ -f "${TERM}_pmc.xml" ]] || echo "${CODEDIR}/pmc_xml.sh ${TERM}_pmc.ids > ${TERM}_pmc.xml"
    [[ -f "${TERM}_pmc.xml" ]] || ${CODEDIR}/pmc_xml.sh ${TERM}_pmc.ids > ${TERM}_pmc.xml
    query=`echo $TERM |sed 's/+/ /g'`
    [[ -f "${TERM}_pmc.hmtl" ]] || ${CODEDIR}/pubmed_fulltext_analyzer_v4.pl ${query} ${TERM}_pmc.xml > ${TERM}_pmc.html
    
    echo "===== Generate authors and paper lists"
    KEYWORD=`echo $TERM | sed 's/+/ /g'`
    [[ -f "${TERM}_authors_pmc.tsv" ]] || ${CODEDIR}/bothlist_pmc.pl "${KEYWORD}" ${TERM}_papers_pmc.tsv ${TERM}_authors_pmc.tsv ${TERM}_pmc.xml 2> /dev/null # silence incomplete author information

    
    echo "===== Generate Paper Count barcharts"
    [[ -f "${TERM}_pmc.png" ]] || ${CODEDIR}/mkBarchart.R ${TERM}_papers_pmc.tsv ${TERM}_pmc.png 1996 2018
done

wc -l *pmc.ids >> logfile.txt
ls -ltr *pmc.xml >> logfile.txt
wc -l *pmc.tsv >> logfile.txt

[[ -f pmc.gel ]] || ${CODEDIR}/generatePMCGel.sh > pmc.gel

ls -ltr pmc.gel

[[ -f multitool-pmc.tsv ]] || exit 0;

LC_CTYPE=C sed -n '/#From/,$p' multitool-pmc.tsv | awk -F'\t' '{print $2,"\t",$8}' |sort -k2,1 > trends-temp.txt
perl ${CODEDIR}/printTransitions.pl trends-temp.txt > trends-temp2.txt
awk -F'\t' '{print $4}' trends-temp2.txt |sort | uniq -c > trends-temp3.txt
perl ${CODEDIR}/hack.pl trends-temp3.txt >> logfile.txt
perl ${CODEDIR}/hack.pl trends-temp3.txt
perl ${CODEDIR}/hack.pl trends-temp3.txt > trends_pmc.txt
