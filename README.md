# Cavatica
Code and pipeline for fetching PubMed and PubMed Central data and co-author network analysis. This tool can be used to identify author trends among several search terms. 

An example, I've used these scripts to do a multi-network analysis of network analysis papers and their software. 
[Wiki Page Here](https://github.com/j23414/cavatica/wiki)

<img src="https://github.com/j23414/cavatica/blob/master/IMG/Adder.png" width="600" alt="Added">

The name comes from Charlotte's Web since her full name was Charlotte A. Cavatica. Although Cavatica also refers to barn spider.

## Pipeline

<img src="https://github.com/j23414/cavatica/blob/master/IMG/plan.png" width="600" alt="Plan">

<!--
[List of Entrez Databases](https://eutils.ncbi.nlm.nih.gov/entrez/eutils/einfo.fcgi)

[EBot](http://www.ncbi.nlm.nih.gov/Class/PowerTools/eutils/ebot/ebot.cgi)
-->
## Dependencies

* Some type of Linux Terminal where you can run Bash. (Cygwin if you're on Windows. Terminal already preinstalled on Mac)
* R (check if installed by typing Rscript --version)
* perl (check if installed by typing perl --version)
* Mango Graph Studio for multi-network analysis

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

## NEW: Automatic Transition Table

After editing the config.txt to list all search terms, **basicrun1.sh** will:

* Fetch PubMed and PubMed Central Search Results
* Convert PubMed and PubMed Central XML to author and paper tsv files
* Generate the Mango gel scripts for the dataset
* Identify multi-term authors and save their subnetwork in **multitool-pubmed.tsv** and **multitool-pmc.tsv**

```
$ ./basicrun1.sh
```

Open Mango Graph Studio. From there, open **02-Mango/pubmed.gel** and run the generated gel scripts by typing the following into the console.

```
run "pubmed.gel";
run "pmc.gel";
```

* generates the multitool-pubmed.tsv and multitool-pmc.tsv files

Print out the transition table by running **basicrun2.sh**

```
$ ./basicrun2.sh
```

## Step Two: Fetch Data

Right now there are two options to fetch data from PubMed---Ebot and RISmed. I fyou wish to fetch data from PubMed Central as well, use Ebot.

Depending on which method you choose, enter the **01-GetData-Ebot** or **01-GetData-RISmed** folder. Each of them have README's with instructions.

Copy fetched authors and papers tabular datafiles into the DATA folder. 

## Step Three: Verify Data

If you used RISmed, then you already have barcharts. If you used Ebot, enter 04-BarChart-pubcounts to generate barcharts showing number of publication by year.

Enter **05-OneSentence** to pull out sentences that contain your query term by paper in a html file. This helps manual filtering of many papers.

**Example**: Searching Cytoscape papers for "Cytoscape" results in the following HTML file.

<p><a href="http://www.ncbi.nlm.nih.gov/pubmed/?term=28025995">28025995</a> Prediction of key genes and miRNAs responsible for loss of muscle force in patients during an acute exacerbation of chronic obstructive pulmonary disease.<ul><li>Additionally, key miRNAs were enriched using gene set enrichment analysis (GSEA) software and a miR-gene regulatory network was constructed using <b>Cytoscape</b> software. </ul></p><p><a href="http://www.ncbi.nlm.nih.gov/pubmed/?term=28003598">28003598</a> An iTRAQ-based quantitative proteomics study of refractory mycoplasma pneumoniae pneumonia patients.<ul><li>Functional classification, sub-cellular localization, and protein interaction network were carried out based on PANTHER and <b>cytoscape</b> analysis. </ul></p><p><a href="http://www.ncbi.nlm.nih.gov/pubmed/?term=28000890">28000890</a> Combined analysis of gene expression, miRNA expression and DNA methylation profiles of osteosarcoma.<ul><li>Besides, miRNA-gene regulation network was obtained based on the pairs of involved DEMIs and overlapping genes between DEMs and DEGs and visualized through <b>Cytoscape</b> software. </ul></p>

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
