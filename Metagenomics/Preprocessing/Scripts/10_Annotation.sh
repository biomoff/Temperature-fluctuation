#!/bin/bash

#SBATCH --partition=uoa-compute-priority
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=200G
#SBATCH --time=0

# AM 12/03/2025

### This was written for KofamScan version 1.3.0 and Prodigal version 2.6.3 ###

## Activate Conda environment

conda activate Genome-annotation


## Define input and output directories

InputDir=7_DEREPLICATED_96/dereplicated_genomes
OutputDir=10_ANNOTATION
ProfileDB=/uoa/scratch/shared/Soil_Microbiology_Group/libs/KOfam/profiles
KOfile=/uoa/scratch/shared/Soil_Microbiology_Group/libs/KOfam/ko_list


mkdir -p ${OutputDir}

## Predict coding sequences using Prodigal as array job
nsamples=$(ls ${InputDir}/*.fa | wc -l)
echo "Running Prodigal on ${nsamples} genomes to predict coding sequences.."
sbatch --wait --partition=uoa-compute-priority --output=/dev/null --time=0 --array=1-${nsamples} Scripts/10_Annotation-prodigal.sh ${InputDir} ${OutputDir}


## Run KofamScan on predicted genes as array job
nsamples=$(ls ${OutputDir}/*.faa | wc -l)
echo "Running KofamScan on ${nsamples} genomes to predict KEGG orthologues.."
sbatch --wait --output=/dev/null --partition=uoa-compute-priority --time=0 --array=1-${nsamples} Scripts/10_Annotation-kofamscan.sh ${OutputDir} ${ProfileDB} ${KOfile}

## Add header line (column names) to KofamScan output files
for file in ${OutputDir}/*.txt; do
echo 'GENE	KO' | cat - ${file} > temp && mv temp ${file}
done 


## Collate results to single presence / absence table (KO_summary.tsv) and list (KO_list.txt) for KEGGDecoder
conda deactivate
conda activate python
echo "Collating KofamScan output.."
cat > ${OutputDir}/collate.py << DELIM
# Import libraries
import pandas as pd
import os
import numpy as np

# Get list of output files from KofamScan
files = os.scandir('${OutputDir}')

all_KOs = []

# Get all KOs annotated for all MAGs
with open('${OutputDir}/KO_list.txt', 'w') as fl:
    for file in files:
        if '.txt' in file.name:
            if file.name == 'KO_list.txt':
                continue
            data = pd.read_csv(file, sep= '\t')
            KO_list = data['KO'].unique()
            name = file.name.split('.txt')[0]
            for i,KO in enumerate(KO_list):
                KO = str(KO)
                if KO != 'nan':
                    fl.write(f"{name}_{i}\t{KO}\n")
                    all_KOs.append([name,KO])

# Convert to dataframe
df = pd.DataFrame(all_KOs, columns= ['Genome', 'KO'])

# Drop NA values
df = df.dropna(axis= 0)

# Convert to wide format
df['Present'] = 1
df = df.pivot(index= 'Genome', columns= 'KO', values= 'Present').fillna(0)
for column in df.columns:
    df[column] = df[column].astype(int)

# Export to file
df.to_csv("${OutputDir}/KO_summary.tsv", sep= '\t')
DELIM

python3 ${OutputDir}/collate.py
rm ${OutputDir}/collate.py

## Run KEGGDecoder to group the KOs into functional modules
conda deactivate
conda activate KEGGDecoder
echo "Running KEGGDecoder to group KEGG Orthologues into KEGG Modules.."
KEGG-decoder -i ${OutputDir}/KO_list.txt -o ${OutputDir}/KEGG_Modules_out.tsv -v static


echo "Done."
