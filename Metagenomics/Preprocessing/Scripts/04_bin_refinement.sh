#!/bin/bash

#SBATCH --partition=uoa-compute-priority
#SBATCH --cpus-per-task=10
#SBATCH --mem=100G

### This was written for metawrap version 1.3.2 ###

## Activate Conda environment

conda activate Metawrap-v1.3.2


## Set directory and file name variables

InputDir=3_INITIAL-BINNING
OutputDir=4_BIN-REFINEMENT

samples=($InputDir/*)                                  # Gets list of all samples
sample=${samples[(($SLURM_ARRAY_TASK_ID-1))]}        # Use array job task number to extract item from sample list and set as filename
sample=$(basename $sample)

echo "Input directory is ${InputDir}"
echo "Output directory is ${OutputDir}"
echo "Sample is ${sample}"


## Make output directories

mkdir -p ${OutputDir}/${sample}


## Perform bin reassembly

metawrap bin_refinement -o ${OutputDir}/${sample} -t 10 -m 100 -A ${InputDir}/${sample}/metabat2_bins/ -B ${InputDir}/${sample}/maxbin2_bins/ -c 50 -x 10

echo "Bin Refinement Complete."

echo "Done."
