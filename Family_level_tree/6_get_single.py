#!/usr/bin/env python3
"""
Step 7: Filter pan-genome matrix for single-copy core gene clusters.

A cluster is retained if:
    - taxon count  >= N_GENOMES * CORE_THRESHOLD  (present in >= 95% of genomes)
    - gene count   <= taxon count * COPY_TOLERANCE (at most 5% paralogs allowed)

Input:  pan_genome.csv
Output: single_gene_95.csv

Usage:
    python 6_get_single.py

Parameters to set before running:
    N_GENOMES        - total number of genomes in the dataset
    CORE_THRESHOLD   - minimum fraction of genomes for a core gene (default 0.95)
    COPY_TOLERANCE   - maximum allowed ratio of genes:taxa (default 1.05)
"""


# --- Configuration: SET THESE BEFORE RUNNING ---
N_GENOMES      = 21    # total number of genomes
CORE_THRESHOLD = 0.95  # gene must be present in >= 95% of genomes
COPY_TOLERANCE = 1.05  # gene count must be <= taxon count * 1.05 (allows ~5% paralogs)

# Derived thresholds
min_taxa = int(N_GENOMES * CORE_THRESHOLD)
print(f"Filtering for clusters present in >= {min_taxa}/{N_GENOMES} genomes "
      f"(>= {CORE_THRESHOLD*100:.0f}%) with <= {COPY_TOLERANCE}x copy tolerance")

IN_FILE  = 'pan_genome.csv'
OUT_FILE = 'single_gene_95.csv'

retained = 0
total    = 0

with open(IN_FILE, 'r') as f_in, open(OUT_FILE, 'w') as f_out:
    for line in f_in:
        total += 1
        cols      = line.split(',')
        taxon_count = int(cols[2])
        gene_count  = int(cols[1])
        if taxon_count >= min_taxa and gene_count <= taxon_count * COPY_TOLERANCE:
            f_out.write(line)
            retained += 1

print(f"Retained {retained}/{total} clusters as single-copy core genes → {OUT_FILE}")
