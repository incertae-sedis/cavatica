install.packages("xml2")
library(xml2)
library(readr)
mystring <- read_file("fulltext.xml")
x <- read_xml(mystring)
xml_name(x)
xml_children(x)

article <- xml_find_all(x, ".//article-title")
article
