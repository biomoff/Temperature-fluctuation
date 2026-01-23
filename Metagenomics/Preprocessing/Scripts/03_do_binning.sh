#!/bin/bash

#SBATCH --partition=uoa-compute
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --time=0

# AM 10/09/2024
# just a wrapper for submitting multiple MetaWRAP binning jobs
# assumes necessary scripts (binning.sh) is present

## Define input and output directories

InputDir="2_ASSEMBLY"

## Get number of samples from input directory
nsamples=$(ls ${InputDir} | wc -l)
echo "$nsamples samples."

## Perform binning for each sample individually
echo "Submitting binning job for each..."

sbatch --wait --partition=uoa-compute --time=0 --array=1-${nsamples} Scripts/03_binning.sh

echo "Done."
