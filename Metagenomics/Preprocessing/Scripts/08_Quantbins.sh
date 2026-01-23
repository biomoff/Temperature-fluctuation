#!/bin/bash

#SBATCH --partition=spot-vhmem
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=500G
#SBATCH --time=0

# AM 29/08/2024

### This was written for metawrap version 1.3.2 ###

## Activate Conda environment

conda activate Metawrap-v1.3.2


## Define input and output directories

BINS=7_DEREPLICATED/dereplicated_genomes
READS=1_READ-QC
RENAMEDREADS=8_QUANT-BINS/READS
OutputDir=8_QUANT-BINS

mkdir -p ${RENAMEDREADS}


## Move and unzip cleaned reads

for file in $(find ${READS} | grep '.fastq.gz');do
ACTUAL_LOCATION=$(readlink -f ${file})            # Get the full path of the file being linked to in the InputDir
FILESTART=$(echo $file | awk -F '/' '{ print $2 }')
FILEEND=$(echo $file | awk -F '/' '{ print $3 }' | awk -F '_' '{ print $4 }')
FILENAME=${FILESTART}_${FILEEND}
cp ${ACTUAL_LOCATION} ${RENAMEDREADS}/${FILENAME}
gunzip ${RENAMEDREADS}/${FILENAME}                
done


## Run Quantbins module

metawrap quant_bins -t 8 -b ${BINS} -o ${OutputDir} ${RENAMEDREADS}/*.fastq     # omitting assembly file due to bin reassembly step that changes contig names and means reads fail to map to some MAGs

echo "Done."
