# Rapid Temperature Fluctuation Favours Soil Microbes with Higher Niche Breadths
  
This Github page contains all the necessary code to reproduce the analyses from the above publication.
 
   
## Preprocessing  
  
Processing of raw data to feature tables (for amplicon data) or metagenome-assembled genomes and MAG data (for metagenomics) is performed using the code in:  
`Amplicon/Preprocessing`
`Metagenomics/Preprocessing`

Preprocessing scripts are provided in `.sh` format, in the `Scripts` subdirectories, intended for use in a HPC environment running [Slurm](https://slurm.schedmd.com/documentation.html).  
  
All `.sh` files are prefixed with a number indicating the order in which they are run. Output from one script will, in most cases, become the input for the subsequent step. 
  
Descriptions of the purpose of each script, along with the environment files they rely on, are provided in:
`Amplicon/Preprocessing/info.md`
`Metagenomics/Preprocessing/info.md`
  
### Environment files
  
The [Conda](https://docs.conda.io/) used for each preprocessing step can be found in:
`Amplicon/Preprocessing/Environments`
`Metagenomics/Preprocessing/Environments`
  
*Note: there is no guarantee that the exact combination of software versions will be compatible with your / your institution's setup.*
  

## Data Analysis 
  
All relevant outputs from preprocessing steps are provided in this repository, in `Amplicon/Datasets` and `Metagenomics/MAG_data`.  

Code for data analysis is provided and run in [Jupyter](https://jupyter.org/) Notebooks. These are numbered in order in which they must be run to reproduce the results - the output of one notebook becomes the input for the next in most cases.
  
### Environment files
  
Each notebook has its own corresponding [Conda](https://docs.conda.io/) environment file of the same name. These can be found in:
`Amplicon/Environments`
`Metagenomics/Environments`
  
For example, `01_Alpha-diversity.ipynb` is run with the environment `01_Alpha-diversity.yaml`.
  
There is only a single notebook and environment file for the analysis of metagenomic data.
  
*Note: there is no guarantee that the exact combination of software versions will be compatible with your setup.*
