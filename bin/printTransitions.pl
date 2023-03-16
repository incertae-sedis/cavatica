#! /usr/bin/env perl

use strict;
use warnings;

my $author     = "";
my $year       = "";
my $tool       = "None at";
my @terms      = ();
my $transition = "";
my $count      = 0;
while (<>) {
    chomp;
    @terms = split( /[\t:]/, $_ );
    my $ii = @terms;
    if ( $ii > 2 ) {
        if ( length($author) != 0 && $author eq $terms[0] ) {    # same author
            if ( $year ne $terms[1] ) {    # different year
                if ( $tool ne $terms[2] ) {    # different tool
                    $transition =
                      join( ":", $tool, $terms[2] );    # print transition
                    $count++;
                }
            }
        }
        $author = $terms[0];
        $year   = $terms[1];
        $tool   = $terms[2];
        if ( length($author) != 0 ) {
            print "$author\t$year\t$tool\t$transition\n";
        }
        $transition = "";
    }
}
print STDERR "$count transitions\n"
