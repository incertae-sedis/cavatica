#! /usr/bin/env bash
set -e
set -u

arr=`ls data20Years/* | tr '/' ' ' | sed 's/[-]/ /g' |awk '{print $2}'|uniq`

echo "node(string pmid, int year, string journal, string title, string type) nt;"
echo "link<string affiliation> lt;"

for TERM in $arr
do
    net=`ls data20Years/$TERM-coauthors.tsv|tr '/' ' '| sed 's/[+-]/ /g'| awk '{print $2}'`
    echo "graph(nt,lt) $net=import(\"data20Years/$TERM-papers.tsv\",\"\t\");"
    echo "$net.+=import(\"data20Years/$TERM-coauthors.tsv\",\"\t\",1);"
    echo "foreach link in $net set in.type=\"paper\", out.type=\"author\",out._g=1;"
    echo "foreach node in $net where type==\"paper\" set _x=rand(-10,10),_y=rand(-10,10);"
    echo "foreach link in $net set out._x=in._x+rand(-1,1),out._y=in._y+rand(-1,1);"
    echo ""
    
done
