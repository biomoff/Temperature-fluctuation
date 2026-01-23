#!/bin/bash

#SBATCH --partition=uoa-compute-priority
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G

### This was written for Prodigal version 2.6.3 ###

## Activate Conda environment

conda activate Genome-annotation


## Set directory and file name variables

InputDir=$1
OutputDir=$2

samples=($InputDir/*)                                  # Gets list of all samples
sample=${samples[(($SLURM_ARRAY_TASK_ID-1))]}        # Use array job task number to extract item from sample list and set as filename


## Predict coding sequences using Prodigal
echo $sample
prodigal -i ${sample} -a ${OutputDir}/$(basename ${sample} .fa).faa -o ${OutputDir}/$(basename ${sample} .fa).gbk
