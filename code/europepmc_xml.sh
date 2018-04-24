#! /usr/bin/env bash
# Auth: Jennifer Chang
# Date: 
# https://europepmc.org/RestfulWebService

set -u
set -e

TERM=$1

echo "Searching Europe PMC: $TERM"
curl https://www.ebi.ac.uk/europepmc/webservices/rest/search?query=${TERM} > ${TERM}_eupmc.xml

