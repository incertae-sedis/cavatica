# Cavatica
Multi-network analysis of network analysis papers and their software. The name comes from Charlotte's Web since her full name was Charlotte A. Cavatica. Although Cavatica also refers to barn spider.

[List of Entrez Databases](https://eutils.ncbi.nlm.nih.gov/entrez/eutils/einfo.fcgi)

[EBot](http://www.ncbi.nlm.nih.gov/Class/PowerTools/eutils/ebot/ebot.cgi)

## Step One: Query Term(s)

Start by placing your query terms and year search range in **config.txt**. If you have a multi-term query, separate your terms with a `+` symbol. The first line of the config file is for ease of reading and will be ignored by the scripts.

** Example config.txt file **
```
term,start,end
Ingenuity+Pathway+Analysis,1996,2016
Cytoscape,1996,2016
Pathway+Studio,1996,2016
Gephi,1996,2016
GraphViz,1996,2016
VisANT,1996,2016
Neo4j,1996,2016
iGraph,1996,2016
GraphLab,1996,2016
```

## Step Two: Fetch Data

Right now there are two options to fetch data from PubMed---Ebot and RISmed. I fyou wish to fetch data from PubMed Central as well, use Ebot.

Depending on which method you choose, enter the **01-GetData-Ebot** or **01-GetData-RISmed** folder. Each of them have README's with instructions.

Copy fetched authors and papers tabular datafiles into the DATA folder. 

## Step Three: Verify Data

If you used RISmed, then you already have barcharts. If you used Ebot, enter 04-BarChart-pubcounts to generate barcharts showing number of publication by year.

Enter **05-OneSentence** to pull out sentences that contain your query term by paper in a html file. This helps manual filtering of many papers.

## Step Four: Network Analysis

Enter **02-Mango**. 3D visualization of networks. Multi-network addition. Identify multi-term authors. 

-----

## OLD Directory Description (need to clean up)

* **EbotScripts**: collection of scripts to fetch Pubmed and PubmedCentral data that matches a query term. Some scripts modified from NCBI Ebot.
* **MkFigures**: from the fetched data, generate a histogram of paper counts by year using an Rscript and ggplot2.
* **OneSentence**: from the fetched data, list sentences that contain the query term in the pubmed abstracts.
* **FullTextParse**: from the fetched data, list sentences that contain the query term and location (in methods section or not) from the Pubmed Central full text.
* **CitationNetwork**: from the fetched data, generate the citation network from Pubmed Central full text. Papers identified by their pubmed ids. If no pubmed id is listed then the citation or paper is ignored.
* **MangoScripts**: from the fetched pubmed data, generate the co-author network and compare networks. Generates the gel script loading networks and placing them in default layout with authors in green and papers in black. 
