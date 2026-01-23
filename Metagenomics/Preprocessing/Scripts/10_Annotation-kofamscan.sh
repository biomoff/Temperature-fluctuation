#!/bin/bash

#SBATCH --partition=uoa-compute-priority
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G

### This was written for kofamscan version 1.3.0 ###

## Activate Conda environment

conda activate Genome-annotation


## Set directory and file name variables

export TMPDIR=${TMPDIR}/job_${SLURM_ARRAY_TASK_ID}
mkdir -p $TMPDIR


InputDir=$1
OutputDir=${InputDir}
ProfileDB=$2
KOfile=$3



samples=($InputDir/*.faa)                                  # Gets list of all samples
sample=${samples[(($SLURM_ARRAY_TASK_ID-1))]}        # Use array job task number to extract item from sample list and set as filename


## Run KofamScan on predicted genes
echo $sample
exec_annotation --tmp-dir $TMPDIR --profile ${ProfileDB} -k ${KOfile} --cpu 4 --format mapper -o ${OutputDir}/$(basename ${sample} .faa).txt ${sample}
