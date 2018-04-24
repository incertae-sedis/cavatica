#! /usr/bin/env bash
set -e
set -u

INDIR=../DATA
[[ -d $INDIR ]] || echo "No input files. Run 01-GetData-Ebot scripts first"
[[ -d $INDIR ]] || exit 0

arr=`awk -F',' 'NR>1 {print $1}' ../config.txt`

echo "node(string pmid, int year, string journal, string title, string otherid, string type) nt;"
echo "link<string affiliation> lt;"
echo "node(nt) c_node;"

for TERM in $arr
do
    net=`echo ${TERM} | sed 's/+/_/g' |awk '{print $1}'`
    echo "node(nt, int ${net}_I) nnt;"
    echo "node(c_node,nnt) c_node;"
    echo "graph(nnt,lt) $net=import(\"$INDIR/$TERM-pmc-papers.tsv\",\"\t\");"
    echo "foreach node in $net set type=\"paper\";"
    echo "$net.+=import(\"$INDIR/$TERM-pmc-authors.tsv\",\"\t\",1);"
    echo "$net.-={(\"pmid\"),(\"forename_lastname\")};"
    echo "foreach link in $net set in.type=\"paper\", out.type=\"author\",out._g=0.65;"
    echo "foreach node in $net where (in+out)>1 && type==\"author\" set _r=0.8;"
    echo "foreach node in $net set ${net}_I=1;"
    
    echo "foreach node in $net where type==\"paper\" set _x=rand(-10,10),_y=rand(-10,10),_z=-8;"
    echo "foreach link in $net set out._x=in._x+rand(-1,1),out._y=in._y+rand(-1,1),_width=0.2,out._z=-8;"
    echo "int ${net}_papers=0;"
    echo "int ${net}_authors=0;"
    echo "foreach node in $net where type==\"paper\" set ${net}_papers++;"
    echo "foreach node in $net where type==\"author\" set ${net}_authors++;"
    echo ""
done

echo "node(c_node,int sum) c_node;"
echo "graph(c_node,lt) c;"
item="0"

# Create Combined Graph
for TERM in $arr
do    
    net=`echo $TERM | sed 's/+/_/g' |awk '{print $1}'`
    item="$item+${net}_I"
    echo "c.+=$net;"
    echo "foreach node in c set _z=_z-8;"
done
echo "center(c);"

# Pull out multi-tool Authors
echo "foreach node in c set sum=$item;"
echo "auto mul=select link from c where out.sum>1;"

# Label multi-tool Authors
echo "foreach node in mul where type==\"paper\" set _text=year.\":\";"
for TERM in $arr
do
    net=`echo $TERM | sed 's/+/_/g' | awk '{print $1}'`
    echo "foreach node in mul where type==\"paper\" && ${net}_I==1 set _text=_text.\"$net\";"
done

# Export multi-tool authors to file
echo "foreach link in mul set _text=in._text;"
echo "export(\"multitool-pmc.tsv\",\"tsv\",mul);"
echo "foreach link in mul set _text=\"\";"


