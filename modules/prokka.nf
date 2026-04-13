process PROKKA {
    tag "$accession"
    publishDir "${params.outdir}/prokka", mode: 'copy'

    conda "conda-forge::parallel bioconda::prokka=1.14.5"

    cpus params.cpus_prokka

    input:
    tuple val(accession), path(fasta)

    output:
    tuple val(accession), path("${accession}/${accession}.gff"), emit: gff
    tuple val(accession), path("${accession}/${accession}.log"), emit: log
    tuple val(accession), path("${accession}/${accession}.faa"), emit: faa

    script:
    """
    export TMPDIR=\$SLURM_TMPDIR
    prokka \
        --kingdom Bacteria \
        --outdir ${accession} \
        --prefix ${accession} \
        --locustag ${accession} \
        --cpus ${task.cpus} \
        --force \
        ${fasta}
    """
}
