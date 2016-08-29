#!/usr/bin/perl

use strict;
use warnings;

die "usage: $0 'keyword1 keyword2...' files ...\nkeywords can be PMID or other terms that help identify a cited paper\nmultiple keywords should be put into a single quote\n" if @ARGV<2;

my @keywords = split" ",lc shift @ARGV;

my ($pmid, $title, $text, $copy, $collect_ref, $collect_text, $ref_id, $ref_text, $reported);

my @beginnings = ( "<p>", ". ", "<p ", "<td ", "; ", "<title>", "<th " );
my @endings = ( ".<", ". ", "</p", "</title", "</td", "<hr/>" );

sub print_HTML_header {
print OUTPUT << "HEADER";
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Sentences that contain citations to papers identified by '@keywords'</title>
</head>
<body>
<h1>Sentences that contain citations to papers identified by '@keywords'</h1>
HEADER
}

sub print_HTML_ender {
print OUTPUT << "ENDER";
</body>
ENDER
}

*OUTPUT = *STDOUT;
print_HTML_header;

while (<>) {
  if (/<article xmlns:/) {
    $pmid = $title = $ref_id = $collect_text = $collect_ref = $reported = undef;
  } elsif (/<article-id pub-id-type=\"pmid\">(\d+)<\/article-id>/ && !$pmid) {
    $pmid = $1;
  } elsif (/<article-title>/ && !$title) {
    chomp;
    $title = $_;
    while (1) {
      last if /<\/article-title>/;
      $_ = <>;
      chomp;
      $title .= $_;
    }
    $title =~ /<article-title>(.+)<\/article-title>/;
    $title = $1;
  } elsif (/<body>/) {
    die "unclosed <body> $text" if $collect_text;
    $text = "";
    $collect_text = 1;
  } elsif (/<\/body>/) {
    chomp;
    $text .= $_;
    $copy = lc $text;
    $collect_text = 0;
  } elsif ($collect_text) {
    chomp;
    $text .= $_;
  } elsif (/<ref-list/) {
    $collect_ref = 1;
    $ref_id = undef;
  } elsif (/<fn-group/) {
    $collect_ref = 1;
    $ref_id = undef;
  } elsif ($collect_ref && /<\/ref-list|fn-group>/) {
    $collect_ref = 0;
  } elsif ($collect_ref && /<ref id=\"(.+?)\"/) {
    $ref_id = $1;
    chomp;
    s/^\s+/ /;
    $ref_text = $_;
  } elsif ($collect_ref && /<fn id=\"(.+?)\"/) {
    $ref_id = $1;
    chomp;
    s/^\s+/ /;
    $ref_text = $_;
  } elsif ($ref_id && /<\/ref|fn/) {
    chomp;
    s/^\s+/ /;
    $ref_text .= $_;
    my $target = lc $ref_text;
    my $i=0;
    for ( ; $i<@keywords; ++$i) {
      last unless index($target, $keywords[$i])>=0;
    }
    if ($i>=@keywords) {
      if (!$reported) {
	if ($pmid) {
	  print OUTPUT "<p><a href=\"http://www.ncbi.nlm.nih.gov/pubmed/?term=$pmid\">$pmid</a> $title<ul>\n"; 
	} else {
	  print OUTPUT "<p><u>No PMID</u> $title<ul>\n"; 
	}
	$reported = 1;
      }
      my $i=0;
      my $citation;
      while (($i=index($text, "rid=\"$ref_id\"", $i))>=0) {
	my $begin = rindex($copy, "<xref", $i);
	die "missing <xref begin" unless $begin>=0;
	$begin -= 10;
	$begin = 0 if $begin<0;
	my $left = 0;
	for my $tag (@beginnings) {
	  my $j = rindex($copy, $tag, $begin);
	  if ($j>=0) {
	    $j+=length($tag)-1;
	    if (substr($tag, 0, 1) eq "<") {
	      ++$j while ($j<$i && substr($copy, $j, 1) ne ">");
	      ++$j if $j<$i;
	    }
	    $left = $j if $j>$left;
	  }
	}
	my $end = index($copy, "</xref>", $i);
	die "missing </xref> end" unless $end>=0;
	my $right = length($copy);
	for my $tag (@endings) {
	  my $j = index($copy, $tag, $end);
	  $right = $j if $j>=0 && $j<$right;
	}
	my $s = substr($text, $left, $right-$left);
	$s =~ s/(<xref[^>]+rid=\"(.+?)\"[^>]*>)(.+?)(<\/xref)/$1\[$3\]$4/gi;
	$s =~ s/(<xref[^>]+rid=\"$ref_id\"[^>]*>)(.+?)(<\/xref)/$1<b>$2<\/b>$3/gi;
	if ($citation) {
	  die "inconsistent citation number in the same article" if $citation ne $2;
	} else {
	  $citation = $2;
	}
	print OUTPUT "<li>$s.";
	$i = $right;
      }
      $ref_text =~ s/<pub-id pub-id-type=\"pmid\">(\d+)<\/pub-id>/(<a href=\"http:\/\/www.ncbi.nlm.nih.gov\/pubmed\/?term=$1\">$1<\/a>)/g;
      $ref_text =~ s/<ext-link[^>]*>([^<]+)<\/ext-link>/<a href=\"$1\">$1<\/a>/g;
      if ($citation) {
	print OUTPUT "<li><b>$citation</b> $ref_text.";
      } else {
	print OUTPUT "<li><b>$ref_id not seen in text.</b> $ref_text.";
      }
    }
    $ref_id = undef;
  } elsif ($ref_id) {
    chomp;
    s/^\s+/ /;
    $ref_text .= $_;
  } elsif (/<\/article>/) {
    if ($reported) {
      print OUTPUT "</ul></p>\n";
    }
  }
}
print_HTML_ender;
