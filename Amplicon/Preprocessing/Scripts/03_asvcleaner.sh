# Activate Conda environment
conda activate bio

prefix="02_AMPLISEQ/dada2"

python3 /uoa/scratch/shared/Soil_Microbiology_Group/libs/scripts/Python/asvcleaner/asvcleaner.py -in "$prefix"/ASV_seqs.fasta -db /uoa/scratch/shared/Soil_Microbiology_Group/Reference_databases/BLAST/16S/16S -t "$prefix"/ASV_table.tsv --taxtable "$prefix"/ASV_tax.user.tsv --speciestable "$prefix"/ASV_tax_species.user.tsv

# rename output directory
mv cleaned 03_ASVCLEANER
