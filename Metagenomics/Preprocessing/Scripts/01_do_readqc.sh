#!/bin/bash

#SBATCH --partition=uoa-compute-priority
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --time=0

#AM 05/07/2024
#just a wrapper for submitting multiple MetaWRAP ReadQC jobs
#assumes necessary scripts (readqc.sh) is present

# Input directory is provided directly at command line. E.g. sbatch Scripts/do_readqc.sh path/to/input/directory
nsamples=$(ls "$1"/*_1.fastq.gz | wc -l)

echo "$nsamples samples."

echo "Submitting ReadQC job for each..."

# Run array job for the number of samples
sbatch --wait --partition=uoa-compute-priority --time=0 --array=1-$nsamples --cpus-per-task=2 --mem-per-cpu=8G Scripts/01_readqc.sh >> slurm-out/do_readqc.out

echo "Done."
