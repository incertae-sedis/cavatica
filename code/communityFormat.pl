#! /usr/bin/env perl

use strict;
use warnings;

my @terms=();
my $i=0;
my $in_nodes=0;
while(<>){
    chomp;
    if(/^-/){
	$in_nodes=0;
    }
    if($in_nodes==1){
	@terms=split(/[\t]/,$_);
	$i=@terms;

	$terms[$i-1]=~/(\d+):(.+)/;
	
	print $1,"\t",$terms[1],"\t",$terms[0],"\t",$terms[3],"\t",$2,"\n";
    }
    if(/^#pmid/){
	$in_nodes=1;
    }

}
