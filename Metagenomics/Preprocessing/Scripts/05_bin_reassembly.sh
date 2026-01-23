#!/bin/bash

#SBATCH --partition=uoa-compute-priority
#SBATCH --cpus-per-task=10
#SBATCH --mem=100G

### This was written for metawrap version 1.3.2 ###

## Activate Conda environment

conda activate Metawrap-v1.3.2


## Set directory and file name variables

Reads=1_READ-QC
Bins=4_BIN-REFINEMENT
OutputDir=5_BIN-REASSEMBLY

samples=($Bins/*)                                  # Gets list of all samples
sample=${samples[(($SLURM_ARRAY_TASK_ID-1))]}        # Use array job task number to extract item from sample list and set as filename
sample=$(basename $sample)

echo "Sample is ${sample}"
echo "Reads directory is ${Reads}"
echo "Bin directory is ${Bins}"
echo "Output directory is ${OutputDir}"


## Make output directories

mkdir -p ${OutputDir}/${sample}


## Unzip read files

echo "Unzipping input files..."

### Forward
fwd_zipped=${Reads}/${sample}/final_pure_reads_1.fastq.gz
fwd_unzipped=${Reads}/${sample}/final_pure_reads_1.fastq
echo "Unzipping ${fwd_zipped}..."
gunzip -c ${fwd_zipped} > ${fwd_unzipped}

### Reverse
rev_zipped=${Reads}/${sample}/final_pure_reads_2.fastq.gz
rev_unzipped=${Reads}/${sample}/final_pure_reads_2.fastq
echo "Unzipping ${rev_zipped}..."
gunzip -c ${rev_zipped} > ${rev_unzipped}


## Perform bin reassembly

metawrap reassemble_bins -o ${OutputDir}/${sample} -t 10 -m 100 -1 ${fwd_unzipped} -2 ${rev_unzipped} -b ${Bins}/${sample}/metawrap_50_10_bins


echo "Bin reassembly Complete. Cleaning up files.." 


## Remove unzipped input files

echo "Removing unzipped input files ${fwd_unzipped} and ${rev_unzipped}.."

rm ${fwd_unzipped}
rm ${rev_unzipped}


## Finish

echo "Done."
