#! /usr/bin/env bash

# Edit config.txt to list search terms

# Fetch PubMed and PubMed Central data
cd 01-GetData-Ebot
./FetchData.sh
cd ..

# Link fetched coauthor network files to DATA folder
cd DATA
ln -s ../01-GetData-Ebot/DATAHERE/*.tsv .
cd ..

# Mango Graph Analysis
cd 02-Mango
./generateGel.sh > pubmed.gel
./generatePMCGel.sh > pmc.gel

echo "Mango scripts ready. Open Mango, open the scripts pubmed.gel and pmc.gel. Then type 'run pubmed.gel;' <enter> into console. Do the same with 'pmc.gel'." 
