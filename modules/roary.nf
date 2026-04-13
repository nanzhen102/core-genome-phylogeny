process ROARY {
    tag "roary_identity${params.identity}"
    publishDir "${params.outdir}/roary", mode: 'copy',
    	saveAs: { filename -> filename.replace("roary_out/", "") }

    conda "conda-forge::parallel bioconda::roary=3.13.0"

    cpus params.cpus_roary

    input:
    path gff_files   // all GFFs collected together

    output:
    path "roary_out/core_gene_alignment.aln", emit: alignment
    path "roary_out/summary_statistics.txt",  emit: stats
    path "roary_out/*",                        emit: outdir

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
    
    # ── Core gene count check ─────────────────────────────────
    CORE_GENES=\$(grep "Core genes" roary_out/summary_statistics.txt | awk '{print \$NF}')
    echo "Core genes found: \$CORE_GENES (identity=${params.identity}%)"

    if [ "\$CORE_GENES" -lt 50 ]; then
        echo "WARNING: Very few core genes (\$CORE_GENES) found at identity=${params.identity}%"
        echo "WARNING: Consider lowering --identity (e.g. --identity 50)"
        echo "WARNING: Tree may not be reliable with fewer than 50 core genes"
    elif [ "\$CORE_GENES" -lt 100 ]; then
        echo "NOTICE: Low core gene count (\$CORE_GENES) at identity=${params.identity}%"
        echo "NOTICE: Consider lowering --identity if this seems unexpected"
    else
        echo "OK: Core gene count looks good (\$CORE_GENES genes)"
    fi
    """
}    
    
