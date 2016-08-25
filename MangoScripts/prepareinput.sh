#! /usr/bin/env bash
set -e
set -u

INDIR=data20Years
[[ -d $INDIR ]] || ln -s ../EbotScripts/data20Years .

arr=`ls $INDIR/* | tr '/' ' ' | sed 's/[-]/ /g' |awk '{print $2}'|uniq`

echo "node(string pmid, int year, string journal, string title, string type) nt;"
echo "link<string affiliation> lt;"
echo "node(nt) c_node;"

for TERM in $arr
do
    net=`ls $INDIR/$TERM-coauthors.tsv|tr '/' ' '| sed 's/[+-]/ /g'| awk '{print $2}'`
    echo "node(nt, int $net) nnt;"
    echo "node(c_node,nnt) c_node;"
    echo "graph(nnt,lt) $net=import(\"$INDIR/$TERM-papers.tsv\",\"\t\");"
    echo "$net.+=import(\"$INDIR/$TERM-coauthors.tsv\",\"\t\",1);"
    echo "foreach link in $net set in.type=\"paper\", out.type=\"author\",out._g=1;"
    echo "foreach node in $net set $net=1;"
    
    echo "foreach node in $net where type==\"paper\" set _x=rand(-10,10),_y=rand(-10,10);"
    echo "foreach link in $net set out._x=in._x+rand(-1,1),out._y=in._y+rand(-1,1);"
    echo "int ${net}_papers=0;"
    echo "int ${net}_authors=0;"
    echo "foreach node in $net where type==\"paper\" set ${net}_papers++;"
    echo "foreach node in $net where type==\"author\" set ${net}_authors++;"
    echo ""
done

echo "node(c_node,int sum) c_node;"
echo "graph(c_node,lt) c;"
item="0"

for TERM in $arr
do
    net=`ls $INDIR/$TERM-coauthors.tsv|tr '/' ' '| sed 's/[+-]/ /g'| awk '{print $2}'`
    item="$item+$net"
    echo "c.+=$net;"
done

echo "foreach node in c set sum=$item;"
echo "foreach node in c where sum>1 set _radius=0.5;"
echo "auto mul=select node from c where sum>1;"
