#!/bin/bash
#SBATCH --job-name=prokka_hetero
#SBATCH --output=logs/prokka_%A_%a.out
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --array=0-20
#SBATCH --mail-user=nanzhen.qiao@gmail.com
#SBATCH --mail-type=END,FAIL
#SBATCH --constraint=avx512

module load StdEnv/2020 gcc/9.3.0 prokka/1.14.5

FILES=(fna/*.fna)
FNA=${FILES[$SLURM_ARRAY_TASK_ID]}
ACC=$(basename "$FNA" .fna)

# Skip if already done
[ -f "prokka/${ACC}/${ACC}.faa" ] && echo "Skipping $ACC" && exit 0

prokka \
    --kingdom Bacteria \
    --force \
    --outdir "prokka/${ACC}" \
    --prefix "${ACC}" \
    --locustag "${ACC}" \
    --cpus "${SLURM_CPUS_PER_TASK}" \
    "${FNA}"

echo "Done: ${ACC}"