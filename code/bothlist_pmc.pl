#! /usr/bin/env perl
# Auth: Hui-Hsien Chou
# Date: 2016/01/01

use strict;
use warnings;

die "usage: $0 keyword paper.tsv author.tsv XML_files ...\n" if @ARGV<4;

# =========================== Variables
my $keyword = shift @ARGV;
my $paper_file_name = shift @ARGV;
my $author_file_name = shift @ARGV;

my ($pmid, $pmcid, $title, $year, $text, $shared_aff);
my @authors;
my %affiliations;
my ($article_c, $pmid_c, $pmcid_c, $title_c, $year_c, $text_c) = ( 0, 0, 0, 0, 0, 0 );

# =========================== Main
$keyword = lc $keyword; # comment this line to do case sensitive search

open PAPER, ">$paper_file_name" or die "can't open paper TSV file $paper_file_name to write";
open AUTHOR, ">$author_file_name" or die "can't open author TSV file $author_file_name to write";

print PAPER "pmcid\tyear\tcount\ttitle\tpubmedid\n";
print AUTHOR "pmcid\tforename_lastname\taffiliation\n";

while (<>) {
  if (/<article /) {
    $pmid = $pmcid = $title = $year = $text = $shared_aff = "";
    @authors = ( );
    %affiliations = ( );
    $article_c++;
  } 
  if (/<article-id pub-id-type=\"pmc\">(\d+)<\/article-id>/ && length($pmcid)==0) {
    $pmcid = $1;
    #print STDERR "$pmcid\n";
    $pmcid_c++;
  } 
  if (/<article-id pub-id-type=\"pmid\">(\d+)<\/article-id>/ && length($pmid)==0) {
    $pmid = $1;
    $pmid_c++;
  } 
  if (/<article-title>/ && length($title)==0) {
    chomp;
    $title = $_;
    while ($_ !~ /<\/article-title>/) {
      $_ = <>;
      chomp;
      $title .= $_;
    }
    $title =~ /<article-title>(.+)<\/article-title>/;
    $title = $1;
    $title_c++;
  } 
  if (/<contrib .*contrib-type=\"author\"/) {
    my @a;
    while ($_ !~ /<\/contrib>/) {
      $a[1] = $1 if /<surname>(.+?)<\/surname>/;
      $a[0] = $1 if /<given-names>(.+?)<\/given-names>/;
      $a[2] = $1 if /<xref ref-type=\"aff\" rid=\"(\S+?)(\s|\")/ && !defined($a[2]);
      $a[2] = $1 if /<xref rid=\"(\S+?)(\s|\") ref-type=\"aff\"/ && !defined($a[2]);
      $_ = <>;
    }
    unless (defined($a[0]) || defined($a[1])) {
      warn "incomplete author information";
    } else {
      push @authors, \@a;
    }
  } 
  if (/<aff id=\".+?\"/) {
    chomp;
    my ($i, $a) = ( "", $_);
    while ($_ !~ /<\/aff>/) {
      $_ = <>;
      chomp;
      $a .= $_;
    }
    $a =~ /<aff id=\"(.+?)\".*?>(.+)<\/aff>/ or die "unexpected pattern match errors";
    ($i, $a) = ( $1, $2);
    $a =~ s/^\s*(<([^>]+)>.{0,10}<\/\2>|<[^>]+\/>)\s*//;
    $a =~ s/<email>.*<\/email>//g; # uncomment this line if you want email addresses removed
    $a =~ s/<.+?>//g; # uncomment this line if you want HTML markups removed, too
    $affiliations{$i} = $a;
  } 
  if (/<aff>(.+?)<\/aff>/) {
    $shared_aff = $1;
  } 
  if (/<pub-date .*?(pub-type=\"[pe]pub\"|date-type=\"pub\")/ && length($year)==0) {
    while (1) {
      if (/<year.*?>(\d+)<\/year/) {
	$year = $1;
	$year_c++;
	last;
      } elsif (/<\/pub-date>/) {
	last;
      }
      $_ = <>;
    }
  } 
  if (/<body>/ && defined($text)) {
    chomp;
    $text = $_;
  } 
  if (/<\/body>/ && defined($text)) {
    chomp;
    $text .= $_;
    my $copy = lc $text; # drop 'lc' for case sensitive search
    my $count = () = $copy =~ /$keyword/g;
    $count -= () = $copy =~ /\.$keyword\./g; # uncount cases like www.cytoscape.org
    if ($count>0) {
      if ($pmcid) {
	  $title=~ s/<italic>//g;
	  $title=~ s/<\/italic>//g;
	  $title=~ s/<bold>//g;
	  $title=~ s/<\/bold>//g;
	  $title=~ s/<named-content content-type="genus-species">//g;
	  $title=~ s/<\/named-content>//g;
	  $title=~ s/<sub>//g;
	  $title=~ s/<\/sub>//g;
	  $title=~ s/<sup>//g;
	  $title=~ s/<\/sup>//g;
	  $title=~ s/<styled-content style="fixed-case">//g;
	  $title=~ s/<\/styled-content>//g;
	  $title=~ s/&#x2013;/_/g;
	  $title=~ s/&#x2018;/'/g;
	  $title=~ s/&#x2019;/'/g;
	  $title=~ s/&#x3B2;/beta/g;
	  $title=~ s/&#x2122;/(tm)/g;
	  $title=~ s/&#x3B1;/alpha/g;
	  $title=~ s/&#x3B3;/gamma/g;
 	  $title=~ s/&#x2014;/-/g;
 	  $title=~ s/&#x2010;/-/g;
 	  $title=~ s/&#x201C;/"/g;
 	  $title=~ s/&#x201D;/"/g;
	  $title=~ s/<named-content content-type="taxon-name">//g;
	  $title=~ s/<named-content content-type="family">//g;
	  $title=~ s/<named-content content-type="genus">//g;
	  $title=~ s/<named-content content-type="order">//g;
	  $title=~ s/<named-content content-type="species">//g;
	  $title=~ s/&#xA0;/ /g;
	  $title=~ s/&#x101;/a/g;
	  $title=~ s/&#xE9;/e/g;
	  $title=~ s/&#xAE;/(r)/g;
	  $title=~ s/<sc>//g;
	  $title=~ s/<\/sc>//g;
	  $title=~ s/\t/ /g;

	print PAPER "PMC$pmcid\t$year\t$count\t$title\t$pmid\n";
	warn "PMC id $pmcid has no year info" unless length($year);
	warn "PMC id $pmcid has no author info" unless @authors>0;
	for (@authors) {
	  print AUTHOR "$pmcid\t";
	  if (defined $_->[0]) {
	    print AUTHOR "$_->[0]_";
	  } else {
	    print AUTHOR "UNKNOWN_";
	  }
	  if (defined $_->[1]) {
	    print AUTHOR "$_->[1]\t";
	  } else {
	    print AUTHOR "UNKNOWN\t";
	  }
	  if (defined($_->[2])) {
	    if (defined($affiliations{$_->[2]})) {
	      print AUTHOR "$affiliations{$_->[2]}\n";
	    } else {
	      warn "missing affiliation info $_->[2] mentioned on author list for PMC $pmcid";
	    }
	  } elsif ($shared_aff) {
	    print AUTHOR "$shared_aff\n";
	  } elsif (keys(%affiliations)==1) {
	    print AUTHOR values(%affiliations), "\n";
	  } else {
	    print AUTHOR "UNKNOWN\n";
	  }
	}
      } else {
	die "Article $title has no PMC ID";
      }
    }
    undef $text;
    $text_c++;
  } 
  if (defined($text)) {
    chomp;
    $text .= $_;
  }
}
close PAPER;
close AUTHOR;
print STDERR "Scanned $article_c articles, $pmcid_c PMC ids, $title_c titles, $year_c years and $text_c text bodies\n";
