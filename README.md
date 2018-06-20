**Author**: Jennifer Chang | **Initial Commit**: July 2016

<p style="text-align: center;">***** Cavatica has been adopted by the incertae-sedis group. *****</p>

# Cavatica
Code and pipeline for fetching PubMed and PubMed Central data and co-author network analysis. This tool can be used to identify author trends among several search terms. 

An example, I've used these scripts to do a multi-network analysis of network analysis papers and their software. 
[Wiki Page Here](https://github.com/incertae-sedis/cavatica/wiki)

<img src="https://github.com/incertae-sedis/cavatica/blob/master/IMG/Adder.png" width="600" alt="Added">

The name comes from Charlotte's Web since her full name was Charlotte A. Cavatica. Although Cavatica also refers to barn spider.

## Pipeline

<img src="https://github.com/incertae-sedis/cavatica/blob/master/IMG/plan.png" width="600" alt="Plan">

<!--
[List of Entrez Databases](https://eutils.ncbi.nlm.nih.gov/entrez/eutils/einfo.fcgi)

[EBot](http://www.ncbi.nlm.nih.gov/Class/PowerTools/eutils/ebot/ebot.cgi)
-->
## Dependencies

* Some type of Linux Terminal where you can run Bash. (Cygwin if you're on Windows. Terminal already preinstalled on Mac)
* R (check if installed by typing Rscript --version)
* perl (check if installed by typing perl --version)
* Mango Graph Studio for multi-network analysis

## Installation

```
git clone https://github.com/incertae-sedis/cavatica.git
```

## Basic Example

Here is a basic example fetching PubMed and PMC papers containing the word "Neo4j". 

```
cd cavatica/data
mkdir test
cd test
echo "Neo4j" > config.txt
echo "Cytoscape" >> config.txt
../../code/script.sh
```

This will create tabular files (list of papers `Neo4j_papers_pm.tsv` and list of authors `Neo4j_authors_pm.tsv`). Open the png files `Neo4j_pm.png` to see a barchart of the number of papers by year.




It will also create a script `pubmed.gel`. Open Mango Graph Studio, open `pubmed.gel` and type the following into the Mango Console.

```
run "pubmed.gel";
```

This will create a transition table and export the file. Going back to your terminal, rerun the script file and it will continue.

```
../../code/script.sh
```

The transitions should be saved in trends_pm.txt. It will then commence searching PMC, fetching list of papers and authors and generating a "pmc.gel" file. Once again open the "pmc.gel" file in Mango and type the following into Mango Console.

```
run "pmc.gel";
```

Then rerun the script to continue tabulating the trends which should be saved in trends_pmc.txt. You can also view the number of papers fetched in barchart form


```
open *.tiff
open *.html
```

## Publications

* J. Chang and H. Chou, "[Cavatica: A pipeline for identifying author adoption trends among software or methods](https://www.computer.org/csdl/proceedings/bibm/2017/3050/00/08217990-abs.html)," 2017 IEEE International Conference on Bioinformatics and Biomedicine (BIBM), Kansas City, MO, USA, 2017, pp. 2145-2150.

