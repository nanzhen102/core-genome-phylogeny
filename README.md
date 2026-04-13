# core-genome-phylogeny

A Nextflow pipeline for core-genome phylogenetic tree building of bacterial genomes.

## Overview
This pipeline automates genome download, annotation, pan-genome analysis,
and maximum-likelihood tree inference for any bacterial genus.

*Note: Currently designed for genus-level analysis; family-level support is planned.*

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

- `inputs/accessions.csv` — target genomes. Header `accession`; e.g. `GCA_001435135.1`

- `inputs/outgroup.csv` — one or more outgroup genomes.  Header `accession`; e.g. `GCA_001435135.1`


## Usage
```bash
# Quick test with 3 genomes. 
nextflow run main.nf -profile slurm,test

# On any SLURM cluster (ComputeCanada/CCDB, Queen's CAC, etc.)
nextflow run main.nf -profile slurm \
  --accessions inputs/accessions.csv \
  --outgroup inputs/outgroup.csv \
  --outdir results

# Resume after interruption
nextflow run main.nf -profile slurm -resume

# Default `--identity` value is 60%
# Override for a different genus
nextflow run main.nf -profile slurm -resume --identity 70

```

### Choosing the right `--identity` value

| Taxonomic level | Recommended identity | Expected core genes |
|-----------------|---------------------|---------------------|
| Species | 95% (Roary default) | 500–2000 |
| Genus | 60–80% | 100–500 |
| Family | 40–60% | 50–200 |

If core genes < 50, lower `--identity` by 10% and rerun with `-resume`.

If core genes > 1000 at genus level, identity may be too high.

## Planned features
- [ ] Family-level tree support using single-copy marker genes
- [ ] QC integration (CheckM, fastANI species validation)

## Author
Nanzhen Qiao (nanzhen.qiao@gmail.com)
