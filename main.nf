nextflow.enable.dsl=2

include { DOWNLOAD } from './modules/download'

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

    // Debug: print what came out
    DOWNLOAD.out.fasta.view { acc, fna -> "Downloaded: $acc -> $fna" }
}
