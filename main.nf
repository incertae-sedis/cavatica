#! /usr/bin/env nextflow

params.config = false
params.term = false

process PUBMED_ID {
  executor 'local'
  maxForks 1  
  input: val(term)
  output: path("${term}_pm.ids")
  script:
  """
  #! /usr/bin/env bash
  pubmed_ids.sh ${term} > ${term}_pm.ids
  sleep 11
  [ -s ${term}_pm.ids ] || exit 1
  """
}

process PUBMED_XML {
  maxForks 1
  input: path(term_pmids)
  output: path("${term_pmids.simpleName}.xml")
  script:
  """
  #! /usr/bin/env bash
  pubmed_xml.sh ${term_pmids} > ${term_pmids.simpleName}.xml
  sleep 13
  [ -s ${term_pmids.simpleName}.xml ] || exit 1
  """
}

process AUTHOR_PM {
  input: path(term_xml)
  output: path("${term_xml.simpleName}_authors.tsv")
  script:
  """
  #! /usr/bin/env bash
  authorlist_pm.pl ${term_xml} > ${term_xml.simpleName}_authors.tsv
  """
}

process PAPER_PM {
  input: path(term_xml)
  output: path("${term_xml.simpleName}_papers.tsv")
  script:
  """
  #! /usr/bin/env bash
  paperlist_pm.pl ${term_xml} > ${term_xml.simpleName}_papers.tsv
  """
}

process PUBMED_QC {
  input: path(term_xml)
  output: path("${term_xml.simpleName}_qc.html")
  script:
  """
  #! /usr/bin/env bash
  TERM=`echo ${term_xml.simpleName} | sed 's/_pm//' | sed 's/+/ /g'` 
  pubmed_text_analyzer2.pl "\$TERM" ${term_xml} > ${term_xml.simpleName}_qc.html
  """
}

process PUBMED_PLOT {
  input: path(papers_tsv)
  output: path("${papers_tsv.simpleName}.png")
  script:
  """
  #! /usr/bin/env bash
  mkBarchart.R ${papers_tsv} ${papers_tsv.simpleName}.png
  """
}

process PMC_ID {
  maxForks 1
  input: val(term)
  output: path("${term}_pmc.ids")
  script:
  """
  #! /usr/bin/env bash
  pmc_ids.sh ${term} > ${term}_pmc.ids
  sleep 17
  [ -s ${term}_pmc.ids ] || exit 1
  """
}

process PMC_XML {
  maxForks 1
  input: path(term_pmcids)
  output: path("${term_pmcids.simpleName}.xml")
  script:
  """
  #! /usr/bin/env bash
  pmc_xml.sh ${term_pmcids} > ${term_pmcids.simpleName}.xml
  sleep 19
  [ -s ${term_pmcids.simpleName}.xml ] || exit 1
  """
}

process PMC_AUTHOR_PAPER {
  input: path(term_xml)
  output: tuple path("${term_xml.simpleName}_authors.tsv"), path("${term_xml.simpleName}_papers.tsv")
  script:
  """
  #! /usr/bin/env bash
  TERM=`echo ${term_xml.simpleName} | sed 's/_pmc//'`
  bothlist_pmc.pl \$TERM ${term_xml.simpleName}_papers.tsv ${term_xml.simpleName}_authors.tsv ${term_xml} 
  """
}

process PMC_QC {
  input: path(term_xml)
  output: path("${term_xml.simpleName}_qc.html")
  script:
  """
  #! /usr/bin/env bash
  TERM=`echo ${term_xml.simpleName} | sed 's/_pmc//'`
  pubmed_fulltext_analyzer_v4.pl "\$TERM" ${term_xml} > ${term_xml.simpleName}_qc.html
  """
}

process PM_GEL_CODE {
  input: val(terms)
  output: path("pubmed.gel")
  script:
  """
  echo $terms | sed 's/\\[//g' | sed 's/\\]//g' | tr ' ' '\n' > config.txt
  generateGel.sh > pubmed.gel
  """
}

process PMC_GEL_CODE {
  input: val(terms)
  output: path("pmc.gel")
  script:
  """
  echo $terms | sed 's/\\[//g' | sed 's/\\]//g' | tr ' ' '\n' > config.txt
  generatePMCGel.sh > pmc.gel
  """
}
workflow {

  if (params.term) {
    term_ch = Channel.from(params.term)
    | view { "=== $it" }
  } else {
  term_ch = Channel.fromPath("$params.config", checkIfExists: true)
    | splitCsv(header: false)
    | map { it -> it[0]}
    | view { "=== $it" }
  }

  /* PubMed */
  term_ch
  | PUBMED_ID
  | PUBMED_XML
  | ( AUTHOR_PM & PAPER_PM & PUBMED_QC )

  /* PubMed Central */
  term_ch
  | PMC_ID
  | PMC_XML
  | ( PMC_AUTHOR_PAPER & PMC_QC )

  PAPER_PM.out 
  | concat(PMC_AUTHOR_PAPER.out | map { n -> n.get(1)})
  | PUBMED_PLOT
  | view

  term_ch 
  | collect
  | view
  | (PM_GEL_CODE & PMC_GEL_CODE)
}