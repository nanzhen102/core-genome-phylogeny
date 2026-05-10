#!/usr/bin/env python3
"""
Step 6: Parse FastOrtho MCL output into a pan-genome matrix.

Input:
    all_type.end  - FastOrtho MCL cluster file
    label.tab     - List of genome names (one per line, matching Prokka prefixes)

Output:
    pan_genome.csv - Pan-genome matrix:
                     col 0: cluster name
                     col 1: number of genes in cluster
                     col 2: number of taxa (genomes) in cluster
                     col 3+: gene IDs per genome (semicolon-separated if multiple)

Usage:
    python 5_parser_mcl.py
"""

import re
import csv

# --- Configuration ---
MCL_FILE   = 'all_type.end'
LABEL_FILE = 'label.tab'
OUT_FILE   = 'pan_genome.csv'

# --- Load genome labels ---
with open(LABEL_FILE, 'r') as f:
    labels = [line.strip() for line in f if line.strip()]

n_genomes = len(labels)
print(f"Loaded {n_genomes} genome labels from {LABEL_FILE}")

# Regex to extract genome name from gene ID: e.g. GENOME_00001 -> GENOME
re_strain = re.compile(r'\(([^)]+)\)')
re_genes  = re.compile(r'(\d+) genes')
re_taxa   = re.compile(r'(\d+) taxa')


def parse_mcl(mcl_file):
    """Parse FastOrtho MCL output into a list of rows."""
    rows = []
    with open(mcl_file, 'r') as f:
        for line in f:
            # Initialise row: cluster_name, gene_count, taxon_count, then one col per genome
            row = [''] * (n_genomes + 3)
            line = line.strip()
            parts = line.split('\t')

            family_info = parts[0]
            row[0] = family_info.split(' ')[0]                    # cluster name
            row[1] = re_genes.findall(family_info)[0]             # number of genes
            row[2] = re_taxa.findall(family_info)[0]              # number of taxa

            gene_list = parts[1].strip().split(' ')
            for gene in gene_list:
                genome = re_strain.findall(gene)[0].rstrip('_')   # strip trailing underscore added by FastOrtho
                gene_id = re_strain.sub('', gene)                 # gene ID without genome tag
                col_idx = labels.index(genome) + 3
                if row[col_idx] == '':
                    row[col_idx] = gene_id
                else:
                    row[col_idx] += ';' + gene_id                 # multiple copies: semicolon-separated
            rows.append(row)
    return rows


def save_csv(rows, out_file):
    with open(out_file, 'w', newline='') as f:
        writer = csv.writer(f)
        writer.writerows(rows)


if __name__ == '__main__':
    data = parse_mcl(MCL_FILE)
    save_csv(data, OUT_FILE)
    print(f"Pan-genome matrix written to {OUT_FILE} ({len(data)} clusters)")
