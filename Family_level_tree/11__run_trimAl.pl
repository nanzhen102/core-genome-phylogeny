#!/usr/bin/perl -w
use strict;

# Step 11: Trim aligned sequences with trimAl
# Input:  alignments/*.aligned.aln
# Output: alignments/*.trim.fas
# Parameter: -gt 0.8 = remove columns with >20% gaps

my $outdir   = "alignments";
my @aln_files = glob("$outdir/*.aligned.aln");

die "No .aligned.aln files found in $outdir/\n" unless @aln_files;

print "Trimming " . scalar(@aln_files) . " alignment files...\n";

foreach my $aln (@aln_files) {
    if ($aln =~ /^$outdir\/(\S+)\.aligned\.aln$/) {
        my $out = "$outdir/$1.trim.fas";
        system("trimal -in $aln -out $out -fasta -gt 0.8");
    }
}

print "Done.\n";