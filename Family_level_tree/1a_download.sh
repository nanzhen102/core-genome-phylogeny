#!/bin/bash
# =============================================================================
# Step 0a: Download genomes from NCBI FTP using wget
#
# Run this script on the LOGIN NODE (not as a SBATCH job) since compute nodes
# on Graham do not have internet access but login nodes do.
#
# Usage: bash 0a_download.sh
#
# Outputs:
#   fna/    - downloaded genome FASTA files (named by sanitized accession)
#
# =============================================================================

set -e  # exit on any error

# --- Genome accessions (Heterofermentative type strains, Sheet 202605) ---
ACCESSIONS=(
    "GCA_001433875.1"   # Lactobacillus delbrueckii (outgroup)
    "GCA_001434175.1"   # Lactiplantibacillus plantarum (outgroup)
    "GCA_001434095.1"   # Fructilactobacillus fructivorans
    "GCA_004359375.1"   # Acetilactobacillus jinshanensis
    "GCA_027923585.1"   # Philodulcilactobacillus myokonensis
    "GCA_023380205.1"   # Nicoliella spurrieriana
    "GCA_001433825.1"   # Apilactobacillus kunkeei
    "GCA_001434735.1"   # Lentilactobacillus buchneri
    "GCA_001436395.1"   # Secundilactobacillus malefermentans
    "GCA_001433855.1"   # Levilactobacillus brevis
    "GCA_001436295.1"   # Paucilactobacillus vaccinostercus
    "GCA_013394085.1"   # Limosilactobacillus fermentum
    "GCA_001435135.1"   # Furfurilactobacillus rossiae
    "GCA_017694665.1"   # Gallilactobacillus intestinavium
    "GCA_918814755.1"   # Periweissella ghanensis
    "GCA_001437355.1"   # Weissella viridescens
    "GCA_000372485.1"   # Oenococcus oeni
    "GCA_963930865.1"   # Eupransor demetentiae
    "GCA_003096575.1"   # Convivina intestini
    "GCA_001438695.1"   # Fructobacillus fructosus
    "GCA_000014445.1"   # Leuconostoc mesenteroides
)

NCBI_FTP="https://ftp.ncbi.nlm.nih.gov/genomes/all"
mkdir -p fna logs

# --- Helper: convert accession to NCBI FTP directory path ---
# GCA_001433875.1 -> GCA/001/433/875
acc_to_path() {
    echo "$1" | grep -oP '(?<=GCA_)\d+' | sed 's/.\{3\}/&\//g' | sed 's|/$||'
}

FAILED=()

for ACC in "${ACCESSIONS[@]}"; do
    echo "=========================================="
    echo "Downloading: ${ACC} -> fna/${ACC}.fna"

    # Build FTP directory path
    DIGITS=$(acc_to_path "${ACC}")
    FTP_DIR="${NCBI_FTP}/GCA/${DIGITS}"

    # Find the assembly subdirectory name (e.g. GCA_001433875.1_ASM143387v1)
    ASM_DIR=$(wget -q "${FTP_DIR}/" -O - | \
              grep -oP '(?<=href=")[^"]+(?=/)' | \
              grep "^GCA_" | head -1)

    if [ -z "${ASM_DIR}" ]; then
        echo "ERROR: Could not find assembly directory for ${ACC} at ${FTP_DIR}" >&2
        FAILED+=("${ACC}")
        continue
    fi

    # Find the genomic .fna.gz file
    FNA_FILE=$(wget -q "${FTP_DIR}/${ASM_DIR}/" -O - | \
               grep -oP '(?<=href=")[^"]+_genomic\.fna\.gz(?=")' | \
               grep -v "_from_" | head -1)

    if [ -z "${FNA_FILE}" ]; then
        echo "ERROR: Could not find genomic .fna.gz for ${ACC}" >&2
        FAILED+=("${ACC}")
        continue
    fi

    # Download and decompress
    wget -q "${FTP_DIR}/${ASM_DIR}/${FNA_FILE}" -O "${ACC}.fna.gz"
    gunzip "${ACC}.fna.gz"
    mv "${ACC}.fna" "fna/${ACC}.fna"

    echo "Done: ${ACC} -> fna/${ACC}.fna"
done

echo ""
echo "=========================================="
N_SUCCESS=$(ls fna/*.fna 2>/dev/null | wc -l)
echo "Downloaded ${N_SUCCESS}/${#ACCESSIONS[@]} genomes successfully"

if [ ${#FAILED[@]} -gt 0 ]; then
    echo ""
    echo "FAILED accessions (re-download manually before proceeding):"
    for f in "${FAILED[@]}"; do echo "  $f"; done
else
    echo "All downloads successful."
    echo ""
    echo "Next step: sbatch 0b_prokka.sh"
fi