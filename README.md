# Cavatica
Multi-network analysis of network analysis papers and their software

## Plan

<img src="https://github.com/j23414/cavatica/blob/master/IMG/plan.png" width="600" alt="Plan">

-----

The name comes from Charlotte's Web since her full name was Charlotte A. Cavatica. Although Cavatica also refers to barn spider.

[List of Entrez Databases](https://eutils.ncbi.nlm.nih.gov/entrez/eutils/einfo.fcgi)

[EBot](http://www.ncbi.nlm.nih.gov/Class/PowerTools/eutils/ebot/ebot.cgi)


       

## Directory Description

* **EbotScripts**: collection of scripts to fetch Pubmed and PubmedCentral data that matches a query term. Some scripts modified from NCBI Ebot.
* **MkFigures**: from the fetched data, generate a histogram of paper counts by year using an Rscript and ggplot2.
* **OneSentence**: from the fetched data, list sentences that contain the query term in the pubmed abstracts.
* **FullTextParse**: from the fetched data, list sentences that contain the query term and location (in methods section or not) from the Pubmed Central full text.
* **CitationNetwork**: from the fetched data, generate the citation network from Pubmed Central full text. Papers identified by their pubmed ids. If no pubmed id is listed then the citation or paper is ignored.
* **MangoScripts**: from the fetched pubmed data, generate the co-author network and compare networks. Generates the gel script loading networks and placing them in default layout with authors in green and papers in black. 