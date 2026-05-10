#!/bin/bash
#SBATCH --job-name=catfasta
#SBATCH --output=logs/catfasta_%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=3000M
#SBATCH --time=00:30:00
#SBATCH --constraint=avx512
#SBATCH --mail-user=nanzhen.qiao@gmail.com
#SBATCH --mail-type=END,FAIL

# Step 12: Concatenate trimmed alignments into a single FASTA file
# Input:  alignments/*.trim.fas
# Output: TypeStrainDB_core_alignment.fasta
# Tool:   catfasta2phyml.pl by Johan Nylander (MIT license)
#         https://github.com/nylander/catfasta2phyml

perl /global/project/hpcg1553/Aspen_Nanzhen_Qiao/MGG/catfasta2phyml/catfasta2phyml.pl \
    -c -f alignments/*.trim.fas > TypeStrainDB_core_alignment.fasta

echo "Concatenation complete. Sequences in output:"
grep -c ">" TypeStrainDB_core_alignment.fasta