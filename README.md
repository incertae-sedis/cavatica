# Cavatica
network analysis of network analysis papers and their software

The name comes from Charlotte's Web since her full name was Charlotte A. Cavatica. Although Cavatica also refers to barn spider.

[List of Entrez Databases](https://eutils.ncbi.nlm.nih.gov/entrez/eutils/einfo.fcgi)

[EBot](http://www.ncbi.nlm.nih.gov/Class/PowerTools/eutils/ebot.cgi)

###Searching for a term on PMC and fetching data from Pubmed

```
$ searchpmc.pl <query_term> > <term-meta.txt>
$ pulloutPMC.pl <term-meta.txt> > <pmcids.txt>
$ fetchPMCfulltext.pl <pmcids.txt> <output.xml>
$ mapPMC2PM.pl <output.xml> > <term-pmids.txt>
$ fetchPubmedData.pl <term-pmids.txt> <output2.xml>
```

###Searching for a term on Pubmed and fetching data from Pubmed 
```
$ searchpubmed.pl <query_term> <term-pmid.txt>
$ fetchPubmedData.pl <term-pmid.txt> <term-summary.xml>
```