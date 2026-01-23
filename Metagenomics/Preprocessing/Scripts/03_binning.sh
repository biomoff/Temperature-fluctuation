#!/bin/bash

#SBATCH --partition=uoa-compute
#SBATCH --cpus-per-task=15
#SBATCH --mem=24G
#SBATCH --mail-type=ALL

### This was written for metawrap version 1.3.2 ###

## Activate Conda environment

conda activate Metawrap-v1.3.2


## Set directory and file name variables

Reads=1_READ-QC
InputDir=2_ASSEMBLY
OutputDir=3_INITIAL-BINNING

samples=($InputDir/*)                                  # Gets list of all samples
sample=${samples[(($SLURM_ARRAY_TASK_ID-1))]}        # Use array job task number to extract item from sample list and set as filename
sample=$(basename $sample)

echo "Input directory is ${InputDir}"
echo "Output directory is ${OutputDir}"
echo "Sample is ${sample}"


## Unzip read files

echo "Unzipping input files..."

### Forward
echo "Unzipping Forward Reads.."
gunzip -c ${Reads}/${sample}/final_pure_reads_1.fastq.gz > ${Reads}/${sample}/final_pure_reads_1.fastq

### Reverse
echo "Unzipping Reverse Reads.."
gunzip -c ${Reads}/${sample}/final_pure_reads_2.fastq.gz > ${Reads}/${sample}/final_pure_reads_2.fastq


## Make output directories

mkdir -p ${OutputDir}/${sample}


## Assemble reads

metawrap binning -o ${OutputDir}/${sample} -t 15 -m 24 -a ${InputDir}/${sample}/final_assembly.fasta --metabat2 --maxbin2 --universal "$Reads"/${sample}/*_1.fastq "$Reads"/${sample}/*_2.fastq

echo "Binning Complete. Cleaning up files.."


## Remove unzipped read files
rm  ${Reads}/${sample}/final_pure_reads_1.fastq
rm  ${Reads}/${sample}/final_pure_reads_2.fastq


echo "Done."
