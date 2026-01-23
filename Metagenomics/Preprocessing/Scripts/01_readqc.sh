#!/bin/bash

#SBATCH --partition=uoa-compute-priority
#SBATCH --mem-per-cpu=8G
#SBATCH --mail-type=ALL
#SBATCH --cpus-per-task=2

### This was written for metawrap version 1.3.2 ###

## Source own miniconda3 installation

source /uoa/home/"$USER"/miniconda3/etc/profile.d/conda.sh
conda activate Metawrap-v1.3.2


## Set directory and file name variables

InputDir=0_RAW-READS
OutputDir=1_READ-QC

samples=($InputDir/*_1.fastq.gz)
filename=${samples[(($SLURM_ARRAY_TASK_ID-1))]}
sample=$(basename $filename _1.fastq.gz)

echo "Input directory is ${InputDir}"
echo "Output directory is ${OutputDir}"
echo "Sample is ${sample}"


## Make output directories

mkdir -p "$OutputDir"/"$sample"


## Unzip read file

echo "Unzipping input files..."

### Forward
link=$(readlink "$InputDir"/"$sample"_1.fastq.gz)
echo "Unzipping ${link}"
gunzip -c "$link" > "$InputDir"/"$sample"_1.fastq

### Reverse
link=$(readlink "$InputDir"/"$sample"_2.fastq.gz)
echo "Unzipping ${link}"
gunzip -c "$link" > "$InputDir"/"$sample"_2.fastq


## QC and trim raw reads

metawrap read_qc -1 "$InputDir"/"$sample"_1.fastq -2 "$InputDir"/"$sample"_2.fastq -t 2 -o "$OutputDir"/"$sample" --skip-bmtagger

echo "QC Complete. Cleaning up files.."

## Remove unzipped input files

echo "Removing unzipped input files ${InputDir}/${sample}_1.fastq and ${InputDir}/${sample}_2.fastq.."

rm "$InputDir"/"$sample"_1.fastq
rm "$InputDir"/"$sample"_2.fastq


## Zip output files

echo "Zipping output files..."

for file in "$OutputDir"/"$sample"/*.fastq; do gzip -v "$file"; done
for file in "$OutputDir"/"$sample"/*.fq; do gzip -v "$file"; done   # just in case intermediate files left over

echo "Done."
