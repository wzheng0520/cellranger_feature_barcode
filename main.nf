#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

include { CELLRANGER_COUNT } from './modules/cellranger-count.nf'


workflow {
    
    libraries = Channel.fromPath(params.input).splitCsv(header:true, quote:'"')
        .map{row -> tuple(
            row.id,
            file(row.fastq_gex).findAll{it.name =~ /R1_001.fastq.gz$/},
            file(row.fastq_gex).findAll{it.name =~ /R2_001.fastq.gz$/},
            file(row.fastq_atac).findAll{it.name =~ /R1_001.fastq.gz$/},
            file(row.fastq_atac).findAll{it.name =~ /R2_001.fastq.gz$/}
        )}
    COUNT(libraries,params.reference,params.feature_ref)
    

}
