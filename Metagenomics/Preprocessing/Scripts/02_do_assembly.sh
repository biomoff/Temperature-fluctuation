#!/bin/bash

#SBATCH --partition=uoa-compute
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --time=0

# AM 29/08/2024
# just a wrapper for submitting multiple MetaWRAP assembly jobs
# assumes necessary scripts (assembly.sh) is present

## Define input and output directories
InputDir="1_READ-QC"
OutputDir="2_ASSEMBLY"

## Get number of samples from input directory
nsamples=$(ls ${InputDir} | wc -l)
echo "$nsamples samples."

## Perform assembly for each sample individually
echo "Submitting assembly job for each..."

sbatch --wait --partition=uoa-compute --time=0 --array=1-${nsamples} Scripts/02_assembly.sh

echo "Done."
