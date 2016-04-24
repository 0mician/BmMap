#!/bin/bash

# This scripts takes you from the sam files to fastq of unmapped reads
# on which denovo sequencing is performed

STRAIN_ID=316372

# selects unmapped reads from bam and outputs them to a sam file
samtools view -f 4 ${STRAIN_ID}.bam > ${STRAIN_ID}.unmapped.sam

# converting sam file to fastq (preserving paired-end)
java -jar bin/picard.jar SamToFastq I=${STRAIN_ID}.unmapped.sam \
    FASTQ=${STRAIN_ID}.unmapped.R1.fastq SECOND_END_FASTQ=${STRAIN_ID}.unmapped.R2.fastq \
    VALIDATION_STRINGENCY=LENIENT

# merging & converting to fasta (requirement of the assembler)
fq2fa --merge --filter ${STRAIN_ID}.unmapped.R1.fastq ${STRAIN_ID}.unmapped.R2.fastq \
    ${STRAIN_ID}.unmapped.fasta

# denovo assembly
idba --mink 50 --maxk 120 -r ${STRAIN_ID}.unmapped.fasta -o asm
