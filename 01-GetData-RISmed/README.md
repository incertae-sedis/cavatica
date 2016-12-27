Get Data
--

Use RISmed R package. All query terms and date ranges should be listed in the above ../config.txt file. You should be able to fetch the entire co-author network for each one of the networks using the following command. A bar chart (by default from 1996 to 2016) is automatically generated and saved to this folder.

From bash command line:
```
$ Rscript fetch.R
```

A bar chart of each network will be generate and tsv files for papers and co-authors. After a quick check, move the tsv files to DATA. Can also move the bar charts to IMG

```
$ mv *.tsv ../DATA/.
$ mv *.png ../IMG/.
```

Citation for the RISmed R Package
```
  Stephanie Kovalchik (2016). RISmed: Download Content from NCBI Databases. R package version 2.1.6.
  https://CRAN.R-project.org/package=RISmed
```