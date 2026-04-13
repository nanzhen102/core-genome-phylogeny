process ROARY {
    tag "roary_identity${params.identity}"
    publishDir "${params.outdir}/roary", mode: 'copy'

    conda "conda-forge::parallel bioconda::roary=3.13.0"

    cpus params.cpus_roary

    input:
    path gff_files   // all GFFs collected together

    output:
    path "roary_out/core_gene_alignment.aln", emit: alignment
    path "roary_out/summary_statistics.txt",  emit: stats
    path "roary_out/",                        emit: outdir

    script:
    """
    export TMPDIR=\$SLURM_TMPDIR
    export MAFFT_TMPDIR=\$SLURM_TMPDIR

    roary \
        -e -n \
        -f roary_out \
        -p ${task.cpus} \
        -i ${params.identity} \
        *.gff

    echo "Core genes found:"
    head -1 roary_out/summary_statistics.txt
    """
}
