#! /usr/bin/env perl

use strict;
use warnings;

my $p=0;
my @temp={0,1};
while(<>){
    chomp;
    if($p==1){
        if(/#(.+)/){
	    @temp = split(/\t/,$_);
            print "$temp[0] $temp[1]\n";
        }else{
	    @temp = split(/\t/,$_);
            print "$temp[0] $temp[1]\n";
        }
    }
    if(/^-$/){
        $p=1;
    }
}
