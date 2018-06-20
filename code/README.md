# Code Lookup

--
**pubmed_ids.sh**

Given a search term, fetches the PubMed IDs. The maximum ammount returned is 10,000 entries. However feel free to adjust **RETMAX** variable to return more.

```
$ bash pubmed_ids.sh query > query_pm.ids
$ # More concrete example
$ bash pubmed_ids.sh Neo4j > Neo4j_pm.ids
```

--
**pmc_ids.sh**

Given a search term, fetches the PMC IDs. The maximum ammount returned is 10,000 entries. However feel free to adjust **RETMAX** variable to return more.

```
$ bash pmc_ids.sh query > query_pmc.ids
$ # More concrete example
$ bash pmc_ids.sh Neo4j > Neo4j_pmc.ids
```

--
**pubmed_xml.sh**

Given a list of PubMed ids saved as a text file (e.g. query_pm.ids), fetch the PubMed xml entries.

```
$ bash pubmed_xml.sh query_pm.ids > query_pm.xml
```
--
**pmc_xml.sh**

Given a list of PMC ids saved as a text file (e.g. query_pmc.ids), fetch the PMC xml entries.

```
$ bash pmc_xml.sh query_pmc.ids > query_pmc.xml
```
--
**authorlist_pm.pl**

Pulls out the paper to author list from the PubMed XML files

```
$ perl authorlist_pm.pl query_pm.xml > query_authors_pm.tsv
```
--
**paperlist_pm.pl**

Pulls out the paper list from the PubMed XML files

```
$ perl paperlist_pm.pl query_pm.xml > query_papers_pm.tsv
```
--
**bothlist_pmc.pl**

Pulls out the author and paper list from the PMC XML files

```
$ perl bothlist_pmc.pl "." query_papers_pmc.tsv query_authors_pmc.tsv query_pm.xml > query_papers_pm.tsv
```
--
**mkBarchart.R**

Number of publications by year. Create barchart of number of papers by year. Will generate barcharts of number of publications by year for PubMed and PubMed Central Results. Can pass in a range of years for the x axis.

```
$ Rscript mkBarchart.R query_papers_pm.tsv query_pm.tiff
$ Rscript mkBarchart.R query_papers_pm.tsv query_pm.tiff 1996 2016
```

<img src="https://github.com/incertae-sedis/cavatica/blob/master/IMG/Cytoscape-pubmedcounts.png" width="300" alt="Plan"><img src="https://github.com/incertae-sedis/cavatica/blob/master/IMG/Cytoscape-full-pubmedcounts.png" width="300" alt="Plan">

--
**rismed_pm.R**

Use RISmed R package to fetch pubmed results. All query terms and date ranges should be listed in a config.txt file. You should be able to fetch the entire co-author network for each one of the networks using the following command. A bar chart (by default from 1996 to 2016) is automatically generated and saved to this folder.

From bash command line:

```
$ Rscript rismed_pm.R
```

A bar chart of each network will be generate and tsv files for papers and co-authors. After a quick check, move the tsv files to DATA. Can also move the bar charts to IMG. This script is a combination of `pubmed_xml.sh` and `mkBarchart.R`.

```
$ mv *.tsv ../DATA/.
$ mv *.png ../IMG/.
```

<img src="https://github.com/incertae-sedis/cavatica/blob/master/IMG/Cytoscape-pubmedcounts.png" width="600" alt="Cytoscape">

**Citation for the RISmed R Package**

```
  Stephanie Kovalchik (2016). RISmed: Download Content from NCBI Databases. R package version 2.1.6.
  https://CRAN.R-project.org/package=RISmed
```
--
**europepmc_xml.sh**

* Searches PMC, Europe PMC and a few other databases
* Has features to download fulltext
* The xml lists the results, but not the full text
* Can use FTP to get XML or text FullText

```
$ bash europepmc_xml.sh query > query.xml
```
--
**makeOneSentence**

Provides a visual check of the Cavatica results. A means to manually curate the results and produce more accurrate analysis without hard-coding and losing flexibility. Pulls out sentences that contain the query term to debug the PubMed search.

```
$ ./makeOneSentence.sh
```

Generates html files with links to the full paper. Helps filter VisANT and Pathway Studio results.

--
**igraphrunner.R**

Load networks using readr. Calculate size of largest cluster and plot centrality measres.

```
$ Rscript igraphrunner.R
```

Citation Information:

```
 Csardi G, Nepusz T: The igraph software package for complex network research, InterJournal, Complex
  Systems 1695. 2006. http://igraph.org
```