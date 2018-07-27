[![Build Status](https://travis-ci.org/incertae-sedis/cavatica.svg?branch=master)](https://travis-ci.org/incertae-sedis/cavatica) [![github release](https://img.shields.io/github/release/incertae-sedis/cavatica.svg?label=current+release)](https://github.com/incertae-sedis/cavatica/releases)
[![https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg](https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg)](https://singularity-hub.org/collections/1322)
[![Docker Automated build](https://img.shields.io/docker/automated/griffinac/cavatica.svg)](https://hub.docker.com/r/griffinac/cavatica/)

This is a fork of [Cavatica](https://github.com/incertae-sedis/cavatica), a pipeline for fetching PubMed and PubMed Central data and co-author network analysis, written by Jennifer Chang. This tool can be used to identify author trends among several search terms. This repo provides a container for easily reproducing and running Cavatica through a container.

## Singularity Container
A singularity container of Cavatica is available on [Singularity Hub](https://singularity-hub.org/collections/1322). Using singularity you can download the contained with the following command:
```
singularity pull shub://TeamMango/cavatica:latest
```
When run, the container will look for a text file called `config.txt` in a directory called `output` in the same directory as the `.simg` you just downloaded. Place the terms that you want Cavatica to search for in this file. In Ubuntu, you can use the following commands to create this file:
```
mkdir output
echo "YOURSEARCHTERM" > ./output/config.txt
```
Your search terms can also be followed by a year range, separated by commas:
```
echo "YOURSEARCHTERM,1996,2006" > ./output/config.txt
```
Each search term and year range should occupy it's own line. If you want to search for use of the term cytoscape and VisANT between 1994 and 2000, `config.txt` would look like this:
```
visant,1999,2006
cytoscape,1994,2003
```
Once you have entered the terms in the `config.txt` file, return to the same directory as the .simg image and run the following command:
```
singularity run --bind output:/cavatica/data/output TeamMango-cavatica-master-latest.simg
```
The results of the search will appear in the `output` directory next to your `config.txt` file.

## Docker Container
You can pull the docker container with the following command:
```
docker pull griffinac/cavatica
```
To run the docker container, move into the directory where you want to generate output from Cavatica. Create three files called `multitool-pubmed.tsv`, `multitool-pmc.tsv`, and `config.txt`. In Ubuntu you can do this with the following command:
```
touch multitool-pubmed.tsv multitool-pmc.tsv config.txt
```
All three files must be present in the directory where you run the container. In `config.txt` enter the search terms that you want Cavatica to search for, with each term on a new line. Optional year ranges can be indicated with commas:
```
visant,1999,2006
cytoscape,1994,2003
```
In the same directory, run the docker container:
```
docker run -v "$PWD":/cavatica/output griffinac/cavatica
```
If on windows, `"$PWD"` should be replaced with the absolute path to your current directory. The files produced by Cavatica should appear on running the container. If you wish to rerun the search with different terms, make sure that the `multitool-pubmed.tsv` and `multitool-pmc.tsv` files are still in the folder. 

## Value of Reproducible Research
[Accomplishments and opportunities of reproducing and containerizing this project](https://hackmd.io/s/r1Vxf9wVX)

## Publications

* J. Chang and H. Chou, "[Cavatica: A pipeline for identifying author adoption trends among software or methods](https://www.computer.org/csdl/proceedings/bibm/2017/3050/00/08217990-abs.html)," 2017 IEEE International Conference on Bioinformatics and Biomedicine (BIBM), Kansas City, MO, USA, 2017, pp. 2145-2150.

