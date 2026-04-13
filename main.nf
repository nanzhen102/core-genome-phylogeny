// main.nf
nextflow.enable.dsl=2

include { DOWNLOAD } from './modules/download'
include { PROKKA   } from './modules/prokka'
include { ROARY    } from './modules/roary'
include { FASTTREE } from './modules/fasttree'

workflow {

    // ── Input validation ──────────────────────────────────────────────────────
    if (!file(params.accessions).exists()) {
        error "Accessions file not found: ${params.accessions}"
    }
    if (!file(params.outgroup).exists()) {
        error "Outgroup file not found: ${params.outgroup}"
    }

    def acc_header = file(params.accessions).readLines()[0].trim()
    def out_header = file(params.outgroup).readLines()[0].trim()

    if (acc_header != "accession") {
        error """
        accessions.csv must have 'accession' as header.
        Found: '${acc_header}'
        Fix:   sed -i '1s/^/accession\\n/' ${params.accessions}
        """.stripIndent()
    }
    if (out_header != "accession") {
        error """
        outgroup.csv must have 'accession' as header.
        Found: '${out_header}'
        Fix:   sed -i '1s/^/accession\\n/' ${params.outgroup}
        """.stripIndent()
    }

    def acc_count = file(params.accessions).readLines().size() - 1
    if (acc_count < 2) {
        error "accessions.csv must contain at least 2 genomes. Found: ${acc_count}"
    }

    // ── Run summary ───────────────────────────────────────────────────────────
    log.info """
    =====================================================
     c o r e - g e n o m e - p h y l o g e n y
    =====================================================
     accessions : ${params.accessions} (${acc_count} genomes)
     outgroup   : ${params.outgroup}
     identity   : ${params.identity}%
     outdir     : ${params.outdir}
    =====================================================
    """.stripIndent()

    // ── Input channels ────────────────────────────────────────────────────────
    acc_ch = Channel
        .fromPath(params.accessions)
        .splitCsv(header: true)
        .map { row -> row.accession }

    outgroup_ch = Channel
        .fromPath(params.outgroup)
        .splitCsv(header: true)
        .map { row -> row.accession }

    all_acc = acc_ch.mix(outgroup_ch)

    // ── Pipeline ──────────────────────────────────────────────────────────────
    DOWNLOAD(all_acc)
    PROKKA(DOWNLOAD.out.fasta)

    // Collect all GFFs before Roary
    all_gff = PROKKA.out.gff
        .map { acc, gff -> gff }
        .collect()

    ROARY(all_gff)
    FASTTREE(ROARY.out.alignment)

    // ── Final output ──────────────────────────────────────────────────────────
    FASTTREE.out.tree.view { tree ->
        """
        =====================================================
         Pipeline complete!
         Tree: ${tree}
         Core gene alignment: ${params.outdir}/roary/core_gene_alignment.aln
         Summary stats:       ${params.outdir}/roary/summary_statistics.txt
        =====================================================
        """.stripIndent()
    }

    // ── Debug views ───────────────────────────────────────────────────────────
    DOWNLOAD.out.fasta.view { acc, fna -> "Downloaded : ${acc}" }
    PROKKA.out.gff.view    { acc, gff -> "Annotated  : ${acc}" }
}