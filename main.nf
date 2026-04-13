nextflow.enable.dsl=2

include { DOWNLOAD } from './modules/download'
include { PROKKA   } from './modules/prokka'
include { ROARY    } from './modules/roary'
include { FASTTREE } from './modules/fasttree'

workflow {
  
    // Input validation
    if (!file(params.accessions).exists()) {
        error "Accessions file not found: ${params.accessions}"
    }
    if (!file(params.outgroup).exists()) {
        error "Outgroup file not found: ${params.outgroup}"
    }

    // Check header
    def acc_header = file(params.accessions).readLines()[0].trim()
    def out_header = file(params.outgroup).readLines()[0].trim()

    if (acc_header != "accession") {
        error "accessions.csv must have 'accession' as header. Found: '${acc_header}'"
    }
    if (out_header != "accession") {
        error "outgroup.csv must have 'accession' as header. Found: '${out_header}'"
    }

    // Check not empty
    def acc_count = file(params.accessions).readLines().size() - 1
    if (acc_count < 2) {
        error "accessions.csv must contain at least 2 genomes. Found: ${acc_count}"
    }

    log.info """
    ===============================================
     core-genome-phylogeny
    ===============================================
     accessions : ${params.accessions} (${acc_count} genomes)
     outgroup   : ${params.outgroup}
     identity   : ${params.identity}%
     outdir     : ${params.outdir}
    ===============================================
    """.stripIndent()

    // Pipeline    
    acc_ch = Channel
        .fromPath(params.accessions)
        .splitCsv(header: true)
        .map { row -> row.accession }

    outgroup_ch = Channel
        .fromPath(params.outgroup)
        .splitCsv(header: true)
        .map { row -> row.accession }

    all_acc = acc_ch.mix(outgroup_ch)
    

    DOWNLOAD(all_acc)
    PROKKA(DOWNLOAD.out.fasta)

    //Collect All gff files before Roary
    all_gff = PROKKA.out.gff
    	.map { acc, gff -> gff }
	.collect()

    ROARY(all_gff)
    FASTTREE(ROARY.out.alignment)

    // Final output
    FASTTREE.out.tree.view { tree ->
    	"Tree: $tree"
     }

    // Debug: print what came out
    DOWNLOAD.out.fasta.view { acc, fna -> "Downloaded: $acc -> $fna" }
    PROKKA.out.gff.view {acc, gff -> "Annotated: $acc -> $gff"}
}
