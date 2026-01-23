#!/bin/bash
#SBATCH --partition=uoa-compute
#SBATCH --cpus-per-task=20
#SBATCH --mem=20G
#SBATCH --mail-type=ALL

export NUMEXPR_MAX_THREADS=20

# Activate Conda environment
conda activate partitionfinder2

# Set variables
InputDir="06_PHYLIP"
OutputDir="07_PARTITION"

# Copy alignment file to output folder for use as input
cp $InputDir/*.phylip $OutputDir/aligned_16S_seqs.phylip

python /uoa/scratch/shared/Soil_Microbiology_Group/libs/PartitionFinder2/partitionfinder-2.1.1/PartitionFinder.py -p 20 $OutputDir
