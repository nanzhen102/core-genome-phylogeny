#!/bin/bash
# Step 3: Collect Prokka outputs and prepare pipeline inputs
# Run on login node: bash 3_collect_faa.sh
# Requires: prokka/ directory with completed annotations from step 2

mkdir -p faa

for f in prokka/*/*.faa; do
    cp "$f" faa/
done

cat faa/*.faa > all_prot.fasta

ls faa/*.faa | sed 's|faa/||; s|\.faa||' > label.tab

N=$(ls faa/*.faa | wc -l)
sed -i "s/^N_GENOMES\s*=\s*[0-9]*/N_GENOMES      = ${N}/" 6_get_single.py

echo "Collected ${N} proteomes -> all_prot.fasta"
echo "Total sequences: $(grep -c '>' all_prot.fasta)"
echo "label.tab:"
cat label.tab
echo "N_GENOMES in 6_get_single.py:"
grep "^N_GENOMES" 6_get_single.py
