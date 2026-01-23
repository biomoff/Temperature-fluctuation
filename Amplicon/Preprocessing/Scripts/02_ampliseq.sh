#!/bin/bash 

#SBATCH --partition=uoa-compute
#SBATCH --time=30:00:00 
#SBATCH --mem-per-cpu=16G 
#SBATCH --output=log.txt

#Script generated: 30-04-2024 12:00
#See https://nf-co.re/ampliseq/2.8.0/parameters for all params

module load singularity
module load nextflow

# Set variables
InputDir="01_CUTADAPT"
OutputDir="02_AMPLISEQ"

#Running forward orientation
NFX_ver=23.10.0 nextflow run nf-core/ampliseq \
        -r 2.8.0 -profile singularity \
        --input_folder $InputDir \
        --extension '/*_{1,2}.fastq.gz' \
        --FW_primer 'GTGYCAGCMGCCGCGGTAA' \
        --RV_primer 'GGACTACNVGGGTWTCTAAT' \
        --ignore_empty_input_files \
	--cutadapt_min_overlap 3 \
	--cutadapt_max_error_rate 0.1 \
	--double_primer	\
        --ignore_failed_trimming \
	--ignore_failed_filtering \
        --trunclenf 180 \
        --trunclenr 160 \
        --max_ee 2 \
	--min_len 150 \
        --outdir $OutputDir \
        -c '/uoa/scratch/shared/Soil_Microbiology_Group/libs/Nextflow/nextflow.config','/uoa/scratch/shared/Soil_Microbiology_Group/libs/Nextflow/Ampliseq/custom.config' \
	--dada_ref_tax_custom '/uoa/scratch/shared/Soil_Microbiology_Group/Reference_databases/dada2/greengenes.2022.10.dada2.train.fna.gz' \
        --dada_ref_tax_custom_sp '/uoa/scratch/shared/Soil_Microbiology_Group/Reference_databases/dada2/greengenes.2022.10.dada2.species.fna.gz' \
	--min_len_asv 245 \
	--max_len_asv 275 \
	--skip_qiime \
	--min_frequency 2 \
	--min_samples 2 \
