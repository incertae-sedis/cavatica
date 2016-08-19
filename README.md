# Cavatica
Multi-network analysis of network analysis papers and their software

The name comes from Charlotte's Web since her full name was Charlotte A. Cavatica. Although Cavatica also refers to barn spider.

[List of Entrez Databases](https://eutils.ncbi.nlm.nih.gov/entrez/eutils/einfo.fcgi)

[EBot](http://www.ncbi.nlm.nih.gov/Class/PowerTools/eutils/ebot.cgi)

###Searching for a term on PMC and fetching data from Pubmed

```
$ searchpmc.pl <query_term> <term-meta.txt>
$ pulloutPMC.pl <term-meta.txt> > <term-pmcids.txt>
$ fetchPMCfulltext.pl <term-pmcids.txt> <term-fulltext.xml>
$ mapPMC2PM.pl <term-meta.txt> > <term-pmids.txt>
$ fetchPubmedData.pl <term-pmids.txt> <term-pubmed.xml>
```

###Searching for a term on Pubmed and fetching data from Pubmed 
```
$ searchpubmed.pl <query_term> <term-pmidsD.txt>           # D for direct
$ fetchPubmedData.pl <term-pmidsD.txt> <term-pubmedD.xml>
```

###Check for overlap of Pubmed and PMC
```
$ sort <term-pmids.txt> > term-pmidsS.txt
$ sort <term-pmidsD.txt> > term-pmidsDS.txt
$ comm -12 <term-pmidsS.txt> term-pmidsDS.txt > term-commonids.txt
```