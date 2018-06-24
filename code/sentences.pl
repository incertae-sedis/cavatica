#! /usr/bin/env perl
# Auth: Jennifer Chang
# Date: 2018/06/21

use strict;
use warnings;

#my $pmid=27042932;
my $pmid=27042932;
my $ref="";
my $mem="";
#my %refs;
my @sents;
my $title="";

print "<html>\n<body>\n";
while(<>){
    chomp;
    push @sents,split(/\. /,$_);
    if(/ref id="(\S+)">/){
	$mem=$1;
#	print "ref=$mem\n";
    }
    if(/\Q$pmid/){
	$ref=$mem;
#	print "$_\n";
    }
    if(/article-title>(.+)<\/article-title>/){
	if($title eq ""){
#	    print "$_\n";
	    $title=$_;
	}
    }
    if(/<\/article>/){
	print "<H1>$title</H1>\n";
	print "<H3>$ref</H3>\n";
#	print(join(".\n",@sents));	
	my @out=grep /\Q$ref/,@sents;
	print(join(".\n",@out));
	@sents=();
	$title="";
	$ref="";
    }
}
#print(join(".\n",@sents));
print "\n</body>\n</html>\n";
