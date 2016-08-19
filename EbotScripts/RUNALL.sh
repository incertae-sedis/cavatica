#! /usr/bin/env bash

mkdir data
# ====================================================================================
TERM="igraph"
echo $TERM "loading... from PMC search\n"

perl searchpmc.pl $TERM data/$TERM-meta.txt
perl pulloutPMC.pl data/$TERM-meta.txt > data/$TERM-pmcids.txt
perl fetchPMCfulltext.pl data/$TERM-pmcids.txt data/$TERM-fulltext.xml
perl mapPMC2PM.pl data/$TERM-meta.txt > data/$TERM-pmids.txt

echo $TERM "loading... from Pubmed search\n"
perl searchpubmed.pl $TERM data/$TERM-pmidsD.txt

echo $TERM "merge ids and fetch final \n"
cat data/$TERM-pmidsD.txt data/$TERM-pmids.txt | sort | uniq > data/$TERM-pmidsA.txt
perl fetchPubmedData.pl data/$TERM-pmidsA.txt data/$TERM-pubmedA.xml

echo $TERM "generate final network files \n"
perl convert2tsv.pl data/$TERM-pubmedA.xml > data/$TERM-papers.tsv
perl getPM2Author.pl data/$TERM-pubmedA.xml > data/$TERM-coauthor.tsv

# ====================================================================================
TERM="graphlab"
echo $TERM "loading... from PMC search\n"

perl searchpmc.pl $TERM data/$TERM-meta.txt
perl pulloutPMC.pl data/$TERM-meta.txt > data/$TERM-pmcids.txt
perl fetchPMCfulltext.pl data/$TERM-pmcids.txt data/$TERM-fulltext.xml
perl mapPMC2PM.pl data/$TERM-meta.txt > data/$TERM-pmids.txt

echo $TERM "loading... from Pubmed search\n"
perl searchpubmed.pl $TERM data/$TERM-pmidsD.txt

echo $TERM "merge ids and fetch final \n"
cat data/$TERM-pmidsD.txt data/$TERM-pmids.txt | sort | uniq > data/$TERM-pmidsA.txt
perl fetchPubmedData.pl data/$TERM-pmidsA.txt data/$TERM-pubmedA.xml

echo $TERM "generate final network files \n"
perl convert2tsv.pl data/$TERM-pubmedA.xml > data/$TERM-papers.tsv
perl getPM2Author.pl data/$TERM-pubmedA.xml > data/$TERM-coauthor.tsv

# ====================================================================================
TERM="neo4j"
echo $TERM "loading... from PMC search\n"

perl searchpmc.pl $TERM data/$TERM-meta.txt
perl pulloutPMC.pl data/$TERM-meta.txt > data/$TERM-pmcids.txt
perl fetchPMCfulltext.pl data/$TERM-pmcids.txt data/$TERM-fulltext.xml
perl mapPMC2PM.pl data/$TERM-meta.txt > data/$TERM-pmids.txt

echo $TERM "loading... from Pubmed search\n"
perl searchpubmed.pl $TERM data/$TERM-pmidsD.txt

echo $TERM "merge ids and fetch final \n"
cat data/$TERM-pmidsD.txt data/$TERM-pmids.txt | sort | uniq > data/$TERM-pmidsA.txt
perl fetchPubmedData.pl data/$TERM-pmidsA.txt data/$TERM-pubmedA.xml

echo $TERM "generate final network files \n"
perl convert2tsv.pl data/$TERM-pubmedA.xml > data/$TERM-papers.tsv
perl getPM2Author.pl data/$TERM-pubmedA.xml > data/$TERM-coauthor.tsv

# ====================================================================================
TERM="graphviz"
echo $TERM "loading... from PMC search\n"

perl searchpmc.pl $TERM data/$TERM-meta.txt
perl pulloutPMC.pl data/$TERM-meta.txt > data/$TERM-pmcids.txt
perl fetchPMCfulltext.pl data/$TERM-pmcids.txt data/$TERM-fulltext.xml
perl mapPMC2PM.pl data/$TERM-meta.txt > data/$TERM-pmids.txt

echo $TERM "loading... from Pubmed search\n"
perl searchpubmed.pl $TERM data/$TERM-pmidsD.txt

echo $TERM "merge ids and fetch final \n"
cat data/$TERM-pmidsD.txt data/$TERM-pmids.txt | sort | uniq > data/$TERM-pmidsA.txt
perl fetchPubmedData.pl data/$TERM-pmidsA.txt data/$TERM-pubmedA.xml

echo $TERM "generate final network files \n"
perl convert2tsv.pl data/$TERM-pubmedA.xml > data/$TERM-papers.tsv
perl getPM2Author.pl data/$TERM-pubmedA.xml > data/$TERM-coauthor.tsv

# ====================================================================================
TERM="gephi"
echo $TERM "loading... from PMC search\n"

perl searchpmc.pl $TERM data/$TERM-meta.txt
perl pulloutPMC.pl data/$TERM-meta.txt > data/$TERM-pmcids.txt
perl fetchPMCfulltext.pl data/$TERM-pmcids.txt data/$TERM-fulltext.xml
perl mapPMC2PM.pl data/$TERM-meta.txt > data/$TERM-pmids.txt

echo $TERM "loading... from Pubmed search\n"
perl searchpubmed.pl $TERM data/$TERM-pmidsD.txt

echo $TERM "merge ids and fetch final \n"
cat data/$TERM-pmidsD.txt data/$TERM-pmids.txt | sort | uniq > data/$TERM-pmidsA.txt
perl fetchPubmedData.pl data/$TERM-pmidsA.txt data/$TERM-pubmedA.xml

echo $TERM "generate final network files \n"
perl convert2tsv.pl data/$TERM-pubmedA.xml > data/$TERM-papers.tsv
perl getPM2Author.pl data/$TERM-pubmedA.xml > data/$TERM-coauthor.tsv

# ====================================================================================
TERM="visant"
echo $TERM "loading... from PMC search\n"

perl searchpmc.pl $TERM data/$TERM-meta.txt
perl pulloutPMC.pl data/$TERM-meta.txt > data/$TERM-pmcids.txt
perl fetchPMCfulltext.pl data/$TERM-pmcids.txt data/$TERM-fulltext.xml
perl mapPMC2PM.pl data/$TERM-meta.txt > data/$TERM-pmids.txt

echo $TERM "loading... from Pubmed search\n"
perl searchpubmed.pl $TERM data/$TERM-pmidsD.txt

echo $TERM "merge ids and fetch final \n"
cat data/$TERM-pmidsD.txt data/$TERM-pmids.txt | sort | uniq > data/$TERM-pmidsA.txt
perl fetchPubmedData.pl data/$TERM-pmidsA.txt data/$TERM-pubmedA.xml

echo $TERM "generate final network files \n"
perl convert2tsv.pl data/$TERM-pubmedA.xml > data/$TERM-papers.tsv
perl getPM2Author.pl data/$TERM-pubmedA.xml > data/$TERM-coauthor.tsv
# ====================================================================================
TERM="cytoscape"
echo $TERM "loading... from PMC search\n"

perl searchpmc.pl $TERM data/$TERM-meta.txt
perl pulloutPMC.pl data/$TERM-meta.txt > data/$TERM-pmcids.txt
perl fetchPMCfulltext.pl data/$TERM-pmcids.txt data/$TERM-fulltext.xml
perl mapPMC2PM.pl data/$TERM-meta.txt > data/$TERM-pmids.txt

echo $TERM "loading... from Pubmed search\n"
perl searchpubmed.pl $TERM data/$TERM-pmidsD.txt

echo $TERM "merge ids and fetch final \n"
cat data/$TERM-pmidsD.txt data/$TERM-pmids.txt | sort | uniq > data/$TERM-pmidsA.txt
perl fetchPubmedData.pl data/$TERM-pmidsA.txt data/$TERM-pubmedA.xml

echo $TERM "generate final network files \n"
perl convert2tsv.pl data/$TERM-pubmedA.xml > data/$TERM-papers.tsv
perl getPM2Author.pl data/$TERM-pubmedA.xml > data/$TERM-coauthor.tsv
# ====================================================================================


