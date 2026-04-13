nextflow.enable.dsl=2

include { DOWNLOAD } from './modules/download'
include { PROKKA   } from './modules/prokka'
include { ROARY    } from './modules/roary'
include { FASTTREE } from './modules/fasttree'

workflow {
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
