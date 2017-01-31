#! /usr/bin/env perl

use strict;
use warnings;

# filename = temp-big.tsv
my $count;
my $left;
my $right;
my $cl; # count left
my $cr; # count right
my $c="G";

my %lo;  # left only
my %ro;  # right only
my %bo;  # both
while(<>){
    chomp;
    if(/(\d+) (\S+):(\S+)/){
	%lo=();
	%ro=();
	%bo=();
	
        $count=$1;
	$left=$2;
	$right=$3;
	
	$cl=()=$left=~/$c/g;
	$cr=()=$right=~/$c/g;
	
	print "$count $left|$right $cl $cr\n";
    }
}
