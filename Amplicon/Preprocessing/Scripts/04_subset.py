from Bio import AlignIO, SeqIO
from Bio.SeqRecord import SeqRecord
from Bio.Seq import Seq
import os

# Make output directory
os.mkdir("04_SUBSET")

# Import sequences
records = SeqIO.parse('03_ASVCLEANER/cleaned.seqs.fasta', format= 'fasta')

# Import taxon list
taxa = []
with open('taxa.txt', 'r') as fl:
    for line in fl.readlines():
        taxa.append(line.strip())

# Output taxa matching list to file
with open('04_SUBSET/tree.taxa.seqs.fasta', 'w') as fl:
    for record in records:
        if record.id in taxa:
            fl.write(f">{record.id}\n")
            fl.write(str(record.seq))
            fl.write("\n")
