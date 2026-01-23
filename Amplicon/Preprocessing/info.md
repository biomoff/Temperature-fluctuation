# Aim of analysis
To evaluate the evidence for trade offs of thermal niche breadth in 16S V4 amplicon data

# Analysis flow

1. Cutadapt was run to remove any leftover sequencing adapters from library prep before processing with NF-core ampliseq pipeline
2. NF-core ampliseq pipeline was used to process the trimmed reads
3. Sequences not matching a database of 16S sequences were removed
4. Subset fasta sequence file to taxa with niche breadth, fold change, and optimum temperature data
5. MAFFT used to align 16S V4 sequences
6. Fasta format alignment converted to Phylip format for PartitionFinder2
7. PartitionFinder2 used to find the best partition scheme for tree building
8. RAxML-NG used to build a phylogenetic tree of 16S V4 sequences using the optimum model


# Conda environments

| Script | Environment |
|--------|-------------|
|01_cutadapt.sh| amplicon |
|02_ampliseq.sh| bio |
|03_asvcleaner.sh| bio |
|04_subset.py| bio |
|05_alignment.sh| MAFFT |
|06_fasta2phylip.sh| bio |
|07_partition.sh| partitionfinder2 |
|08a_tree_pre-run.sh| raxml-ng |
|08b_tree_run.sh| raxml-ng |

