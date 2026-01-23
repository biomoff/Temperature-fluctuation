#!/bin/bash
#SBATCH --partition=uoa-compute
#SBATCH --time=00:30:00
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=4G

# Active Conda environment

conda activate raxml-ng


# Set variables

InputDir="05_ALIGNMENT"
OutputDir="08_TREE"

# Pre-run 
raxml-ng --parse --msa 05_ALIGNMENT/tree.taxa.seqs.aligned.fasta --model GTR+I+G --prefix $OutputDir/pre-run/16S_tree

