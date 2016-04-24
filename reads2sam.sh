#!/bin/bash

# This scripts takes you from qc'ed reads (fastq) to sam

STRAIN_ID=316372
REFERENCE=reference/bm.fasta

# index reads using burough-wheeler transform (reference genome previously indexed)
bwa aln $REFERENCE ${STRAIN_ID}_R1.fastq > ${STRAIN_ID}_R1.sai
bwa aln $REFERENCE ${STRAIN_ID}_R2.fastq > ${STRAIN_ID}_R2.sai

# align paired-end reads
bwa sampe $REFERENCE \
    ${STRAIN_ID}_R1.sai ${STRAIN_ID}_R2.sai \ 
    ${STRAIN_ID}_R1.fastq ${STRAIN_ID}_R2.fastq \
    > ${STRAIN_ID}.sam


# creation of binary alignment file (bam)
samtools view -Sb -o ${STRAIN_ID} ${STRAIN_ID}.sam
samtools sort ${STRAIN_ID}.bam ${STRAIN_ID}.sorted
samtools index ${STRAIN_ID}.sorted.bam

# get some stats about the reads mapped
samtools flagstat ${STRAIN_ID}.sorted.bam > ${STRAIN_ID}.sorted.bam.stats
