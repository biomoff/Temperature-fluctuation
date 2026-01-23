#!/bin/bash

#SBATCH --partition=uoa-compute-priority
#SBATCH --cpus-per-task=10
#SBATCH --mem=50G

### This was written for dRep version 3.5.0 ###

## Active Conda environment

conda activate dRep-v3.5.0


## Set directory and file name variables

InputDir=5_BIN-REASSEMBLY
MAGS=6_MAGS
drep=7_DEREPLICATED
threshold=0.96


echo "Input directory is ${InputDir}"
echo "MAGs moved to ${MAGS}"
echo "Dereplicated MAGs to be moved to ${drep}"


## Make output directories

mkdir -p ${MAGS}
mkdir -p ${drep}


## Copy all MAGs to common folder 6_MAGS

i=1

for folder in ${InputDir}/*
do
    for subfolder in ${folder}
    do
        mkdir -p ${subfolder}/final_bins

        # This is code I had to write because metawrap does not produce a final_bins folder
        for BIN in ${subfolder}/original_bins/*.fa
        do
            bin_number=$(echo "$BIN" | awk -F . '{ print $2 }')
            if ls $subfolder/reassembled_bins/*.fa 2>/dev/null | grep -q "bin.${bin_number}."
            then
                echo "$BIN is found in reassembled_bins"
            else
                cp "$BIN" ${subfolder}/final_bins/
                echo "Copying "$BIN" to final_bins"
            fi
            cp ${subfolder}/reassembled_bins/* ${subfolder}/final_bins
        done
        
        # Copy all final bins to MAGS folder
        for BIN in ${subfolder}/final_bins/*
        do 
            cp $BIN ${MAGS}/bin."$i".fa
            ((i=i+1))
        done
    done
done


## Do dereplication using dRep

dRep dereplicate -g ${MAGS}/*.fa -p 10 -comp 50 -con 10 -sa ${threshold} --run_tertiary_clustering ${drep}


echo "Dereplication complete."

