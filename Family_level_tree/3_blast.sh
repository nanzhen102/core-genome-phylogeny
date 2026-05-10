#!/bin/bash
#SBATCH --job-name=blastp_allvall
#SBATCH --output=logs/blastp_%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --mem-per-cpu=1000M
#SBATCH --time=04:00:00
#SBATCH --constraint=avx512
#SBATCH --mail-user=nanzhen.qiao@gmail.com
#SBATCH --mail-type=END,FAIL

# Step 3: All-vs-all BLASTp
# Input:  all_prot.fasta
# Output: all_type_prot.blast

module load StdEnv/2020 gcc/9.3.0 blast+/2.12.0

makeblastdb \
    -in all_prot.fasta \
    -out all_type_prot \
    -dbtype prot

blastp \
    -db all_type_prot \
    -query all_prot.fasta \
    -out all_type_prot.blast \
    -outfmt 6 \
    -evalue 1e-10 \
    -num_threads ${SLURM_CPUS_PER_TASK}
    
echo "Done"
