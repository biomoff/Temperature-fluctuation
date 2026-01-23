#!/bin/bash

#SBATCH --partition=uoa-compute-priority
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --time=0

# AM 29/10/2024
# just a wrapper for submitting multiple MetaWRAP bin refinement jobs
# assumes necessary scripts (bin_refinement.sh) is present

## Define input and output directories

InputDir="2_ASSEMBLY"

## Get number of samples from input directory
nsamples=$(ls ${InputDir} | wc -l)
echo "$nsamples samples."

## Perform binning for each sample individually
echo "Submitting bin refinement job for each..."

sbatch --wait --partition=uoa-compute --time=0 --array=1-${nsamples} Scripts/04_bin_refinement.sh

echo "Done."
