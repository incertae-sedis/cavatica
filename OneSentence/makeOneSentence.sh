#! /usr/bin/env bash

TERM="igraph"
perl pubmed_text_analyzer2.pl $TERM data/$TERM-pubmedA.xml > data/$TERM.html

TERM="graphlab"
perl pubmed_text_analyzer2.pl $TERM data/$TERM-pubmedA.xml > data/$TERM.html

TERM="neo4j"
perl pubmed_text_analyzer2.pl $TERM data/$TERM-pubmedA.xml > data/$TERM.html

TERM="graphviz"
perl pubmed_text_analyzer2.pl $TERM data/$TERM-pubmedA.xml > data/$TERM.html

TERM="gephi"
perl pubmed_text_analyzer2.pl $TERM data/$TERM-pubmedA.xml > data/$TERM.html

TERM="visant"
perl pubmed_text_analyzer2.pl $TERM data/$TERM-pubmedA.xml > data/$TERM.html

TERM="cytoscape"
perl pubmed_text_analyzer2.pl $TERM data/$TERM-pubmedA.xml > data/$TERM.html
