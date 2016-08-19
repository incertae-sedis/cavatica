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
$ wc -l term-pmids*
```

###Combine pubmed and pmc results
```
$ cat <term-pmids.txt> <term-pmidsD.txt> | sort| uniq > <term-pmidsA.txt>
$ fetchPubmedData.pl <term-pmidsA.txt> <term-pubmedA.xml>
```

###Get paper to author network
```
$ perl convert2tsv <term-pubmedA.xml> > <term-papers.tsv>
$ perl getPM2Author.pl <term-pubmedA.xml> > <term-coauthor.tsv>
```

### Mango

Use loadnet.gel to load networks into mango and visualize
```
node(string id, int year, string journal, string title, string type) nt;
link<string affiliation> lt;
graph(nt,lt) visant=import("data/visant-coauthor.tsv","\t",1);
visant.+=import("data/visant-papers.tsv","\t");

layout(visant,"random");
foreach link in visant set in.type="paper",out.type="author";
foreach link in visant set in._b=1,out._r=1;
visant.-={("pmid")};
foreach link in visant set out._x=in._x+rand(-1,1),out._y=in._y+rand(-1,1),out._z=in._z+rand(-1,1);

foreach node in visant set _radius=0.2;
foreach node in visant where type=="author" && (in+out)>1 set _radius=0.5,_g=0.5;
foreach link in visant where out._radius>0.3 set in._radius=0.5;
auto cross=select node from visant where _radius>0.3;

/* FD cross */

foreach link in visant where in._radius>0.3 set out._radius=0.5;
cross.+=select node from visant where _radius>0.3;
foreach link in cross set out._x=in._x+rand(-1,1),out._y=in._y+rand(-1,1),out._z=in._z+rand(-1,1);
foreach link in cross set _width=0.1;
```