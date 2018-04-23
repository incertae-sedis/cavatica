#! /usr/bin/env perl
# Auth: Jennifer Chang
# Date: 2018/04/23
use strict;
use warnings;

# ========================= Variable
my $pmid="pmid";
my $year="year";
my $author="author";
my $affiliation="affiliation";
my $title="title";
my $journal="journal";

my $check="pmid";
my $getyear=0;

# ========================= Function
sub printoutput{
    print("$pmid\t$year\t$journal\t$title\n");
}

# ========================= Main
printoutput;
while(<>){
    chomp;
    if(/<\/PubmedArticle>/){
	printoutput;
	$pmid="pmid";
	$year="year";
	$journal="journal";
	$title="title";
    }
    if(/<PMID Version="\d+">(\d+)<\/PMID>/){
	if($pmid eq $check){
	    $pmid=$1;
	}
    }
    if(/<ISOAbbreviation>(.+)<\/ISOAbbreviation>/){
	$journal=$1;
    }
    if(/<ArticleTitle>(.+)<\/ArticleTitle>/){
	$title=$1;
    }
    if(/<ArticleDate /){
	$getyear=1;
    }
    if(/<\/ArticleDate>/){
	$getyear=0;
    }
    if(/<PubMedPubDate PubStatus="pubmed">/){
	$getyear=1;
    }
    if(/<\/PubMedPubDate>/){
	$getyear=0;
    }
    if(/<Year>(\d+)<\/Year>/){
	if($getyear==1){
	    $year=$1;
	}
    }
    
}

