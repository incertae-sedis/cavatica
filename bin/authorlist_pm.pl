#! /usr/bin/env perl
# Auth: Jennifer Chang
# Date: 2018/04/23

use strict;
use warnings;

# ===================== Variables
my $unknown = "-";

my $pmid        = "pmid";
my $forename    = "forename";
my $lastname    = "lastname";
my $affiliation = "affiliation";

# ===================== Functions
sub printoutput {
    print join( "\t", $pmid, "${forename}_${lastname}", $affiliation, ), "\n";
    $lastname    = $unknown;
    $forename    = $unknown;
    $affiliation = $unknown;
}

# ===================== Main
printoutput;
$pmid = $unknown;

while (<>) {
    if (/<\/PubmedArticle>/) {
        $pmid = $unknown;
    }
    elsif (/<\/Author>/) {
        printoutput;
    }
    elsif ( /<PMID Version="\d+">(\d+)<\/PMID>/ && $pmid eq $unknown ) {
        $pmid = $1;
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
}

