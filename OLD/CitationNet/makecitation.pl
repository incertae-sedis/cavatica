#! /usr/bin/env perl
use strict;
use warnings;

my $incitation=0;
my $inmeta=0;
my $pmid=0;
my $citid=0;

sub printcitation{
    if($citid>0 && $pmid>0){
	print "$pmid\t$citid\n";
    }
    $citid=0;
}

while(<>){
    chomp;
    if(/<element-citation/){
	$incitation=1;
    }
    if(/<\/element-citation>/){
	printcitation;
	$incitation=0;
    }
    if(/<pub-id pub-id-type="pmid">(\d+)<\/pub-id>/){
#	print "$1:";
	if($incitation>0){
	    $citid=$1;
	}
    }
    if(/<article-meta/){
	$inmeta=1;
    }
    if(/<\/article-meta>/){
	$inmeta=0;
    }
    if(/<article-id pub-id-type="pmid">(\d+)<\/article-id>/){
	if($inmeta>0){
	    $pmid=$1;
	}
    }
}
