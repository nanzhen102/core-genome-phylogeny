process FASTTREE {
    tag "fasttree"
    publishDir "${params.outdir}/tree", mode: 'copy'

    conda "bioconda::fasttree=2.1.11"

    cpus 8

    input:
    path alignment

    output:
    path "core_genome.tree", emit: tree

    script:
    """
    export OMP_NUM_THREADS=${task.cpus}

    FastTree \
        -nt -gtr \
        -log fasttree.log \
        ${alignment} \
        > core_genome.tree

    echo "Tree tips:"
    grep -o "GCA_[0-9._]*" core_genome.tree | wc -l
    """
}
