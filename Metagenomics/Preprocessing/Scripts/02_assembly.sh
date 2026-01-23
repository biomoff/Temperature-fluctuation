#!/bin/bash

#SBATCH --partition=uoa-compute
#SBATCH --cpus-per-task=20
#SBATCH --mem=300G
#SBATCH --mail-type=ALL

### This was written for metawrap version 1.3.2 ###

## Activate Conda environment

conda activate Metawrap-v1.3.2


## Set directory and file name variables

InputDir=1_READ-QC
OutputDir=2_ASSEMBLY

samples=($InputDir/*)                                  # Gets list of all samples
sample=${samples[(($SLURM_ARRAY_TASK_ID-1))]}        # Use array job task number to extract item from sample list and set as filename
path=${sample}

echo "Input directory is ${InputDir}"
echo "Output directory is ${OutputDir}"
echo "Sample is ${sample}"


## Make output directories

mkdir -p ${OutputDir}/$(basename "$sample")


## Unzip read file

echo "Unzipping input files..."

### Forward
fwd_zipped=${path}/final_pure_reads_1.fastq.gz
fwd_unzipped=${path}/final_pure_reads_1.fastq
echo "Unzipping ${fwd_zipped}..."
gunzip -c ${fwd_zipped} > ${fwd_unzipped}

### Reverse
rev_zipped=${path}/final_pure_reads_2.fastq.gz
rev_unzipped=${path}/final_pure_reads_2.fastq
echo "Unzipping ${rev_zipped}..."
gunzip -c ${rev_zipped} > ${rev_unzipped}


## Assemble reads

metawrap assembly -1 ${fwd_unzipped} -2 ${rev_unzipped} -m 300 -t 20 --megahit -o ${OutputDir}/$(basename "$sample")

echo "Assembly Complete. Cleaning up files.."


## Remove unzipped input files

echo "Removing unzipped input files ${fwd_unzipped} and ${rev_unzipped}.."

rm ${fwd_unzipped}
rm ${rev_unzipped}


## Zip output files

echo "Zipping output files..."

for file in "$OutputDir"/$(basename "$sample")/*.fastq; do gzip -v "$file"; done
for file in "$OutputDir"/$(basename "$sample")/*.fq; do gzip -v "$file"; done   # just in case intermediate files left over


## Create compressed tarball of megahit subdirectory (to save space)

echo "Creating tarball from ${OutputDir}/$(basename "$sample")/megahit"

tar -czf ${OutputDir}/$(basename "$sample")/megahit.tgz ${OutputDir}/$(basename "$sample")/megahit


## Finish

echo "Done."
