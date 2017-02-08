Mango
--
Create interactive 3D visualization of the co-authorship networks.
Network files must be in ../DATA

```
$ .generateGel.sh > loadPubMed.gel
```

Open **Mango**, click on console and run

```
run "loadPubMed.gel";
```

This will display a starting visualization for each network, merge all networks, identify multi-term authors, and export multi-term author information as **multitool-pubmed.tsv**. The exported file can then be used to create the transition matrix.

**Right now the transition matrix is created by hack.pl where single letter codes are hard-coded. Need to make this more general purpose.**

```
$ bash counttrends.sh multitool-pubmed.tsv 
```

Citation information

[Chang, J., Cho, H., and Chou, H., "Mango: combining and analyzing heterogeneous biological networks", BioData Mining, August 2016](http://rdcu.be/nv2u)
