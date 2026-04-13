process DOWNLOAD {
    tag "$accession"
    publishDir "${params.outdir}/genomes", mode: 'copy'

    conda "conda-forge::ncbi-datasets-cli"

    input:
    val accession

    output:
    tuple val(accession), path("${accession}.fna"), emit: fasta

    script:
    """
    datasets download genome accession ${accession} \
        --include genome \
        --filename ${accession}.zip
    unzip -o ${accession}.zip
    cp ncbi_dataset/data/${accession}/*.fna ${accession}.fna
    """
}
