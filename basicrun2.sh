#! /usr/bin/env bash


#./generateGel.sh > pubmed.gel
#./generatePMCGel.sh > pmc.gel

#echo "Mango scripts ready. Open Mango, open the scripts pubmed.gel and pmc.gel. Then type 'run pubmed.gel;' <enter> into console. Do the same with 'pmc.gel'." 

cd 02-Mango
echo "=============PubMed Transitions"
./counttrends.sh multitool-pubmed.tsv
echo "=============PubMed Central Transitions"
./counttrends.sh multitool-pmc.tsv
