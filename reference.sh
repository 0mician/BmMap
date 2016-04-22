#!/bin/bash
REFERENCE_FOLDER=reference
REFERENCE=bm.fasta
TOOLS=bin

mkdir $REFERENCE_FOLDER

# download chromosomes 1 to 3 for Burkholderia multivorans strain DDS 15A-1
CHR1="http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&id=NZ_CP008730.1&rettype=fasta&retmode=txt"
CHR2="http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&id=NZ_CP008729.1&rettype=fasta&retmode=txt"
CHR3="http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&id=NZ_CP008728.1&rettype=fasta&retmode=txt"

echo "Downloading chromosomes from NCBI"
curl $CHR1 -o chr1.fasta
curl $CHR2 -o chr2.fasta
curl $CHR3 -o chr3.fasta
echo "Done"

# concatenate chromosomes into 1 fasta file
echo "Concatenating chromosomes into multifasta"
cat chr1.fasta chr2.fasta chr3.fasta > $REFERENCE_FOLDER/$REFERENCE
cd $REFERENCE_FOLDER
echo "Done"

## prepare reference genome for mapping to it (needs: bwa, samtools)
# 1. generate bwa index
bwa index -a bwtsw $REFERENCE
# 2. generate fasta index
samtools faidx $REFERENCE
# 3. create sequence dictionary
java -jar ../$TOOLS/picard.jar CreateSequenceDictionary REFERENCE=$REFERENCE OUTPUT=bm.dict
