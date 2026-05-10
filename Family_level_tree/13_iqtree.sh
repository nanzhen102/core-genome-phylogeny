#!/bin/bash
#SBATCH --job-name=iqtree2
#SBATCH --output=logs/iqtree_%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --mem-per-cpu=3000M
#SBATCH --time=24:00:00
#SBATCH --constraint=avx512
#SBATCH --mail-user=nanzhen.qiao@gmail.com
#SBATCH --mail-type=END,FAIL

# Step 14: Infer maximum-likelihood phylogenetic tree with IQ-TREE2
# Input:  TypeStrainDB_core_alignment.fasta
# Output: TypeStrainDB_core_alignment.fasta.treefile (and other IQ-TREE2 output files)
# Runtime: ~3 h for 63 genomes; ~10 h for 342 genomes (30 cores)
#
# Options:
#   -m TEST       = automatically select best substitution model
#   -alrt 1000    = SH-aLRT branch support (1000 replicates)
#   -bb 1000      = ultrafast bootstrap (1000 replicates)
#   --threads-max = use all allocated SLURM CPUs (replaces deprecated -nt in IQ-TREE2)
#
# Note: if IQ-TREE2 fails on the cluster, the web server at
#       https://iqtree.cibiv.univie.ac.at can be used as a fallback
#       with the same command options.

module load StdEnv/2020 gcc/9.3.0 iq-tree/2

iqtree2 \
    -s TypeStrainDB_core_alignment.fasta \
    -m TEST \
    -alrt 1000 \
    -bb 1000 \
    --threads-max ${SLURM_CPUS_PER_TASK}