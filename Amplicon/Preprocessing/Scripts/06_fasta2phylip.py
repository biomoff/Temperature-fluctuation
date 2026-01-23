# For parsing input
import argparse

# For converting file types
import Bio.Seq as Seq
import Bio.SeqRecord as SeqRecord
from Bio import AlignIO
from Bio import SeqIO

parser = argparse.ArgumentParser(description="Program for conversion of Fasta (.fasta) alignment files to PHYLIP format alignment files")
parser.add_argument("-in", "--input", help= ".fasta alignment input file to be converted, Must contain '.fasta'")
parser.add_argument("-o", "--output", help= "name of output file; Must contain '.phylip'")

### assign input variables ###
args = parser.parse_args()
infile = args.input
outfile = args.output

###################################### MAIN PROGRAM START ######################################

def main():

    print('''
     _______
    | ______|            
    | |             _____  _           
    | |___   _____ |  ___|| |_   _____ 
    |  ___| /___  || |___ |  _\ /___  |
    | |      ___| ||___  || |    ___| |
    | |     | ___ | ___| || |__ | ___ |
    |_|     \_____||_____|\____|\_____|
                     _____ 
                    |___  | 
                     ___| |
                    |  ___|
                    | |___
                    |_____|
     ______
    |  __  \ _      _    _  _  _  _____ 
    | |__| || |    \ \  / /| ||_||  _  \\
    |  ____/| |____ \ \/ / | | _ | |_| |
    | |     |  __  \ \  /  | || ||  ___/
    | |     | |  | | / /   | || || |  
    |_|     |_|  |_|/_/    |_||_||_|
    
    A program for conversion of Fasta (.fasta) alignment files to PHYLIP format alignment files
    ''')

    # Check input format
    if infile.split('.')[-1] != 'fasta':
        err = "Input file must end with '.fasta'"
        raise ValueError(err)
    
    print(f"Valid input fasta file: {infile}\n")

    # Check output format
    if outfile.split(".")[-1] != 'phylip':
        err = "Output file must end with '.phylip'"
        raise ValueError(err)

    # read in fasta alignment file
    aln = AlignIO.read(infile, format= 'fasta')

    print("Successfully loaded input alignment\n")

    # Create output file
    a = open(outfile,'w')
    # Write phylip file header containing number of sequences and total length of alignment
    a.write(str(len(aln)) + '  ' + str(len(aln[0].seq)) + '\n')

    for record in aln:
        a.write(record.id + '  ' + str(record.seq) + '\n')
    
    print(f"Output Phylip format alignment saved to {outfile}\n")

    a.close()
###################################### MAIN PROGRAM END ########################################

if __name__ == "__main__":
    main()
    
