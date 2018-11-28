#!/usr/bin/python

from Bio import SeqIO
import sys
import re

# to avoid weird piping error
from signal import signal, SIGPIPE, SIG_DFL
signal(SIGPIPE,SIG_DFL)

fastaFile = sys.argv[1]

genes = list(SeqIO.parse(fastaFile, 'fasta'))
groupName = re.search('OG[0-9]*', fastaFile).group()

gene = genes[0]
gene.id = groupName
gene.description = ''

SeqIO.write(gene, sys.stdout, 'fasta')
