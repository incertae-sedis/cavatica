#! /usr/bin/env perl

use strict;
use warnings;

die "usage: $0 keyword files ...\n" if @ARGV<2;

my $keyword = shift @ARGV;

my ($pmid, $title, $text, $collect_ref, $ref_id, $first,$pmcid);
my @citations;
my %refs;

my @beginnings = ( "<p>", ". ", "<p ", "<td ", "; ", "<title>", "<th " );
my @endings = ( ".<", ". ", "</p", "</title", "</td", "<hr/>" );
my %wanted_ref_types = ( bibr => 1, fn => 1, ref => 1 );
sub print_HTML_header {
print OUTPUT << "HEADER";
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Sentences that contain $keyword</title>
</head>
<body>
<h1>Sentences that contain $keyword</h1>
HEADER
}

sub print_HTML_ender {
print OUTPUT << "ENDER";
</body>
ENDER
}

*OUTPUT = *STDOUT;
print_HTML_header;
#$keyword = lc $keyword;

open(my $fh, ">pmcid.txt") or die "Could not open file pmcid.txt #!";

while (<>) {
  if (/<article xmlns:/) {
    $pmid = $title = $pmcid = "";
    %refs = ( );
  } elsif (/<article-id pub-id-type=\"pmc\">(\d+)<\/article-id>/ && length($pmcid)==0) {
      $pmcid = $1;
  } elsif (/<article-id pub-id-type=\"pmid\">(\d+)<\/article-id>/ && length($pmid)==0) {
    $pmid = $1;
  } elsif (/<article-title>/ && length($title)==0) {
    chomp;
    $title = $_;
    unless (/<\/article-title>/) {
      while (<>) {
	chomp;
	$title .= $_;
	last if /<\/article-title>/;
      }    
    }
    $title =~ /<article-title>(.+)<\/article-title>/;
    $title = $1;
    $title =~ s/($keyword)/<b>$1<\/b>/gi;
  } elsif (/<body>/) {
    die "unclosed <body> $text" if defined($text);
    $text = "";
  } elsif (/<\/body>/) {
    chomp;
    $text .= $_;
    my $copy = $text; #lc $text;
    my $count = () = $copy =~ /$keyword/g;
    $count -= () = $copy =~ /\.$keyword\./g; # uncount cases like www.cytoscape.org
    $first = 1;
#    while ($text =~ /(\.\s|<p>)([^.]*?$keyword.*?\.)[\s<]/ig) { # rgexp did not work well :(
    my $i=0;
    @citations = ( );
    while (($i=index($copy, $keyword, $i))>=0) { # have to do it mechanically by loops
      my $left = 0;
      for my $tag (@beginnings) {
	my $j = rindex($copy, $tag, $i);
	if ($j>=0) {
	  $j+=length($tag)-1;
	  if (substr($tag, 0, 1) eq "<") {
	    ++$j while ($j<$i && substr($copy, $j, 1) ne ">");
	    ++$j if $j<$i;
	  }
	  $left = $j if $j>$left;
	}
      }
      my $right = length($copy);
      for my $tag (@endings) {
	my $j = index($copy, $tag, $i);
	$right = $j if $j>=0 && $j<$right;
      }
      my $s = substr($text, $left, $right-$left);
      $s =~ s/($keyword)/<b>$1<\/b>/gi;
      if ($first) {
#	open(OUTPUT, ">PMID$pmid.html") || die "can't open PMID$pmid.html for writing";
#	print_HTML_header;
	if ($pmid) {
	  print OUTPUT "<p><a href=\"http://www.ncbi.nlm.nih.gov/pubmed/?term=$pmid\">$pmid</a> <b>($count)</b> $title<ul>"; 
	} else {
	  print OUTPUT "<p><u>No PMID</u> <b>($count)</b> $title<ul>"; 
	}
	print $fh "$pmcid\n";
      }
      while ($s =~ /(<xref[^>]+>[^<]+<\/xref)/gi) {
	my $tag = $1;
	next unless $tag =~ /ref-type=\"(.+?)\"/i;
	next unless exists $wanted_ref_types{$1};
	next unless $tag =~ /rid=\"(.+?)\"[^>]*>([^<]+)<\/xref/i;
	push @citations, [$1, $2];
#	print STDERR "$1 -> $2\n";
      }
      $s =~ s/(<xref[^>]+rid=\"(.+?)\"[^>]*>)([^<]+)(<\/xref)/$1<u>$3<\/u>$4/gi;
      print OUTPUT "<li>$s.";
      $first = 0;
      $i = $right;
    }
#    unless ($first) {
#      print OUTPUT "</ul>\n";
#      print_HTML_ender;
#      close OUTPUT;
#    }
#    for (@citations) {
#      print "$_->[0], $_->[1] ";
#    }
    undef $text;
  } elsif (defined($text)) {
    chomp;
    $text .= $_;
  } elsif (/<ref-list/) {
    $collect_ref = 1;
  } elsif (/<fn-group/) {
    $collect_ref = 1;
  } elsif ($collect_ref && /<ref id=\"(.+?)\"/) {
    $ref_id = $1;
#    print STDERR $1 if $1 eq "mmi12977-bib-0095";
  } elsif ($collect_ref && /<fn id=\"(.+?)\"/) {
    $ref_id = $1;
  } elsif ($collect_ref && /<pub-id pub-id-type=\"pmid\">(\d+)<\/pub-id>/) {
    $refs{$ref_id} = $1;
  } elsif ($collect_ref && /<mixed-citation/) {
    chomp;
    my $line = $_;
    while (1) {
      last if /<\/mixed-citation/;
      $_ = <>;
      chomp;
      $line .= $_;
    }
#    print STDERR "$line\n" if $ref_id eq "B49";
    if ($line =~ /<pub-id pub-id-type=\"pmid\">(\d+)<\/pub-id>/) {
      $refs{$ref_id} = $1;
    } elsif ($line =~ /<mixed-citation[^>]*>(.+)<\/mixed-citation/) {
      $refs{$ref_id} = $1;
    }
  } elsif ($collect_ref && /<element-citation/) {
    chomp;
    my $line = $_;
    while (1) {
      last if /<\/element-citation/;
      $_ = <>;
      chomp;
      $line .= $_;
    }
    if ($line =~ /<pub-id pub-id-type=\"pmid\">(\d+)<\/pub-id>/) {
      $refs{$ref_id} = $1;
    } elsif ($line =~ /<element-citation[^>]*>(.+)<\/element-citation/) {
      $refs{$ref_id} = $1;
    }
  } elsif ($collect_ref && /<ext-link[^>]*>([^<]+)<\/ext-link/) {
    $refs{$ref_id} = "<a href=\"$1\">$1</a>";
  } elsif ($collect_ref && /<\/ref-list>/) {
    print OUTPUT "<li> " if @citations>0;
    for (@citations) {
      if (exists($refs{$_->[0]})) {
	$pmid = $refs{$_->[0]};
	if ($pmid =~ /^\d+$/) {
	  print OUTPUT "\[$_->[1]\](<a href=\"http://www.ncbi.nlm.nih.gov/pubmed/?term=$pmid\">$pmid</a>) ";
	} else {
	  print OUTPUT "\[$_->[1]\]($pmid) "; 
	}
      } else {
	print OUTPUT "\[$_->[1]\]($_->[0]) "; 
      }
    }
    $collect_ref = 0;
  } elsif (/<\/article>/) {
    unless ($first) {
      print OUTPUT "</ul></p>\n";
    }
  }
}
print_HTML_ender;
close $fh;
