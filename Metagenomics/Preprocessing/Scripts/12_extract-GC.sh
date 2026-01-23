#!/bin/bash

#SBATCH --partition=uoa-compute-priority
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=4G

### This was written for Python v3.11.5 and Biopython v1.81 ###


## Activate Conda environment

conda activate biopython

## Set directory and file name variables

InputDir=7_DEREPLICATED/dereplicated_genomes/
OutputDir=12_GC-CONTENT
OutputFile=${OutputDir}/gc-content.csv


## Make output directory

mkdir -p ${OutputDir}


## Create temporary python file
## for extracting GC content

cat > gc.py << EOF
from Bio import SeqIO, SeqRecord
import numpy as np
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('-in', '--input')
parser.add_argument('-out', '--output')

args = parser.parse_args()
infile = args.input
outfile = args.output

bin = infile.split('/')[-1].split('.f')[0]
file = SeqIO.parse(infile,format= 'fasta')

with open(outfile, 'a') as fl:
    g = 0
    c = 0
    a = 0
    t = 0
    for record in file.records:
        for base in record:
            if base.lower() == 'g':
                g += 1
            elif base.lower() == 'c':
                c += 1
            elif base.lower() == 'a':
                a += 1
            elif base.lower() == 't':
                t += 1

    gc = g + c
    at =  a + t

    gc_content = np.round((gc / (gc + at)) * 100,2)
    fl.write(f"{bin},{gc_content}\n")
EOF


## Create output file
cat "Genomic bins,GC" > ${OutputFile}


## Extract GC content for each MAG
for file in ${InputDir}/*.fa; do python3 gc.py -in ${file} -out ${OutputFile}; done


## clean up

rm gc.py
