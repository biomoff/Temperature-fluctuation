#!/bin/bash

#SBATCH --partition=uoa-compute-priority
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=200G
#SBATCH --time=0

# AM 05/03/2025

### This was written for GTDB-Tk version 2.4.0 ###

## Activate Conda environment

conda activate GTDB-Tk_2.4.0


## Define input and output directories

OutputDir=15_TREE
BACTERIA=${OutputDir}/Bacteria
ARCHAEA=${OutputDir}/Archaea
GENOMES=7_DEREPLICATED/dereplicated_genomes

mkdir -p ${BACTERIA} ${ARCHAEA}


## Partition bacterial and archaeal genomes

cp ${GENOMES}/*.fa ${OutputDir}
mv ${OutputDir}/bin.192.fa ${ARCHAEA}
mv ${OutputDir}/bin.286.fa ${ARCHAEA}
mv ${OutputDir}/bin.82.fa ${ARCHAEA}
mv ${OutputDir}/*.fa ${BACTERIA}
  
  
## Build tree using GTDB-Tk for Bacteria

#gtdbtk de_novo_wf --genome_dir ${BACTERIA} --extension .fa --bacteria --outgroup_taxon p__Chloroflexota --out_dir ${OutputDir}/Bacterial_tree


## Build tree using GTDB-Tk for Archaea

gtdbtk de_novo_wf --genome_dir ${ARCHAEA} --extension .fa --archaea --outgroup_taxon p__Methanobacteriota --out_dir ${OutputDir}/Archaeal_tree
