#!/bin/bash

# filenames from illumina typically are "316671_S4_L001_R1_001.fastq.gz"
SAMPLE_ID=S4
STRAIN_ID=316671

# QC of the 4 paired-end samples
for i in $(seq 1 4); do 
    echo "QC of sample $i R1"
    seqtk trimfq ${STRAIN_ID}_${SAMPLE_ID}_L00${i}_R1_001.fastq.gz > ${STRAIN_ID}_L${i}R1.fastq
    echo "QC of sample $i R2"
    seqtk trimfq ${STRAIN_ID}_${SAMPLE_ID}_L00${i}_R2_001.fastq.gz > ${STRAIN_ID}_L${i}R2.fastq
    echo "done"
done

# merging fastq files by direction (R1 and R2 stay separate)
echo "Starting merge of R1 (this may take a while)"
cat ${STRAIN_ID}_L{1..4}R1.fastq > ${STRAIN_ID}_R1.fastq
echo "Starting merge of R2 (this may take a while)"
cat ${STRAIN_ID}_L{1..4}R2.fastq > ${STRAIN_ID}_R2.fastq
echo "Done merge"

# optional: to verify if it went ok (both number should be the same)
R1=`wc -l < ${STRAIN_ID}_R1.fastq`
R2=`wc -l < ${STRAIN_ID}_R2.fastq`

if [ $"R1" -ne $"R2" ]; then
    echo "Paired-end files should have the same length"
fi

