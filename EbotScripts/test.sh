#! /usr/bin/env bash
set -u
set -e

# Process from commandline
if [ $# -eq 0 ]; then
    sed 's/<italic>//g'| \sed 's/<\/italic>//g'| \
	sed 's/<bold>//g'| sed 's/<\/bold>//g'
    exit 1;
fi

# Process from file

FILE=$1

# Exit if file does not exist
if [ ! -f "$FILE" ]; then
    echo "File $FILE does not exist."
    exit 1;
fi

# Get rid of italic and bold tags
#cat $FILE | sed 's/<italic>//g'|sed 's/<\/italic>//g'| \
#    sed 's/<bold>//g'|sed 's/<\/bold>//g'

# http://stackoverflow.com/questions/893585/how-to-parse-xml-in-bash
read_dom () {
    local IFS=\>
    read -d \< ENTITY CONTENT
}
while read_dom; do
    echo "$ENTITY => $CONTENT"
done < "$FILE"


