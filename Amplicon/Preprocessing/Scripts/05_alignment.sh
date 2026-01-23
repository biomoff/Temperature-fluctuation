#!/bin/bash

# Activate MAFFT environment
conda activate MAFFT

# Make output directory
mkdir -p 05_ALIGNMENT

# Align sequences using MAFFT
mafft --globalpair --maxiterate 1000 04_SUBSET/tree.taxa.seqs.fasta > 05_ALIGNMENT/tree.taxa.seqs.aligned.fasta
