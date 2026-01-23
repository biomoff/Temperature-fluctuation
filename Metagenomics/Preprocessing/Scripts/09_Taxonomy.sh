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

OutputDir=9_TAXONOMY
TAXFILE=taxonomy.tsv
GENOMES=7_DEREPLICATED/dereplicated_genomes
IdentifyOut=${OutputDir}/identify_out
AlignOut=${OutputDir}/align_out
ClassifyOut=${OutputDir}/classify_out
MashDB=${OutputDir}/mash_db.msh

mkdir -p ${OutputDir}


## Identify markers gene in genomes using the Genome Taxonomy Database Toolkit

gtdbtk identify --cpus 16 --genome_dir ${GENOMES} --extension fa --out_dir ${IdentifyOut}


## Align marker genes using the Genome Taxonomy Database Toolkit

gtdbtk align --cpus 16 --identify_dir ${IdentifyOut} --out_dir ${AlignOut}


## Classify genomes using the Genome Taxonomy Database Toolkit

gtdbtk classify --cpus 16 --genome_dir ${GENOMES} --extension fa --align_dir ${AlignOut} --out_dir ${ClassifyOut} --mash_db ${MashDB}


## Convert GTDB-Tk files into something useful
conda deactivate
conda activate Dendropy-v5.0.6

cat > ${OutputDir}/convert.py << END
import sys
sys.path.append('/uoa/scratch/shared/Soil_Microbiology_Group/libs/scripts/Python/genome_novelty')
from genome_novelty import formatInput
formatInput(bac= "${ClassifyOut}/gtdbtk.bac120.summary.tsv", ar= "${ClassifyOut}/gtdbtk.ar53.summary.tsv", save= True, outfile= "${OutputDir}/taxonomy.tsv")
END
python3 ${OutputDir}/convert.py
rm ${OutputDir}/convert.py
