#!/bin/bash
#SBATCH --job-name=trimal
#SBATCH --output=logs/trimal_%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=3000M
#SBATCH --time=00:30:00
#SBATCH --constraint=avx512
#SBATCH --mail-user=nanzhen.qiao@gmail.com
#SBATCH --mail-type=END,FAIL

# Step 12: Trim alignments with trimAl
# Input:  *.aligned.aln files
# Output: *.trim.fas files
# Runtime: ~2 min with sbatch (serial, trimAl is fast per file)

module load StdEnv/2020 trimal/1.4

perl 11__run_trimAl.pl