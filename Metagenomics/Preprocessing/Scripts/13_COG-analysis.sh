#!/bin/bash

#SBATCH --partition=uoa-compute-priority
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=0

### This was written for eggNOG-mapper version 2.1.12 ###


## Activate Conda environment

conda activate eggNOG-mapper


## Set input and output directories

InputDir=10_ANNOTATION
OutputDir=13_COG-ANALYSIS
Output=$(basename ${sample} .faa)
samples=(${InputDir}/*.faa)
sample=${samples[(($SLURM_ARRAY_TASK_ID-1))]}
DataDir=/uoa/scratch/shared/Soil_Microbiology_Group/Reference_databases/eggNOG
Database=Bacteria_Archaea
TmpDir=${TMPDIR}/${Output}


## Make output directory

mkdir -p ${OutputDir}
mkdir -p ${TmpDir}


## Run emapper

emapper.py --cpu 8 \
--override \
-m hmmer \
--database ${Database} \
--data_dir ${DataDir} \
--temp_dir ${TmpDir} \
-i ${sample} \
--output_dir ${OutputDir} \
-o ${Output}
