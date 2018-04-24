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
