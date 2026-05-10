#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
use Bio::Seq;

# Step 10: Extract sequences for each core gene cluster and align with MAFFT
# Input:  single_core_cluster_id.txt  (one cluster ID per line, gene IDs tab-separated)
#         all_prot.ff.fasta           (all proteomes, FastOrtho-formatted)
# Output: alignments/<clusterID>.fasta        (unaligned sequences per cluster)
#         alignments/<clusterID>.aligned.aln  (MAFFT-aligned sequences per cluster)

my $threads = $ENV{SLURM_CPUS_PER_TASK} // 4;
my $outdir  = "alignments";

# Create output directory
system("mkdir -p $outdir");

open(my $in_clusters, '<', 'single_core_cluster_id.txt')
    or die "Cannot open single_core_cluster_id.txt: $!";

while (my $line = <$in_clusters>) {
    chomp $line;
    my @gene_ids = split /\s+/, $line;

    # Build lookup hash: gene_id => genome_prefix
    my %gene_lookup;
    foreach my $gene (@gene_ids) {
        if ($gene =~ /^(\S+)_\d+$/) {
            $gene_lookup{$gene} = $1;
        }
    }

    my $fasta_out = "$outdir/" . $gene_ids[0] . ".fasta";
    my $aln_out   = "$outdir/" . $gene_ids[0] . ".aligned.aln";

    # Extract sequences from all_prot.ff.fasta
    my $in_fasta  = Bio::SeqIO->new(-file => 'all_prot.ff.fasta', -format => 'fasta');
    my $out_fasta = Bio::SeqIO->new(-file => ">$fasta_out",        -format => 'fasta');

    while (my $seq = $in_fasta->next_seq) {
        my $id = $seq->id;
        if (exists $gene_lookup{$id}) {
            my $renamed = Bio::Seq->new(-id => $gene_lookup{$id}, -seq => $seq->seq);
            $out_fasta->write_seq($renamed);
        }
    }

    # Align with MAFFT
    system("mafft --thread $threads --auto $fasta_out > $aln_out");
}

close $in_clusters;