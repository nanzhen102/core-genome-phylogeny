# core-genome-phylogeny

A Nextflow pipeline for core-genome phylogenetic tree building of bacterial genomes.

## Overview
This pipeline automates genome download, annotation, pan-genome analysis,
and maximum-likelihood tree inference for any bacterial genus (Note: Currently designed for genus-level analysis; family-level support is planned).

## Pipeline steps
1. Genome download (NCBI datasets CLI)
2. Genome annotation (Prokka)
3. Pan-genome + core alignment (Roary)
4. Phylogenetic tree (FastTree, GTR+CAT model)

## Requirements
- Nextflow ≥ 23.04
- Conda (for automatic dependency management)
- SLURM (for HPC execution) or local execution

## Input file format
Both input files must be CSV with a header line:

`inputs/accessions.csv` — target genomes. Header `accession`; e.g. `GCA_001435135.1`

`inputs/outgroup.csv` — one or more outgroup genomes.  Header `accession`; e.g. `GCA_001435135.1`

## Key parameters
| Parameter  | Default | Description                                      |
|------------|---------|--------------------------------------------------|
| accessions | —       | CSV file of GenBank accession numbers            |
| outgroup   | —       | CSV file with one or more outgroup accessions    |
| identity   | 60      | Roary blastp identity cutoff (%). The default Roary cutoff (95%) may yield no core genes at genus level — 60% is recommended as a starting point. Adjust based on the number of core genes recovered. |
| outdir     | results | Output directory                                 |  

## Usage
```bash
# On any SLURM cluster (ComputeCanada/CCDB, Queen's CAC, etc.)
nextflow run main.nf -profile slurm \
  --accessions inputs/accessions.csv \
  --outgroup inputs/outgroup.csv \
  --outdir results

# Quick test with 3 genomes
nextflow run main.nf -profile slurm,test

# Resume after interruption
nextflow run main.nf -profile slurm -resume
```

## Planned features
- [ ] Automatic core gene count check with recommended identity adjustment
- [ ] Family-level tree support using single-copy marker genes
- [ ] QC integration (CheckM, fastANI species validation)

## Author
Nanzhen Qiao (nanzhen.qiao@gmail.com)
