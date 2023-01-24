#! /usr/bin/env perl
# Auth: Jennifer Chang
# Date: 2018/04/23

use strict;
use warnings;

# ========================= Variable
my $unknown = "-";

my $pmid        = "pmid";
my $pmcid       = "pmcid";
my $yyyy        = "year";
my $mm          = "month";
my $dd          = "day";
my $title       = "title";
my $journal     = "journal";
my $forename    = "forename";
my $lastname    = "lastname";
my $affiliation = "affiliation";

my $check   = "pmid";
my $getyear = 0;

# ========================= Function
sub printoutput {
    if ( length($mm) < 2 && $mm ne $unknown ) {
        $mm = "0${mm}";
    }
    if ( length($dd) < 2 && $dd ne $unknown ) {
        $dd = "0${dd}";
    }

    print join( "\t", $pmid, $yyyy, $journal, $title ), "\n";

#    print join("\t", $pmid,$pmcid,$yyyy,"$yyyy/$mm/$dd",$journal,$title,$forename,$lastname,$affiliation), "\n";

    # = Reset variables
    $pmid        = $unknown;
    $pmcid       = $unknown;
    $yyyy        = $unknown;
    $mm          = $unknown;
    $dd          = $unknown;
    $journal     = $unknown;
    $forename    = $unknown;
    $lastname    = $unknown;
    $affiliation = $unknown;
}

# ========================= Main
# = Print tabular header
printoutput;

while (<>) {

    if (/<\/PubmedArticle>/) {
        printoutput;
    }
    elsif (/<ArticleId IdType="pmc">(.+)</) {
        $pmcid = $1;
    }
    elsif (/<PMID Version="\d+">(\d+)<\/PMID>/) {
        if ( $pmid eq $unknown ) {
            $pmid = $1;
        }
    }
    elsif (/<ISOAbbreviation>(.+)<\/ISOAbbreviation>/) {
        $journal = $1;
    }
    elsif (/<ArticleTitle>(.+)<\/ArticleTitle>/) {
        $title = $1;
    }
    elsif (/<ArticleDate /) {
        $getyear = 1;
    }
    elsif (/<\/ArticleDate>/) {
        $getyear = 0;
    }
    elsif (/<PubMedPubDate PubStatus="pubmed">/) {
        $getyear = 1;
    }
    elsif (/<\/PubMedPubDate>/) {
        $getyear = 0;
    }
    elsif (/<LastName>(.+)<\/LastName>/) {
        $lastname = $1;
        $lastname =~ s/ /_/g;
    }
    elsif (/<ForeName>(.+)<\/ForeName>/) {
        $forename = $1;
        $forename =~ s/ /_/g;
    }
    elsif (/<Affiliation>(.+)<\/Affiliation>/) {
        $affiliation = $1;
    }

    if ( $getyear == 1 ) {
        if ( /<Year>(\d+)<\/Year>/ && $yyyy eq $unknown ) {
            $yyyy = $1;
        }
        elsif ( /<Month>(\d+)<\/Month>/ && $mm eq $unknown ) {
            $mm = $1;
        }
        elsif ( /<Day>(\d+)<\/Day>/ && $dd eq $unknown ) {
            $dd = $1;
        }
    }
}

