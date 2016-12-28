#! /usr/bin/env perl

use strict;
use warnings;

my $pmid="pmid";
my $year="year";
my $author="author";
my $affiliation="affiliation";
my $title="title";
my $journal="journal";

my $check="pmid";
my $getyear=0;

sub printoutput{
    print("$pmid\t$year\t$journal\t$title\n");
}

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
    # check if monitor turns off, 10 min
    # if not off turn off when I leave
    
}

