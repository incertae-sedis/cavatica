#!/usr/bin/env perl

use strict;
use warnings;

my $batch_size = 500;
my ($pmcids, $outfile) = @ARGV;
my ($pmcid_list, $pmcid_count) = ( "", 0);

sub call_fetchPMCfulltext_pl {
  open TMP1, ">tmp1.txt";
  print TMP1 $pmcid_list;
  close TMP1;
  system("/usr/bin/perl", "fetchPMCfulltext.pl", "tmp1.txt", "tmp2.txt");
  open TMP2, "tmp2.txt";
  while (<TMP2>) {
    print OUTFILE $_;
  }
  close TMP2;
}

open PMCIDS, $pmcids or die "can't find $pmcids";
open OUTFILE, ">$outfile";
while (<PMCIDS>) {
  $pmcid_list .= $_;
  $pmcid_count++;
  if ($pmcid_count>=$batch_size) {
    call_fetchPMCfulltext_pl();
    ($pmcid_list, $pmcid_count) = ( "", 0);
  }
}
call_fetchPMCfulltext_pl if $pmcid_count;
close OUTFILE;
