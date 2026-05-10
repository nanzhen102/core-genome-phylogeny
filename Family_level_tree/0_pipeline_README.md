# Core Genome Phylogenetic Tree Pipeline - Family level
## Overview
This pipeline builds a core genome maximum-likelihood phylogenetic tree from
bacterial proteomes. It uses FastOrtho for ortholog clustering, MAFFT for
alignment, trimAl for trimming, and IQ-TREE2 for tree inference.

For family level tree building.

## Pipeline Steps

Start: Prepare FastOrtho and catfasta2phyml.pl (0_setup.sh)

Step 1a:  Download genome assemblies.

Step 1b:  Annotate genomes with Prokka

Step 2:  Concatenate all .faa files → all_prot.fasta

Step 3:  Format for FastOrtho (3_format_FastOrth.pl)

Step 4:  All-vs-all BLASTp (3_blast.sh)

Step 5:  Ortholog clustering with FastOrtho (4_fastortho.sh)

Step 6:  Parse MCL output → pan_genome.csv (5_parser_mcl.py)

Step 7:  Filter single-copy core genes (6_get_single.py)

Step 8:  Extract representative gene IDs (7_get_rep_seq_id.py)

Step 9:  Query gene lengths (8_query_gene_length.py)

Step 10: Filter by length and auto-generate single_core_cluster_id.txt (9_filter.py)

Step 11: Align core genes with MAFFT (10_get_single_core_mafft.sh)

Step 12: Trim alignments with trimAl (11_run_trimAl.sh)

Step 13: Concatenate trimmed alignments (12_catfasta2phyml.sh)

Step 14: Infer tree with IQ-TREE2 (13_iqtree.sh)


## Requirements
- Prokka v1.14.5
- BLAST+ v2.9.0 or later
- FastOrtho (compiled from https://github.com/olsonanl/FastOrtho)
- MCL v14.137
- Python 3.x with Biopython
- MAFFT
- trimAl v1.4
- IQ-TREE2
- BioPerl
- catfasta2phyml.pl (https://github.com/nylander/catfasta2phyml)

## Key Parameters (edit before running)
- N_GENOMES: total number of genomes (used in steps 6-7)
- CORE_THRESHOLD: fraction of genomes required for core gene (default 0.95)
- INFLATION: MCL inflation value for FastOrtho (default 2)
- FASTORTHO_PATH: path to FastOrtho executable

## Directory Structure
```
project/
├── faa/                    # Input .faa proteome files (one per genome)
├── logs/                   # SLURM log files
├── ORT_files/              # Intermediate MAFFT alignment files
├── all_prot.fasta          # Concatenated proteomes
├── all_prot.ff.fasta       # FastOrtho-formatted proteomes
├── all_type_prot.blast     # BLASTp output
├── all_type.end            # FastOrtho MCL output
├── pan_genome.csv          # Pan-genome matrix
├── single_gene_95.csv      # Single-copy core gene clusters
├── single_core_gene_95.csv # Filtered core gene matrix
├── single_core_cluster_id.txt  # *** Manually generated from single_core_gene_95.csv ***
├── TypeStrainDB_core_alignment.fasta  # Final concatenated alignment
└── *.treefile              # IQ-TREE2 output tree
```

