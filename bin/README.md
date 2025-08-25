# Code Lookup

--
**pubmed_ids.sh**

Given a search term, fetches the PubMed IDs. The maximum ammount returned is 10,000 entries. However feel free to adjust **RETMAX** variable to return more.

```
$ bash pubmed_ids.sh query > query_pm.ids
```

Example run:

```
$ bash pubmed_ids.sh Neo4j > Neo4j_pm.ids

  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1152    0  1152    0     0   3226      0 --:--:-- --:--:-- --:--:--  3226
<Count>26</Count>
<RetMax>26</RetMax>

$ less Neo4j_pm.ids

30935389
30689784
30864352
30444913
30271886
...

```

--
**pmc_ids.sh**

Given a search term, fetches the PMC IDs. The maximum ammount returned is 10,000 entries. However feel free to adjust **RETMAX** variable to return more.

```
$ bash pmc_ids.sh query > query_pmc.ids
```

Example run:

```
$ bash pmc_ids.sh Neo4j > Neo4j_pmc.ids

  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  3108    0  3108    0     0   8200      0 --:--:-- --:--:-- --:--:--  8178
<Count>136</Count>
<RetMax>136</RetMax>

$ less Neo4j_pmc.ids

PMC6459178
PMC6444506
PMC6393361
PMC6384242
PMC6376747
PMC6410296
PMC6348742
...

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

**pmc_getpdf.sh**

Given a list of PMC IDs in a text file, fetch the pdfs of the articles.

```
$ bash pmc_getpdf.sh pmcids.txt
```

Will name the pdfs by the PMCID and place in current folder.

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

<img src="https://github.com/incertae-sedis/cavatica/blob/main/IMG/Cytoscape-pubmedcounts.png" width="300" alt="PubMed counts"><img src="https://github.com/incertae-sedis/cavatica/blob/main/IMG/Cytoscape-full-pubmedcounts.png" width="300" alt="PMC counts">

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

<img src="https://github.com/incertae-sedis/cavatica/blob/main/IMG/Cytoscape-pubmedcounts.png" width="600" alt="Cytoscape">

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

# Get Data - Ebot

Use a combination of Ebot (NCBI) scripts and personal perl scripts to fetch co-authorship networks and full xml records from PubMed and PubMedCentral.

Edit ../config.txt to list query terms. Then fetch data with the following command.

```
$ ./FetchData.sh
```

Fetched data will be inside the generated folder **DATAHERE**.

## Scripts generated by NCBI EBot

The following scripts were generated by NCBI Ebot but modified to take an argument. Dec 2016, added http parameter to use HTTP GET instead of POST. Mac version required up date of LWP::UserAgent and Mozilla::CA

* searchpmc.pl
* searchpubmed.pl
* fetchPMCfulltext.pl
* fetchPubmedData.pl

## In house scripts

* convert2tsv.pl
* pulloutPMC.pl
* getPM2Author.pl
* mapPMC2PM.pl

Citation for the Ebot Scripts:

```
# ===========================================================================
#
#                            PUBLIC DOMAIN NOTICE
#               National Center for Biotechnology Information
#
#  This software/database is a "United States Government Work" under the
#  terms of the United States Copyright Act.  It was written as part of
#  the author's official duties as a United States Government employee and
#  thus cannot be copyrighted.  This software/database is freely available
#  to the public for use. The National Library of Medicine and the U.S.
#  Government have not placed any restriction on its use or reproduction.
#
#  Although all reasonable efforts have been taken to ensure the accuracy
#  and reliability of the software and data, the NLM and the U.S.
#  Government do not and cannot warrant the performance or results that
#  may be obtained by using this software or data. The NLM and the U.S.
#  Government disclaim all warranties, express or implied, including
#  warranties of performance, merchantability or fitness for any particular
#  purpose.
#
#  Please cite the author in any work or product based on this material.
#
# ===========================================================================
#
# Author:  Eric W. Sayers  sayers@ncbi.nlm.nih.gov
# http://www.ncbi.nlm.nih.gov/Class/PowerTools/eutils/course.html
#
#
# ---------------------------------------------------------------------------
```
Mango
--
Create interactive 3D visualization of the co-authorship networks.
Network files must be in ../DATA

```
$ .generateGel.sh > loadPubMed.gel
```

Open **Mango**, click on console and run

```
run "pubmed.gel";
run "pmc.gel";
```

These scripts load and merge multiple network files, identifies multi-term authors and exports the corresponding multi-term subnetwork as:

* multitool-pubmed.tsv
* multitool-pmc.tsv

The tsv files are the input for basicrun2.pl in order to generate the author adoption table.

If you want to visualize the co-authorship publication network, it is highly recommended that you open the "pubmed.gel" or "pmc.gel" scripts, comment out the export command, and change the labeles from the full terms to one letter codes for ease of reading.

The exported tsv files can then be used to create the transition matrix.

```
$ bash counttrends.sh multitool-pubmed.tsv
```

Citation information for Mango Graph Studio

[Chang, J., Cho, H., and Chou, H., "Mango: combining and analyzing heterogeneous biological networks", BioData Mining, August 2016](http://rdcu.be/nv2u)
