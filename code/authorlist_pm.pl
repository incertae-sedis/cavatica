#! /usr/bin/env perl
# Auth: Jennifer Chang
# Date: 2018/04/23

use strict;
use warnings;

# ===================== Variables
my $pmid="pmid";
my $forename="forename";
my $lastname="lastname";
my $affiliation="affiliation";

my $check="pmid";
my $getyear=0;

# ===================== Functions
sub printoutput{
    print("$pmid\t${forename}_${lastname}\t$affiliation\n");
}

# ===================== Main
printoutput;
while(<>){
    chomp;
    if(/<\/PubmedArticle>/){
	$pmid="pmid";
    }
    if(/<\/Author>/){
	printoutput;
	$lastname="lastname";
	$forename="forename";
	$affiliation="";
    }
    if(/<PMID Version="\d+">(\d+)<\/PMID>/){
	if($pmid eq $check){
	    $pmid=$1;
	}
    }
    if(/<LastName>(.+)<\/LastName>/){
	$lastname=$1;
	$lastname=~s/ /_/g;
    }
    if(/<ForeName>(.+)<\/ForeName>/){
	$forename=$1;
	$forename=~s/ /_/g;
    }
    if(/<Affiliation>(.+)<\/Affiliation>/){
	$affiliation=$1;
    }

}

