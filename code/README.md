# Code Lookup

**pubmed_xml.sh**

Given a list of PubMed ids saved as a text file (e.g. query_pm.ids), fetch the PubMed xml entries.

```
$ bash pubmed_xml.sh query_pm.ids > query_pm.xml
```

**pmc_xml.sh**

Given a list of PMC ids saved as a text file (e.g. query_pmc.ids), fetch the PMC xml entries.

```
$ bash pmc_xml.sh query_pmc.ids > query_pmc.xml
```

**authorlist_pm.pl**

Pulls out the paper to author list from the PubMed XML files

```
$ perl authorlist_pm.pl query_pm.xml > query_authors_pm.tsv
```

**paperlist_pm.pl**

Pulls out the paper list from the PubMed XML files

```
$ perl paperlist_pm.pl query_pm.xml > query_papers_pm.tsv
```