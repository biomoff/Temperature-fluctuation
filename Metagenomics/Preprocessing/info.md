# Aim of analysis
To identify microbial traits that correlate with fitness / abundance in fluctuating environments.

# Analysis flow
1. ReadQC performed to generate cleaned, high quality reads 
2. Short reads assembled into contigs using Megahit
3. Contigs binned into putative MAGs using Maxbin2 and MetaBAT2
4. Bins refined using Metawrap bin_refinement module
5. Each bin reassembled by mapping reads from original samples to the bins and assembling only those reads
6. Reassembled MAGs copied over to new folder
7. MAGs dereplicated at 96% ANI using dRep
8. Abundance of bins (MAGs) quantified in each sample by mapping raw reads to bins.
9. Taxonomic annotation of MAGs using the Genome Taxonomy Database Toolkit
10. Gene prediction using Prodigal and KEGG annotation of MAGs using Kofamscan
11. Combining KEGG (step 10) and Quantbins (step 8) results to single dataframe
12. GC content extraction from MAGs using custom biopython function
13. Mapping MAG genes to COG orthologues using eggNOG-mapper
14. Calculation of MAG genome size corrected for completeness and contamination
15. de novo tree building (by placement) of MAGs using the Genome Taxonomy Database Toolkit


# Conda environments

| Script | Environment |
|--------|-------------|
|01_readqc.sh| Metawrap-v1.3.2 |
|02_assembly.sh| Metawrap-v1.3.2 |
|03_binning.sh| Metawrap-v1.3.2 |
|04_bin_refinement.sh| Metawrap-v1.3.2 |
|05_bin_reassembly.sh| Metawrap-v1.3.2 |
|06-07_dereplication.sh| dRep-v3.5.0 |
|08_Quantbins.sh| Metawrap-v1.3.2 |
|09_Taxonomy.sh| GTDB-Tk_2.4.0 & Dendropy-v5.0.6 |
|10_Annotation-prodigal.sh| Genome-annotation |
|10_Annotation-kofamscan.sh| Genome-annotation |
|11_collate.sh| python |
|12_extract-GC.sh| biopython |
|13_COG-analysis.sh| eggNOG-mapper |
|14_genome-size.sh| python |
|15_Make-tree.sh| GTDB-Tk_2.4.0 |



# How I made the Bacteria_Archaea HMMER database

Note: ensure conda environment eggNOG-mapper is active for these steps to work.

1. Download Bacterial (2) and Archaeal (2157) taxa-specific databases using inbuilt function download_eggnog_database.py
`sbatch --wrap="download_eggnog_data.py -H -d 2 -y --data_dir ."`
`sbatch --wrap="download_eggnog_data.py -H -d 2157 -y --data_dir ."`

2. Move to hmmer directory made by these commands
`cd hmmer`

3. Download all .hmm files for Bacteria and Archaea
`wget --no-check-certificate http://eggnog5.embl.de/download/eggnog_5.0/per_tax_level/2/2_hmms.tar.gz`
`wget --no-check-certificate http://eggnog5.embl.de/download/eggnog_5.0/per_tax_level/2157/2157_hmms.tar.gz`

4. Extract HMMs
`tar -xvzf 2_hmms.tar.gz`
`tar -xvzf 2157_hmms.tar.gz`

5. Make new directory for Bacteria_Archaea database
`mkdir -p Bacteria_Archaea`

6. Combine .idmap files for Bacteria and Archaea
`cat 2/*.idmap 2157/*.idmap > Bacteria_Archaea/Bacteria_Archaea.hmm.idmap`

7. Reindex .idmap file
`awk -F' ' '{print NR-1, $2}' Bacteria_Archaea/Bacteria_Archaea.hmm.idmap > temp && mv temp Bacteria_Archaea/Bacteria_Archaea.hmm.idmap`

8. Copy over all fasta and hmm files
`cp 2/*.fa Bacteria_Archaea`
`cp 2157/*.fa Bacteria_Archaea`
`cp 2/*.hmm Bacteria_Archaea`
`cp 2157/*.hmm Bacteria_Archaea`

9. Loop through all COGs in idmap file and copy them to new combined .hmm file in that order
```
while read -r line; do
    hmm_name=$(echo ${line} | awk -F' ' '{print $2}')
    cat Bacteria_Archaea/"${hmm_name}.hmm" >> Bacteria_Archaea/Bacteria_Archaea.hmm
done < Bacteria_Archaea/Bacteria_Archaea.hmm.idmap
```

10. Remove strange text from .hmm file
`sed s/.faa.final_tree.fa//g Bacteria_Archaea/Bacteria_Archaea.hmm > temp && mv temp Bacteria_Archaea/Bacteria_Archaea.hmm`

11. Remove strange text from .idmap file
`sed s/.used_alg.fa//g Bacteria_Archaea/Bacteria_Archaea.hmm.idmap > temp && mv temp Bacteria_Archaea/Bacteria_Archaea.hmm.idmap`

12. Index .hmm file with hmmpress
```
cd Bacteria_Archaea
hmmpress Bacteria_Archaea.hmm
```

13. Verify all files present

`ls -l Bacteria_Archaea*`

Should have:
Bacteria_Archaea.hmm
Bacteria_Archaea.hmm.h3i
Bacteria_Archaea.hmm.h3f
Bacteria_Archaea.hmm.h3m
Bacteria_Archaea.hmm.h3p
Bacteria_Archaea.hmm.idmap


The database can then be specified in emapper.py calls with `-d Bacteria_Archaea`
