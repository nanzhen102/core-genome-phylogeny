#!/bin/bash
#SBATCH --job-name=fastortho
#SBATCH --output=logs/fastortho_%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=02:30:00
#SBATCH --cpus-per-task=30
#SBATCH --mem-per-cpu=1000M
#SBATCH --constraint=avx512
#SBATCH --mail-user=nanzhen.qiao@gmail.com
#SBATCH --mail-type=END,FAIL

module load StdEnv/2020 gcc/9.3.0 mcl/14.137

/global/project/hpcg1553/Aspen_Nanzhen_Qiao/MGG/FastOrtho/src/FastOrtho \
    --inflation 2 \
    --mixed_genome_fasta all_prot.ff.fasta \
    --blast_file all_type_prot.blast \
    --working_directory . \
    --project_name all_type