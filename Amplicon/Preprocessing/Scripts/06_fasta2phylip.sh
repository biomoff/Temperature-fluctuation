#!/bin/bash

# Activate Conda environment
conda activate bio

# Set variables
InputDir="05_ALIGNMENT"
OutputDir="06_PHYLIP"

# Make output directory
mkdir -p $OutputDir

# Convert fasta format to phylip format
python3 06_fasta2phylip.py -in $InputDir/tree.taxa.seqs.aligned.fasta -o $OutputDir/
