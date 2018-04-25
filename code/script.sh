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

# ================================ PubMed Search
for TERM in "${ARR[@]}"
do
    echo -e "===== ${TERM}\n"

    echo -e "===== Search ${TERM} in PubMed\n"
    echo "perl ${CODEDIR}/searchPubmedBtwnPubDates.pl ${TERM} ${TERM}_pm.ids"
    [[ -f "${TERM}_pm.ids" ]] || perl ${CODEDIR}/searchPubmedBtwnPubDates.pl ${TERM} ${TERM}_pm.ids
    echo "${CODEDIR}/pubmed_xml.sh ${TERM}_pm.ids > ${TERM}_pm.xml"
    [[ -f "${TERM}_pm.xml" ]] || ${CODEDIR}/pubmed_xml.sh ${TERM}_pm.ids > ${TERM}_pm.xml

    # Visual check, manual curation
    query=`echo $TERM |sed 's/+/ /g'`
    [[ -f "${TERM}_pm.html" ]] || perl ${CODEDIR}/pubmed_text_analyzer2.pl "$query" ${TERM}_pm.xml > ${TERM}_pm.html
	
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
perl ${CODEDIR}/hack.pl trends-temp3.txt >> logfile.txt
perl ${CODEDIR}/hack.pl trends-temp3.txt

# ================================ PMC Search
for TERM in "${ARR[@]}"
do
    echo -e "===== Search ${TERM} in PMC\n"
    [[ -f "${TERM}_pmc.ids" ]] ||perl ${CODEDIR}/searchPMCBtwnPubDates.pl ${TERM} ${TERM}_pmc.ids
    [[ -f "${TERM}_pmc.xml" ]] || echo "${CODEDIR}/pmc_xml.sh ${TERM}_pmc.ids > ${TERM}_pmc.xml"
    [[ -f "${TERM}_pmc.xml" ]] || ${CODEDIR}/pmc_xml.sh ${TERM}_pmc.ids > ${TERM}_pmc.xml

    echo "===== Generate authors and paper lists"
    KEYWORD=`echo $TERM | sed 's/+/ /g'`
    [[ -f "${TERM}_authors_pmc.tsv" ]] || ${CODEDIR}/bothlist_pmc.pl "${KEYWORD}" ${TERM}_papers_pmc.tsv ${TERM}_authors_pmc.tsv ${TERM}_pmc.xml 2> /dev/null # silence incomplete author information

    
    echo "===== Generate Paper Count barcharts"
    [[ -f "${TERM}_pmc.tiff" ]] || ${CODEDIR}/mkBarchart.R ${TERM}_papers_pmc.tsv ${TERM}_pmc.tiff 1996 2018
done

wc -l *pmc.ids >> logfile.txt
ls -ltr *pmc.xml >> logfile.txt
wc -l *pmc.tsv >> logfile.txt

[[ -f pmc.gel ]] || ${CODEDIR}/generatePMCGel.sh > pmc.gel

ls -ltr pmc.gel

[[ -f multitool-pmc.tsv ]] || exit;

LC_CTYPE=C sed -n '/#From/,$p' multitool-pmc.tsv | awk -F'\t' '{print $2,"\t",$8}' |sort -k2,1 > trends-temp.txt
perl ${CODEDIR}/printTransitions.pl trends-temp.txt > trends-temp2.txt
awk -F'\t' '{print $4}' trends-temp2.txt |sort | uniq -c > trends-temp3.txt
perl ${CODEDIR}/hack.pl trends-temp3.txt >> logfile.txt
perl ${CODEDIR}/hack.pl trends-temp3.txt
