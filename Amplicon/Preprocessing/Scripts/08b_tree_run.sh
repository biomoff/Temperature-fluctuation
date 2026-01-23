#!/bin/bash
#SBATCH --partition=uoa-compute
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=8G
#SBATCH --time=0

## Activate Conda environment

conda activate raxml-ng

# Set variables
InputDir="08_TREE/pre-run"
OutputDir="08_TREE/16S_tree"

# Run tree inference

raxml-ng --all --msa $InputDir/16S_tree.raxml.rba --model GTR+I+G --tree pars{10},rand{10} --bs-trees autoMRE --bs-metric TBE --threads auto --prefix $OutputDir --log DEBUG


