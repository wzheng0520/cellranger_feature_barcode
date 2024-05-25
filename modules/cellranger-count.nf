process CELLRANGER_COUNT {
    cpus 32
    memory '128 GB'
    label 'process_high'
    publishDir params.out

    container "nf-core/cellranger:7.1.0"

    input:
    tuple(
        val(id),
        path(gex1, stageAs:"gex/ID_S1_L???_R1_001.fastq.gz"),
        path(gex2, stageAs:"gex/ID_S1_L???_R2_001.fastq.gz"),
        path(atac1, stageAs:"atac/ID_S1_L???_R1_001.fastq.gz"),
        path(atac2, stageAs:"atac/ID_S1_L???_R2_001.fastq.gz")
    )
    path(reference)
    path(feature_ref)

    output:
    path("${id}/outs")

    """
    # prefix all FastQ files with sample ID
    for i in */*.fastq.gz; do mv \$i \${i/ID/${id}}; done

    echo "fastqs,sample,library_type" > libraries.csv
    echo "\$PWD/gex/,${id},Gene Expression" >> libraries.csv
    echo "\$PWD/atac/,${id},Custom" >> libraries.csv
    
    cellranger count   --id=${id} \
                       --transcriptome=${reference} \
                       --libraries=libraries.csv \
                       --feature-ref=${feature_ref} \
                       --localcores=16 \
                       --localmem=64

    """
}