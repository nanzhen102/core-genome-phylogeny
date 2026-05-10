#!/usr/bin/env python3
"""
Step 10: Resolve paralogous copies by selecting the longest representative,
         and automatically generate single_core_cluster_id.txt for step 11.

For each cluster in single_gene_95.csv, if a genome has multiple gene copies
(semicolon-separated), select the one with the longest amino acid sequence.

Input:  single_gene_95.csv, all_seq_length_95.tab
Output: single_core_gene_95.csv       - resolved core gene matrix
        single_core_cluster_id.txt    - gene IDs per cluster, tab-separated
                                        (direct input for step 11 MAFFT script)
Usage:
    python 9_filter.py
"""

import csv

LENGTH_FILE  = 'all_seq_length_95.tab'
IN_FILE      = 'single_gene_95.csv'
OUT_FILE     = 'single_core_gene_95.csv'
CLUSTER_FILE = 'single_core_cluster_id.txt'

# --- Load gene lengths ---
length_db = {}
with open(LENGTH_FILE, 'r') as f:
    for line in f:
        gene_id, length = line.strip().split('\t')
        length_db[gene_id] = int(length)

print(f"Loaded lengths for {len(length_db)} genes")


def get_longest(gene_list):
    """Return the gene ID with the maximum sequence length."""
    return max(gene_list, key=lambda g: length_db.get(g, 0))


# --- Resolve paralogs ---
rows = []
with open(IN_FILE, 'r') as f:
    for line in f:
        cols = line.strip().split(',')
        resolved = []
        for col in cols:
            if ';' in col:
                genes = col.split(';')
                resolved.append(get_longest(genes))
            else:
                resolved.append(col)
        rows.append(resolved)

# --- Write resolved matrix ---
with open(OUT_FILE, 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerows(rows)

print(f"Wrote {len(rows)} resolved core gene clusters → {OUT_FILE}")

# --- Automatically generate single_core_cluster_id.txt ---
# Each line: all non-empty gene IDs for one cluster, tab-separated
# Format expected by 10__get_single_core_mafft.pl
with open(CLUSTER_FILE, 'w') as f:
    for row in rows:
        # Gene ID columns start at index 3; skip empty cells (missing taxa)
        gene_ids = [col for col in row[3:] if col.strip()]
        if gene_ids:
            f.write('\t'.join(gene_ids) + '\n')

print(f"Wrote cluster gene ID list → {CLUSTER_FILE}")
print(f"Pipeline can now proceed directly to step 11 (MAFFT alignment).")
