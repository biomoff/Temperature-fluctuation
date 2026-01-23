#!/bin/bash

#SBATCH --partition=uoa-compute-priority
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=1G

### This was written for Python v3.13.1 and Pandas v2.2.3 ###


## Activate Conda environment

conda activate python

## Set directory and file name variables

InputFile=7_DEREPLICATED/data_tables/genomeInfo.csv
OutputDir=14_GENOME-SIZE
OutputFile=${OutputDir}/genome_size.csv
GenomeSize=${OutputDir}/genomesize.py


## Make output directory

mkdir -p ${OutputDir}


## Run genome size calculation

cat > ${GenomeSize} << EOF
import pandas as pd

# Read in file containing genome size data
df = pd.read_csv("${InputFile}")

# Scale length by completeness
df['scaled_length'] = (df['length'] * (1-df['contamination']/100)) / (df['completeness']/100)

genome_size = df[['genome', 'scaled_length']]

genome_size.columns = [['Genomic bins','Genome size']]

genome_size.to_csv("${OutputFile}", index= False)
EOF

python3 ${GenomeSize}
rm ${GenomeSize}

sed s/.fa//g ${OutputFile} > temp && mv temp ${OutputFile}


