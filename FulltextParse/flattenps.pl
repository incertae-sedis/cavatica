#! /usr/bin/env perl

use strict;
use warnings;

my $inp=0;
my $text="";
my $temp;

sub printoutput{
    $text=~s/<italic>//g;
    $text=~s/<\/italic>//g;
    $text=~s/<bold>//g;
    $text=~s/<\/bold>//g;
    $text=~s/</(&gt)/g;
    $text=~s/>/(&lt)/g;
    print "<p>$text</p>\n";
}

while(<>){
    chomp;
    if(/(.*)<p>(.+)<\/p>(.*)/){
        print "$1\n";
        $text=$2;
        printoutput;
        print "$3\n";
    }elsif(/(.*)<p>(.+)/){
        print "$1\n";
        $inp=$inp+1;
        $text=$2;
    }elsif(/<p>/){
        $inp=$inp+1;
    }elsif(/(.+)<\/p>(.*)/){
        $temp=$1;
        $temp=~s/^\s+//g;
        $text=join(" ",$text,$temp);
        printoutput;
        print "$2\n";
        $inp=$inp-1;
        $text="";
    }elsif(/<\/p>(.*)/){
        printoutput;
        print "$1\n";
        $inp=$inp-1;
        $text="";
    }elsif($inp){
        $temp=$_;
        $temp=~s/^\s+//g;
        $text=join(" ",$text, $temp);
    }else{
        print "$_\n";
    }
}
