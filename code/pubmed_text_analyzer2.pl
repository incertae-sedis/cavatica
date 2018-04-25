#!/usr/bin/perl

use strict;
use warnings;

die "usage: $0 keyword files ...\n" if @ARGV<2;

my $keyword = shift @ARGV;

print << "HEADER";
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Sentences that contain $keyword</title>
</head>
<body>
<h1>Sentences that contain $keyword</h1>
HEADER


my ($pmid, $title);
open(PMID, ">pmid.txt");
while (<>) {
  if (/<PubmedArticle>/) {
    $pmid = "";
    $title = "";
  }
  if (/PMID Version=.+>(\d+)<\/PMID>/ && length($pmid)==0) {
    $pmid = $1;
  }
  if (/<ArticleTitle>(.+)<\/ArticleTitle>/&& length($title)==0) {
    $title = $1;
    $title =~ s/($keyword)/<b>$1<\/b>/gi;
  }
  if (/<AbstractText.*?>(.+)<\/AbstractText/) {
    my $abstract = $1;
    my $first = 1;
    while ($abstract =~ /(\. |^)(([^.]|\S\.\S)*?$keyword.*?\.( |$))/ig) {
      print PMID "$pmid\n";
      print "<p><a href=\"http://www.ncbi.nlm.nih.gov/pubmed/?term=$pmid\">$pmid</a> $title<ul>" if $first;
      my $s = $2;
      $s =~ s/($keyword)/<b>$1<\/b>/gi;
      print "<li>$s";
      $first = 0;
    }
    print "</ul></p>" unless $first;
  }
}
close PMID;
print << "ENDER";
</body>
ENDER

