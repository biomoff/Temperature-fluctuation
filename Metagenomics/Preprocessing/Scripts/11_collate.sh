#!/bin/bash

#SBATCH --partition=uoa-compute-priority
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=8G

### This was written for Python v3.13.1 and Pandas v2.2.3 ###


## Activate Conda environment

conda activate python


## Set directory and file name variables

metadata=SEQ21_metadata.csv
abundance=8_QUANT-BINS/bin_abundance_table.tab
KEGG=10_ANNOTATION/KEGG_Modules_out.tsv
OutputDir=11_COLLATED
OutputFile=${OutputDir}/Collated_MAG_data.csv

## Make output directories

mkdir -p "$OutputDir"


## Collate results from Quantbins and KEGG annotation

cat > collate.py << EOF
import pandas as pd

# Import metadata
mapping = pd.read_csv("${metadata}")
mapping = dict(zip(mapping['Sample'],mapping['Scale of fluctuation']))

# Import Abundance data
abundance = pd.read_csv("${abundance}", sep= '\t')

# Convert abundance to long format
abundance = abundance.melt(id_vars= 'Genomic bins', var_name= 'Sample', value_name= 'Abundance')

# Create treatment and sample type columns
abundance['Treatment'] = abundance['Sample'].apply(lambda x: mapping[x[1:]])
abundance['Sample type'] = abundance['Sample'].apply(lambda x: x.split('-')[1])

# Import KEGG module data
kegg = pd.read_csv("${KEGG}", sep= '\t')
kegg.rename({'Function': 'Genomic bins'}, axis= 1, inplace= True)

# Merge abundance and KEGG data
data = pd.merge(left= abundance, right= kegg, how= 'left', on= 'Genomic bins')

# Export to file
data.to_csv("${OutputFile}", index= False)
EOF
 
python3 collate.py
rm collate.py
