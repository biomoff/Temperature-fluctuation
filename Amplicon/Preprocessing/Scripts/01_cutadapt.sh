#!/bin/bash

#SBATCH --partition=uoa-compute
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=6
#SBATCH --mem-per-cpu=4G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=s05am3@abdn.ac.uk

### This was written for cutadapt version 4.4 ###


## Activate conda environment

conda activate amplicon


## Set variables
InputDir="00_RAW-DATA"
OutputDir="01_CUTADAPT"

## Make output directory
mkdir -p $OutputDir

## Run cutadapt
for FILE in $(ls "$InputDir" | awk -F_ '{print $1}' | uniq); do cutadapt --cores 6 --minimum-length 1 -O 3 -e 0.1 -a TCGTCGGCAGCGTCAGATGTGTATAAGAGACAG...CTGTCTCTTATACACATCTCCGAGCCCACGAGAC -A GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAG...CTGTCTCTTATACACATCTGACGCTGCCGACGA -o "$OutputDir"/"$FILE"_1.fastq.gz -p "$OutputDir"/"$FILE"_2.fastq.gz "$InputDir"/"$FILE"_1.fastq.gz "$InputDir"/"$FILE"_2.fastq.gz; done
