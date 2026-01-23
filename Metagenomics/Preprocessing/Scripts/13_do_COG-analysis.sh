#!/bin/bash

#SBATCH --partition=uoa-compute-priority
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --time=0

# AM 11/04/2025
# just a wrapper for submitting multiple eggNOG-mapper emapper jobs
# assumes necessary script (13_COG-analysis.sh) is present

### This was written for eggNOG-mapper version 2.1.12 ###


## Define input and output directories

InputDir="10_ANNOTATION"

## Get number of samples from input directory
nsamples=$(ls ${InputDir}/*.faa | wc -l)
echo "$nsamples samples."

## Perform  mapping for each sample
echo "Submitting eggNOG-mapper emapper.py job for each..."

sbatch --wait --partition=uoa-compute-priority --time=0 --array=1-${nsamples} Scripts/13_COG-analysis.sh

echo "Done."
