#!/usr/bin/perl -w
use strict;

# Step 3: Format all_prot.fasta for FastOrtho input
# FastOrtho requires headers in the format: >GENEID [GENOME A]
# Input:  all_prot.fasta  (headers: >GENOME_LOCUSTAG description)
# Output: all_prot.ff.fasta

# Expected input header format: >GENOME_LOCUSTAG description
# Output header format:         >GENOME_LOCUSTAG [GENOME A]

open(my $in,  '<', 'all_prot.fasta')    or die "Cannot open all_prot.fasta: $!";
open(my $out, '>', 'all_prot.ff.fasta') or die "Cannot open all_prot.ff.fasta: $!";

while (<$in>) {
    chomp;
    if (/^>((\S+)_\d+)\s+.+/) {
        # $1 = full gene ID (e.g. GENOME_00001)
        # $2 = genome prefix (e.g. GENOME)
        print $out ">$1 [$2 A]\n";
    } else {
        print $out "$_\n";
    }
}

close $in;
close $out;