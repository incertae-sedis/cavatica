#! /usr/bin/env perl

use strict;
use warnings;

my $com    = -1;
my $year   = 0;
my $count  = 0;
my $lcount = 0;

my $sum   = 0.0;
my $dyear = 0;

my $papers = 0;

sub printSum() {

    #    print "  Sum: $count $lcount $dyear =",($count-$lcount)/$dyear,"\n";
    if ( $year != 2017 ) {
        print "  Sum: $count $year =", ($count) / ( 2017 - $year ), "\n";
        $sum += ($count) / ( 2017 - $year );

        #    $sum+=($count-$lcount)/$dyear;
        $papers += $count;
    }
}

sub printTotal() {
    print "$papers\t$com\tTotal=$sum\n";
}

while (<>) {
    chomp;
    if (/^(\d+)\t(\d\d\d\d)\t/) {

        if ( $com != $1 ) {
            if ( $com >= 0 ) {
                printSum();
                printTotal();
            }
            $com    = $1;
            $dyear  = 1;
            $year   = $2;
            $lcount = 0;
            $count  = 1;
            $sum    = 0.0;
            $papers = 0;

        }
        elsif ( $year != $2 ) {
            printSum();
            $lcount = $count;
            $count  = 1;
            $dyear  = $2 - $year;
            $year   = $2;
        }
        else {
            $count++;
        }

        print "$1\t$2\n";
    }
}

if ( $com >= 0 ) {
    printSum();
    printTotal();
}
