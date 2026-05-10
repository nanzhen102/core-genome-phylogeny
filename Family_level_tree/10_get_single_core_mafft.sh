#!/bin/bash
#SBATCH --job-name=mafft_align
#SBATCH --output=logs/mafft_%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=1000M
#SBATCH --time=08:00:00
#SBATCH --constraint=avx512
#SBATCH --mail-user=nanzhen.qiao@gmail.com
#SBATCH --mail-type=END,FAIL

# Step 11: Align each core gene cluster with MAFFT
# Input:  single_core_cluster_id.txt, all_prot.ff.fasta
# Output: *.aligned.aln files (one per cluster)
# Runtime: ~2 h for 63 genomes; ~7 h for 370 genomes

module load StdEnv/2020 gcc/9.3.0 mafft
module load StdEnv/2020 bioperl/1.7.7

perl 10__get_single_core_mafft.pl