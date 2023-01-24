#! /usr/bin/env perl

use strict;
use warnings;

# May need to change one letter codes
#my @tools=("C","J","P","V","G","N","I","L","Z");

# FIXED :D :D :D, use full name, however if one term is inside another term will still have problems
my @tools = ();
my $fn    = "config.txt";
my $fh;
open( $fh, '<:encoding(UTF-8)', $fn )
  or die "Could not open file '$fn' $!";

while (<$fh>) {
    chomp;
    if (/^term/) {
    }
    else {
        my @temp = split( /,/, $_ );
        $temp[0] =~ s/\+/_/g;

        #print $temp[0],"\n";
        push @tools, $temp[0];
    }
}

#my @tools=`awk -F',' 'NR>1 {print $1}' ../config.txt`;

# filename = temp-big.tsv
my $count;
my $left;
my $right;
my $cl;    # count left
my $cr;    # count right
my $c = "G";

my %lo;    # left only
my %ro;    # right only
my %bo;    # both

my %trans = ();
while (<>) {
    chomp;
    if (/(\d+) (\S+):(\S+)/) {
        %lo = ();
        %ro = ();
        %bo = ();

        $count = $1;
        $left  = $2;
        $right = $3;

        foreach $c (@tools) {
            $cl = () = $left  =~ /$c/g;
            $cr = () = $right =~ /$c/g;

            if ( $cl && $cl == $cr ) {
                $bo{$c}++;
            }
            if ( $cl < $cr ) {
                $ro{$c}++;
            }
            if ( $cr < $cl ) {
                $lo{$c}++;
            }

            #print "$count $left|$right $cl $cr $c\n";
        }

        foreach my $key ( keys %lo ) {
            foreach my $r ( keys %ro ) {

                #print "$count $left:$right $key:$r LO\n";
                $trans{"$key:$r"} += $count;
            }
            foreach my $r ( keys %bo ) {

                #print "$count $left:$right $key:$r LO\n";
                $trans{"$key:$r"} += $count;
            }
        }
        foreach my $key ( keys %ro ) {
            foreach my $r ( keys %bo ) {

                #print "$count $left:$right $r:$key RO\n";
                $trans{"$r:$key"} += $count;
            }
        }
    }
}

foreach my $tr ( sort keys %trans ) {
    print "$tr $trans{$tr}\n";
}

