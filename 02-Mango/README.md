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

However it's best if you open the gel file in Mango, and change the multi-labels to one letter codes. Right now it is labeling papers with full name of query term. The same one letter codes should be used in **hack.pl** script later.

This will display a starting visualization for each network, merge all networks, identify multi-term authors, and export multi-term author information as **multitool-pubmed.tsv**. The exported file can then be used to create the transition matrix.

**Right now the transition matrix is created by hack.pl where single letter codes are hard-coded. Need to make this more general purpose.**

For now open **hack.pl** and change the one letter codes.

```
$ bash counttrends.sh multitool-pubmed.tsv 
```

Citation information

[Chang, J., Cho, H., and Chou, H., "Mango: combining and analyzing heterogeneous biological networks", BioData Mining, August 2016](http://rdcu.be/nv2u)
