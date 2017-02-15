#! /usr/bin/env bash
set -e
set -u

INDIR=../DATA
[[ -d $INDIR ]] || echo "No input files. Run 01-GetData-Ebot scripts first"
[[ -d $INDIR ]] || exit 0

arr=`awk -F',' 'NR>1 {print $1}' ../config.txt`

for TERM in $arr
do
    net=`echo ${TERM} | sed 's/+/ /g' |awk '{print $1}'`
    echo "auto temp=${net};"
    echo "int i=${net}_authors+${net}_papers;"
    echo "foreach node in temp set _text=\"999999999\";"
    echo "int j=1;"
    echo "foreach node in temp where type==\"author\" && (in+out)>1 set _text=j,j++;"
    echo "int c=1;"
    echo "int j=0;"
    echo "while(c==1 && j<i){"
    echo "   c=0;"
    echo "   foreach link in temp where in._text<out._text set out._text=in._text, c=1;"
    echo "   foreach link in temp where out._text<in._text set in._text=out._text, c=1;"
    echo "   j++;"
    echo "}"

    echo "foreach node in temp where _text==\"999999999\" set _text=\"\";"
    echo "auto temp2= select link from temp where in._text!=\"\";"
    echo "foreach link in temp2 set in._text=in._text.\":\".out.pmid;"
    echo "auto temp3=select node from temp2 where type==\"paper\";"
    echo "export(\"${net}-pmc-community.tsv\",\"tsv\",temp3);"
    echo ""
done


