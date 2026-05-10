#!/usr/bin/env python3
"""
Step 8: Extract representative gene IDs for clusters with paralogs.

For clusters where a genome has multiple gene copies (semicolon-separated),
collect all gene IDs. These will be used to query gene lengths in step 9,
so that the longest representative can be selected in step 10.

Input:  single_gene_95.csv
Output: rep_gene_list_95.tab  (one gene ID per line)

Usage:
    python 7_get_rep_seq_id.py
"""

IN_FILE  = 'single_gene_95.csv'
OUT_FILE = 'rep_gene_list_95.tab'

gene_ids = []

with open(IN_FILE, 'r') as f:
    for line in f:
        cols = line.strip().split(',')
        # Genome columns start at index 3
        for col in cols[3:]:
            if ';' in col:
                gene_ids.extend(col.split(';'))

with open(OUT_FILE, 'w') as f:
    f.write('\n'.join(gene_ids))

print(f"Extracted {len(gene_ids)} representative gene IDs → {OUT_FILE}")
