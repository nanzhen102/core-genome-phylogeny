#!/usr/bin/env python3
"""
Step 9: Query sequence lengths for representative genes.

Parses all_prot.ff.fasta and records the length of each gene in
rep_gene_list_95.tab. Used in step 10 to select the longest
representative when a genome has multiple copies of a core gene.

Input:  all_prot.ff.fasta, rep_gene_list_95.tab
Output: all_seq_length_95.tab  (gene_id <TAB> length)

Usage:
    python 8_query_gene_length.py
"""

from Bio import SeqIO

FASTA_FILE = 'all_prot.ff.fasta'
ID_FILE    = 'rep_gene_list_95.tab'
OUT_FILE   = 'all_seq_length_95.tab'

# Load target gene IDs into a set for fast lookup
with open(ID_FILE, 'r') as f:
    target_ids = set(line.strip() for line in f if line.strip())

print(f"Loaded {len(target_ids)} gene IDs to query")

matched = 0
with open(OUT_FILE, 'w') as out:
    for rec in SeqIO.parse(FASTA_FILE, 'fasta'):
        if rec.id in target_ids:
            out.write(f'{rec.id}\t{len(rec.seq)}\n')
            matched += 1

print(f"Matched and wrote {matched} gene lengths → {OUT_FILE}")
