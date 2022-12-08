#! usr/bin/env perl

use strict;
use warnings;

while (<>) {
    chomp;
    if (/<Id>(\d+)<\/Id>/) {
        print "$1\n";
    }

    #    if(/<Item Name="pmid" Type="String">(\d+)<\/Item>/){
    #	if($1>0) {print "$1\n";}
    #    }
}
