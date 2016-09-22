#! /usr/bin/env perl

use strict;
use warnings;

my $pmid=0;

while(<>){
    chomp;
    if(/<PMID Version="\d+">(\d+)<\/PMID>/){
        $pmid=$1;
    }
    if(/<Keyword .+>(.+)<\/Keyword>/){
        print("$pmid\t$1\n");
    }
}
